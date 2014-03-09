//
//  EndGameScene.m
//  CoderDojo
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "EndGameScene.h"
#import "MyScene.h"

@implementation EndGameScene

-(id)initWithSize:(CGSize)size gameEnded:(BOOL)gameEnded
{
    if (self = [super initWithSize:size])
    {
        //Set Background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiP5"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.xScale = 0.5;
        background.yScale = 0.5;
        [self addChild:background];
        
        NSString *message;
        NSString *message2;
        if (gameEnded)
        {
            message = @"You Died";
            message2 = @"Play Again?";
        }
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        label2.text = message2;
        label2.fontSize = 40;
        label2.fontColor = [SKColor blackColor];
        label2.position = CGPointMake(self.size.width/2, self.size.height/3);
        [self addChild:label];
        [self addChild:label2];
        
        [self runAction:
         [SKAction sequence:@[
                              [SKAction waitForDuration:3.0],
                              [SKAction runBlock:^{
             SKTransition *dissolve = [SKTransition crossFadeWithDuration:0.5];
             SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
             [self.view presentScene:myScene transition: dissolve];
         }]
                              ]]
         ];
        
        MyScene *myScene = [MyScene new];
        myScene.wasJustPaused = NO;
    }
    return self;
}

@end
