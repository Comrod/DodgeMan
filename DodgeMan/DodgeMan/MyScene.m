//
//  MyScene.m
//  CoderDojo
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "MyScene.h"
#import "EndGameScene.h"

static const uint32_t redBallCategory =  0x1 << 0;
static const uint32_t playerCategory =  0x1 << 1;
static const uint32_t groundCategory =  0x1 << 2;

//Vector Calculations
static inline CGPoint rwAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}
static inline CGPoint rwAddMoveX(CGPoint a, float b)
{
    return CGPointMake(a.x + b, a.y);
}
static inline CGPoint rwAddX(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, b.y);
}
static inline CGPoint rwSub(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}
static inline CGPoint rwMult(CGPoint a, float b)
{
    return CGPointMake(a.x * b, a.y * b);
}
static inline CGPoint rwMultX(CGPoint a, float b)
{
    return CGPointMake(a.x * b, a.y);
}
static inline float rwLength(CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}

//Makes vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a)
{
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        //Sets player location
        playerLocX = 150;
        playerLocY = 300;
        
        //Sets player score
        score = 0;
        
        //Set Background
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        /*SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiP5"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];*/
        
        //Set Ground
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        ground.position = CGPointMake(CGRectGetMidX(self.frame), 34);
        ground.xScale = 0.5;
        ground.yScale = 0.5;
        [self addChild:ground];
        
        //Set Ground Physics
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.categoryBitMask = groundCategory;
        ground.physicsBody.contactTestBitMask = playerCategory;
        ground.physicsBody.collisionBitMask = 0;
        ground.physicsBody.usesPreciseCollisionDetection = YES;
        
        
        //Player
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        self.playerSprite.position = CGPointMake(playerLocX, playerLocY);
        [self addChild:self.playerSprite];
        
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        self.scoreLabel.text = @"0";
        self.scoreLabel.fontSize = 40;
        self.scoreLabel.fontColor = [SKColor blackColor];
        self.scoreLabel.position = CGPointMake(50, 260);
        [self addChild:self.scoreLabel];
        
        //Pause Button
        self.pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
        self.pauseButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40);
        self.pauseButton.name = @"pauseButton";
        //[self addChild:self.pauseButton];
        
        //Set Player Physics
        self.playerSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerSprite.size];
        self.playerSprite.physicsBody.dynamic = YES;
        self.playerSprite.physicsBody.categoryBitMask = playerCategory;
        self.playerSprite.physicsBody.contactTestBitMask = redBallCategory;
        self.playerSprite.physicsBody.collisionBitMask = 0;
        self.playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
        
        //Sets gravity to true
        isGravityOccurring = NO;
        
        
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
    NSLog(@"Actual Y: %i", actualY);
    
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
        self.scoreString = [NSString stringWithFormat:@"%i", score];
        self.scoreLabel.text = self.scoreString;
        NSLog(@"Score was incremented. Score is now %d", score);
    }];
    [redBall runAction:[SKAction sequence:@[actionMove, ballCross, actionMoveDone]]];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1.5) {
        self.lastSpawnTimeInterval = 0;
        [self addBall];
    }
}

-(void)gameLoop
{
    //[self gravity];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
    // Handle time delta.
    //Prevents bad stuff happening
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 0.05) { // more than a second since last update
        timeSinceLast = 1.0 / 120.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    //Game Loop
    [self gameLoop];
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

-(void)gravity
{
    didRunFalling = NO;
    
    if (isGravityOccurring)
    {
        fallDirection = rwNormalize(self.playerSprite.position);
        fallAmount = rwMult(fallDirection, 100);
        fallDestination = rwAddX(fallAmount, self.playerSprite.position);
        CGPoint tempFallDest;
        tempFallDest = CGPointMake(200, 70);
        if (fallDestinationReal.y < 88)
        {
            fallDestinationReal.y = 88;
        }
        
        if (!self.playerSprite.hasActions)
        {
            while (!didRunFalling)
            {
                SKAction *actionGravity = [SKAction moveTo:tempFallDest duration:0.2];
                [self.playerSprite runAction:[SKAction sequence:@[actionGravity]]];
                didRunFalling = YES;
            }
        }
    }
    
    if (self.playerSprite.position.y > 88)
    {
        isGravityOccurring = YES;
    }
}

-(void)playerMoveRight
{
    self.playerSprite.position = rwAddMoveX(self.playerSprite.position, 5.0);
    //SKAction *actionMove = [SKAction moveTo:moveDist duration:realMoveDuration];
    //[self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
    NSLog(@"Player moved right");
}

-(void)playerMoveLeft
{
    self.playerSprite.position = rwAddMoveX(self.playerSprite.position, -5.0);
    //SKAction *actionMove = [SKAction moveTo:moveDist duration:realMoveDuration];
    //[self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
    NSLog(@"Player moved left");
}

NSDate *startTime;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    [super touchesBegan:touches withEvent:event];
    
    //Starts Timer
    startTime = [NSDate date];

    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        locationTouched = location;
        
        //Checks if touch is left or right of the player sprite
        if (location.x < self.playerSprite.position.x)
        {
            didTapLeft = YES;
            isMoving = YES;
            NSLog(@"Tapped left of player");
            
            //Moves player left
            while (isMoving)
            {
                [self performSelector:@selector(playerMoveLeft) withObject:nil afterDelay:2];
            }
            
        }
        else if (location.x > self.playerSprite.position.x)
        {
            
            didTapLeft = NO;
            isMoving = YES;
            NSLog(@"Tapped right of player");
            
            //Moves player right
            while (isMoving)
            {
                [self performSelector:@selector(playerMoveRight) withObject:nil afterDelay:0.5];
            }
        }
        
        //Pauses Scene
        if ([node.name isEqualToString:@"pauseButton"])
        {
            NSLog(@"Pause button pressed");
        }
        
        isGravityOccurring = YES;
    }
    
    NSLog(@"Touch startd");
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    [super touchesEnded:touches withEvent:event];
    
    elapsedTime = [startTime timeIntervalSinceNow];
    elapsedTimeString = [NSString stringWithFormat:@"Elapsed time: %f", elapsedTime];
    NSLog(@"%@", elapsedTimeString);
    
    for (UITouch *touch in touches)
    {
        //CGPoint location = [touch locationInNode:self];
        //SKNode *node = [self nodeAtPoint:location];
        
        //locationTouched = location;
        
        /*//Checks if touch is left or right of the player sprite
        if (location.x < self.playerSprite.position.x)
        {
            didTapLeft = YES;
            NSLog(@"Tapped left of player");
            [self playerMoveLeft];
        }
        else if (location.x > self.playerSprite.position.x)
        {
            didTapLeft = NO;
            NSLog(@"Tapped right of player");
            [self playerMoveRight];
        }
        
        
        //Pauses Scene
        if ([node.name isEqualToString:@"pauseButton"])
        {
            NSLog(@"Pause button pressed");
        }
        
        isGravityOccurring = YES;
        //Moves and animates player
        //int velocity = elapsedTime * -3000;
        int velocity = 480.0/1.0;
        NSLog(@"Velocity: %i", velocity);
        float realMoveDuration = self.size.width / velocity;
        SKAction *actionMove = [SKAction moveTo:location duration:realMoveDuration];
        [self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
        

        isGravityOccurring = YES;
        
        didRunFalling = NO;*/
    }
    
    isMoving = NO;
    NSLog(@"Touch ended");
}

//Collision between Ball and Player
- (void)redBall:(SKSpriteNode *)redBall didCollideWithPlayer:(SKSpriteNode *)playerSprite
{
    NSLog(@"Player died");
    [redBall removeFromParent];
    [playerSprite removeFromParent];
    
    SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
    SKScene *endGameScene = [[EndGameScene alloc] initWithSize:self.size gameEnded:YES];
    [self.view presentScene:endGameScene transition: reveal];
}

//Collision between Player and Ground
- (void)playerSprite:(SKSpriteNode *)playerSprite didCollideWithGround:(SKSpriteNode *)ground
{
    //Turns off gravity
    isGravityOccurring = NO;
}

- (void)setMinCoords
{
    CGPoint minCoords;
    minCoords = CGPointMake(self.playerSprite.position.y, 88);
    self.playerSprite.position = minCoords;
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
    
    //Ball collides with player
    if ((firstBody.categoryBitMask & redBallCategory) != 0 && (secondBody.categoryBitMask & playerCategory) != 0)
    {
        [self redBall:(SKSpriteNode *) firstBody.node didCollideWithPlayer:(SKSpriteNode *) secondBody.node];
    }
    
    //Player collides with ground
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & groundCategory) != 0)
    {
        [self playerSprite:(SKSpriteNode *) firstBody.node didCollideWithGround:(SKSpriteNode *) secondBody.node];
        isPlayerInGround = YES;
        NSLog(@"Player is in ground");
    }
    
}

@end
