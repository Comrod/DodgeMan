//
//  MyScene.m
//  CoderDojo
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "MyScene.h"

static const uint32_t playerCategory     =  0x1 << 0;
static const uint32_t redBallCategory    =  0x1 << 1;

int score = 0;

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        //Sets player location
        playerLocX = 50;
        playerLocY = 180;
        
        //Background Color
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        
        //Character
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        self.playerSprite.position = CGPointMake(playerLocX, playerLocY);
        [self addChild:self.playerSprite];
        
        //Set Player Physics
        self.playerSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerSprite.size];
        self.playerSprite.physicsBody.dynamic = YES;
        self.playerSprite.physicsBody.categoryBitMask = redBallCategory;
        self.playerSprite.physicsBody.contactTestBitMask = playerCategory;
        self.playerSprite.physicsBody.collisionBitMask = 0;
        self.playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
        
        //Prevents spazzing
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}

-(void)addBall
{
    SKSpriteNode *redBall = [SKSpriteNode spriteNodeWithImageNamed:@"locationIndicator"];
    int minY = redBall.size.height / 2;
    int maxY = self.frame.size.height - redBall.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //Initiates red ball offscreen
    redBall.position = CGPointMake(self.frame.size.width + redBall.size.width/2, actualY);
    [self addChild:redBall];
    
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:redBall.size.width/2];
    redBall.physicsBody.dynamic = YES;
    redBall.physicsBody.categoryBitMask = redBallCategory;
    redBall.physicsBody.contactTestBitMask = playerCategory;
    redBall.physicsBody.collisionBitMask = 0;
    
    //Determine speed of red ball
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-redBall.size.width/2, actualY) duration:actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *ballCross = [SKAction runBlock:^{
        score++;
        NSLog(@"Score was incremented. Score is now %d", score);
    }];
    [redBall runAction:[SKAction sequence:@[actionMove, ballCross, actionMoveDone]]];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;
        [self addBall];
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Handle time delta.
    //Prevents bad stuff happening
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

NSDate *startTime;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    [super touchesBegan:touches withEvent:event];
    
    //Starts Timer
    startTime = [NSDate date];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    [super touchesEnded:touches withEvent:event];
    
    NSTimeInterval elapsedTime = [startTime timeIntervalSinceNow];
    NSString *elapsedTimeString = [NSString stringWithFormat:@"Elapsed time: %f", elapsedTime];
    NSLog(@"%@", elapsedTimeString);
    
    
    for (UITouch *touch in touches)
    {
        //Gets location of touch
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch Location X: %f \n Touch Location Y: %f", location.x, location.y);
        
        
        //Moves and animates player
        int velocity = elapsedTime * -2500;
        NSLog(@"Velocity: %i", velocity);
        float realMoveDuration = self.size.width / velocity;
        SKAction *actionMove = [SKAction moveTo:location duration:realMoveDuration];
        //[self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
        
        [self.playerSprite runAction:[SKAction sequence:@[actionMove]]completion:^{
            isActionCompleted = YES;
        }];
        
    }
    NSLog(@"Touch ended");
}

- (void)redBall:(SKSpriteNode *)redBall didCollideWithPlayer:(SKSpriteNode *)playerSprite {
    NSLog(@"Hit");
    [redBall removeFromParent];
    [playerSprite removeFromParent];
    
    NSLog(@"You died");
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & redBallCategory) != 0 && (secondBody.categoryBitMask & playerCategory) != 0)
    {
        [self redBall:(SKSpriteNode *) firstBody.node didCollideWithPlayer:(SKSpriteNode *) secondBody.node];
    }
}

@end
