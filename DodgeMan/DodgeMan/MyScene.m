//
//  MyScene.m
//  DodgeMan
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "MyScene.h"
#import "EndGameScene.h"

static const uint32_t redBallCategory =  0x1 << 0;
static const uint32_t playerCategory =  0x1 << 1;

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Sets up data storage
        self.storeData = [NSUserDefaults standardUserDefaults];
        
        //Sets gravity
        self.physicsWorld.gravity = CGVectorMake(0,-2);
        self.physicsWorld.contactDelegate = self;
        
        //Set Background
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        
        //Set Ground
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        ground.position = CGPointMake(CGRectGetMidX(self.frame), 34);
        ground.xScale = 0.5;
        ground.yScale = 0.5;
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.usesPreciseCollisionDetection = YES;

        //Player
        self.posX = 50;
        self.posY = 88;
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        self.playerSprite.position = CGPointMake(self.posX, self.posY);
        
        //Set Player Physics
        self.playerSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerSprite.size];
        self.playerSprite.physicsBody.dynamic = NO;
        self.playerSprite.physicsBody.categoryBitMask = playerCategory;
        self.playerSprite.physicsBody.contactTestBitMask = redBallCategory;
        self.playerSprite.physicsBody.collisionBitMask = 0;
        self.playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
        
        //Score Label
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.scoreLabel.text = @"0";
        self.scoreLabel.fontSize = 40;
        self.scoreLabel.fontColor = [SKColor blackColor];
        self.scoreLabel.position = CGPointMake(50, 260);
        
        //Pause Button
        self.pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
        self.pauseButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40);
        self.pauseButton.name = @"pauseButton";
        
        //Pause Label
        NSString *pauseMessage;
        pauseMessage = @"Game Paused";
        self.pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.pauseLabel.text = pauseMessage;
        self.pauseLabel.fontSize = 40;
        self.pauseLabel.fontColor = [SKColor blackColor];
        self.pauseLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //Set score
        self.score = 0;
        
        //Add nodes
        [self addChild:ground];
        [self addChild:self.playerSprite];
        [self addChild:self.scoreLabel];
        [self addChild:self.pauseButton];
        
    }
    return self;
}

//Add Red Ball
-(void)addBall
{
    SKSpriteNode *redBall = [SKSpriteNode spriteNodeWithImageNamed:@"locationIndicator"];
    int minY = redBall.size.height / 2;
    int maxY = self.frame.size.height - redBall.size.height / 2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    //Initiates red ball offscreen
    if (actualY >= 75)
    {
        //Prevents balls from spawning in the ground
        redBall.position = CGPointMake(self.frame.size.width + redBall.size.width/2, actualY);
        [self addChild:redBall];
    }
    redBall.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:redBall.size.width/2];
    redBall.physicsBody.dynamic = YES;
    redBall.physicsBody.categoryBitMask = redBallCategory;
    redBall.physicsBody.contactTestBitMask = playerCategory;
    redBall.physicsBody.collisionBitMask = 0;
    redBall.physicsBody.affectedByGravity = NO;
    redBall.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Determine speed of red ball
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-redBall.size.width/2, actualY) duration:actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *ballCross = [SKAction runBlock:^{
        self.score++;
        self.scoreString = [NSString stringWithFormat:@"%i", self.score];
        self.scoreLabel.text = self.scoreString;
        NSLog(@"Score was incremented. Score is now %d", self.score);
    }];
    [redBall runAction:[SKAction sequence:@[actionMove, ballCross, actionMoveDone]]];
}

- (void)pauseScene
{
    self.paused = YES;
    [self addChild:self.pauseLabel];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.35) {
        self.lastSpawnTimeInterval = 0;
        [self addBall];
    }
}

//Update Loop
-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Handle time delta.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { //More than a second since last update
        timeSinceLast = 1.0 / 120.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

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
        SKNode *node = [self nodeAtPoint:location];
        
        //Runs when pause button is pressed
        if ([node.name isEqualToString:@"pauseButton"])
        {
            NSLog(@"Pause button pressed");
            if (!self.paused)
            {
                [self pauseScene];
            }
            else if (self.paused)
            {
                self.paused = NO;
                [self.pauseLabel removeFromParent];
            }
        }
        else
        {
            //Prevents destination from being in the ground
            if (location.y < 88)
            {
                location.y = 88;
            }
            
            //Moves and animates player
            int velocity = 1000.0/1.0;
            NSLog(@"Velocity: %i", velocity);
            float realMoveDuration = self.size.width / velocity;
            SKAction *actionMove = [SKAction moveTo:location duration:realMoveDuration];
            [self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
        }
    }
    
    NSLog(@"Touch ended");
}

//Collision between ball and player - player dies
- (void)redBall:(SKSpriteNode *)redBall didCollideWithPlayer:(SKSpriteNode *)playerSprite
{
    
    NSLog(@"Player died");
    [redBall removeFromParent];
    [playerSprite removeFromParent];
    
    //Stores Final score
    [self.storeData setObject:self.scoreString forKey:@"scoreStringKey"];
    
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    SKScene *endGameScene = [[EndGameScene alloc] initWithSize:self.size];
    [self.view presentScene:endGameScene transition: reveal];
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
    
    //Red ball collides with the player
    if ((firstBody.categoryBitMask & redBallCategory) != 0 && (secondBody.categoryBitMask & playerCategory) != 0)
    {
        [self redBall:(SKSpriteNode *) firstBody.node didCollideWithPlayer:(SKSpriteNode *) secondBody.node];
        NSLog(@"Player and ball collided");
    }
}

@end
