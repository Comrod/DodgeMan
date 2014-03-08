//
//  MyScene.h
//  CoderDojo
//

//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
{
    BOOL isTouching;
    int playerLocX;
    int playerLocY;
}


@property SKSpriteNode *playerSprite;

@end
