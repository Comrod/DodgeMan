//
//  MenuScene.h
//  DodgeMan
//
//  Created by Cormac Chester on 3/15/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MenuScene : SKScene
{
    SKSpriteNode *ground;
    SKLabelNode *startLabel;
}

-(id)initWithSize:(CGSize)size;

@end
