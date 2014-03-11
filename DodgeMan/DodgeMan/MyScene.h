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
}

@property SKSpriteNode *playerSprite;
@property SKLabelNode *scoreLabel;
@property SKSpriteNode *pauseButton;
@property SKSpriteNode *ground;
@property SKNode *tapLeft;
@property SKNode *tapRight;
@property NSString *scoreString;
@property SKLabelNode *pauseLabel;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property int score;
@property float posX;
@property float posY;
@property NSUserDefaults *storeData;

@end
