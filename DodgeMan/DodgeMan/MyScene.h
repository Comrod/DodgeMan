//
//  MyScene.h
//  DodgeMan
//

//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
    NSDate *startTime;
    BOOL isTouching;
    
    //Player coords
    CGFloat currentYMove;
    CGFloat currentXMove;
    
    //Starting Player coords
    float posX;
    float posY;
    
    //Player jump counter
    int jumpCounter;
    
    //Score
    int score;
    
    //Nodes
    SKNode *platforms;
    SKSpriteNode *playerSprite;
    SKLabelNode *scoreLabel;
    SKSpriteNode *pauseButton;
    SKSpriteNode *ground;
    SKSpriteNode *platform;
    SKSpriteNode *starterPlatform;
    SKLabelNode *pauseLabel;
    SKLabelNode *resetLabel;
    
    //Score
    NSString *scoreString;
    
}

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property NSUserDefaults *storeData;

@end
