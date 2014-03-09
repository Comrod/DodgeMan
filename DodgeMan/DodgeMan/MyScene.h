//
//  MyScene.h
//  CoderDojo
//

//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    int playerLocX;
    int playerLocY;
    int score;
    BOOL isActionCompleted;
    
    BOOL didTapLeft;
    
    BOOL didRunFalling;
    BOOL isMoving;
    
    //Gravity
    CGPoint fallDirection;
    CGPoint fallAmount;
    CGPoint fallDestination;
    CGPoint fallDestinationReal;
    CGPoint locationTouched;
    CGPoint initialPos;
    BOOL isGravityOccurring;
    BOOL isPlayerInGround;
    
    NSTimeInterval elapsedTime;
    NSString *elapsedTimeString;
}


@property SKSpriteNode *playerSprite;
@property SKLabelNode *scoreLabel;
@property SKSpriteNode *pauseButton;
@property NSString *scoreString;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@end
