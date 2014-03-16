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
    
    //Platform counter
    int platformCounter;
    
    //Score
    int score;
    
    //Nodes
    SKNode *platforms;
    SKSpriteNode *playerSprite;
    SKSpriteNode *ground;
    SKLabelNode *scoreLabel;
    SKSpriteNode *pauseButton;
    SKSpriteNode *platform;
    SKLabelNode *pauseLabel;
    SKLabelNode *resetLabel;
    
    //Score
    NSString *scoreString;
    
}

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property NSUserDefaults *storeData;

@end
