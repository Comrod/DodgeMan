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
    BOOL isActionCompleted;
}


@property SKSpriteNode *playerSprite;
@property SKLabelNode *scoreLabel;
@property NSString *scoreString;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;


@end
