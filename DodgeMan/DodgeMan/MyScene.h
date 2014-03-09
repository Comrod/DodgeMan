//
//  MyScene.h
//  CoderDojo
//

//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property SKSpriteNode *playerSprite;
@property SKLabelNode *scoreLabel;
@property SKSpriteNode *pauseButton;
@property NSString *scoreString;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property BOOL wasJustPaused;
@property int score;
@property NSUserDefaults *dataStorage;
@property int posX;
@property int posY;

@end
