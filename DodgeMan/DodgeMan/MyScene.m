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
static const uint32_t platformCategory =  0x1 << 2;

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Sets up data storage
        self.storeData = [NSUserDefaults standardUserDefaults];
        
        //Sets gravity
        self.physicsWorld.gravity = CGVectorMake(0,-4.0);
        self.physicsWorld.contactDelegate = self;
        
        //Set Background
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        
        //Set Ground
        ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        ground.position = CGPointMake(CGRectGetMidX(self.frame), 34);
        ground.xScale = 0.5;
        ground.yScale = 0.5;
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
        ground.physicsBody.dynamic = NO;
        ground.physicsBody.categoryBitMask = platformCategory;
        ground.physicsBody.contactTestBitMask = playerCategory;
        ground.physicsBody.collisionBitMask = 0;
        ground.physicsBody.usesPreciseCollisionDetection = YES;
        ground.physicsBody.friction = 0.0;
        ground.name = @"ground";

        //Player
        posX = 50;
        posY = 88.5;
        playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        playerSprite.position = CGPointMake(posX, posY);
        
        //Set Player Physics
        playerSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:playerSprite.size];
        playerSprite.physicsBody.dynamic = YES;
        playerSprite.physicsBody.categoryBitMask = playerCategory;
        playerSprite.physicsBody.contactTestBitMask = redBallCategory;
        playerSprite.physicsBody.collisionBitMask = platformCategory;
        playerSprite.physicsBody.usesPreciseCollisionDetection = YES;
        playerSprite.physicsBody.linearDamping = 0.3;
        playerSprite.physicsBody.allowsRotation = NO;
        
        //Score Label
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        scoreLabel.text = @"0";
        scoreLabel.fontSize = 40;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(50, 260);
        
        //Pause Button
        pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
        pauseButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40);
        pauseButton.name = @"pauseButton";
        
        //Pause Label
        NSString *pauseMessage;
        pauseMessage = @"Game Paused";
        pauseLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        pauseLabel.text = pauseMessage;
        pauseLabel.fontSize = 40;
        pauseLabel.fontColor = [SKColor blackColor];
        pauseLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //Reset Label
        NSString *resetMessage;
        resetMessage = @"Restart Game?";
        resetLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        resetLabel.text = resetMessage;
        resetLabel.fontSize = 40;
        resetLabel.fontColor = [SKColor blackColor];
        resetLabel.position = CGPointMake(self.size.width/2, self.size.height/4);
        resetLabel.name = @"resetLabel";
        
        //Platforms node
        platforms = [SKNode node];
        [self addChild:platforms];
        
        //Set score
        score = 0;
        
        //Sets jump counter
        jumpCounter = 0;
        
        //Add nodes
        [self addChild:ground];
        [self addChild:playerSprite];
        [self addChild:scoreLabel];
        [self addChild:pauseButton];
        
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
        score++;
        scoreString = [NSString stringWithFormat:@"%i", score];
        scoreLabel.text = scoreString;
        NSLog(@"Score was incremented. Score is now %d", score);
    }];
    [redBall runAction:[SKAction sequence:@[actionMove, ballCross, actionMoveDone]]];
}

//Adds platforms
-(void)addPlatform
{
    platform = [SKSpriteNode spriteNodeWithImageNamed:@"platform"];
    int minY = platform.size.height / 2;
    int maxY = self.frame.size.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    platform.xScale = 0.35;
    platform.yScale = 0.35;
    
    //Initiates red ball offscreen
    if (actualY >= 75)
    {
        //Prevents balls from spawning in the ground
        platform.position = CGPointMake(self.frame.size.width + platform.size.width/2, actualY);
        [platforms addChild:platform];
    }
    
    platform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:platform.size];
    platform.physicsBody.dynamic = NO;
    platform.physicsBody.categoryBitMask = platformCategory;
    platform.physicsBody.contactTestBitMask = playerCategory;
    platform.physicsBody.collisionBitMask = 0;
    platform.physicsBody.affectedByGravity = NO;
    platform.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Determine speed of red ball
    int minDuration = 3.0;
    int maxDuration = 5.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-platform.size.width/2, actualY) duration:actualDuration];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    SKAction *platformCross = [SKAction runBlock:^{
        NSLog(@"Platform passed by");
    }];
    [platform runAction:[SKAction sequence:@[actionMove, platformCross, actionMoveDone]]];
}

- (void)pauseScene
{
    self.paused = YES;
    [self addChild:pauseLabel];
    [self addChild:resetLabel];
}

- (void)resetScene
{
    //Unpauses scene
    self.paused = NO;
    
    //Reset player location and speed
    playerSprite.position = CGPointMake(posX, posY);
    playerSprite.physicsBody.velocity = CGVectorMake(0, 0);
    
    [platforms removeAllChildren];
    
    //Removes Labels
    [pauseLabel removeFromParent];
    [resetLabel removeFromParent];
    
    //Resets score
    score = 0;
    
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.85) {
        self.lastSpawnTimeInterval = 0;
        //[self addBall];
        [self addPlatform];
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
    
    //Set current dy velocity
    currentYMove = playerSprite.physicsBody.velocity.dy;
    currentXMove = playerSprite.physicsBody.velocity.dx;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouching = YES;
    /* Called when a touch begins */
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch Location X: %f \n Touch Location Y: %f", location.x, location.y);
        SKNode *node = [self nodeAtPoint:location];
        
        if (location.x < self.frame.size.width/2)
        {
            NSLog(@"Tapped left");
            playerSprite.physicsBody.velocity = CGVectorMake(-100.0, currentYMove);
        }
        else if (location.x > self.frame.size.width/2)
        {
             NSLog(@"Tapped right");
            playerSprite.physicsBody.velocity = CGVectorMake(100.0, currentYMove);
        }
        
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
                [pauseLabel removeFromParent];
                [resetLabel removeFromParent];
            }
        }
        
        if ([node.name isEqualToString:@"resetLabel"])
        {
            NSLog(@"Reset label pressed");
            [self resetScene];
        }
        
        else if ([node.name isEqualToString:@"ground"])
        {
            if (jumpCounter <= 1)
            {
                playerSprite.physicsBody.velocity = CGVectorMake(currentXMove, 300.0);
                NSLog(@"Tapped on ground - moving player up");
                jumpCounter++;
            }
        }
    }
    
    //Starts Timer
    startTime = [NSDate date];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouching = NO;
    /* Called when a touch ends */
    [super touchesEnded:touches withEvent:event];
    
    NSTimeInterval elapsedTime = [startTime timeIntervalSinceNow];
    NSString *elapsedTimeString = [NSString stringWithFormat:@"Elapsed time: %f", elapsedTime];
    NSLog(@"%@", elapsedTimeString);
    
    NSLog(@"Touch ended");
}

//Collision between ball and player - player dies
- (void)redBall:(SKSpriteNode *)redBall didCollideWithPlayer:(SKSpriteNode *)player
{
    
    NSLog(@"Player died");
    [redBall removeFromParent];
    [playerSprite removeFromParent];
    
    //Stores Final score
    [self.storeData setObject:scoreString forKey:@"scoreStringKey"];
    
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
    
    //Red ball collides with the player
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & platformCategory) != 0)
    {
        //Resets jump counter
        jumpCounter = 0;
        NSLog(@"Player and ball collided");
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contact ended");
}

@end
