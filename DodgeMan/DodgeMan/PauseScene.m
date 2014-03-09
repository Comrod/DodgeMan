//
//  PauseScene.m
//  DodgeMan
//
//  Created by Cormac Chester on 3/9/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "PauseScene.h"
#import "MyScene.h"

@implementation PauseScene

-(id)initWithSize:(CGSize)size
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
        message = @"Game Paused";
        
        //Label
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //Pause button
        SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pauseButton"];
        pauseButton.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 40);
        pauseButton.name = @"pauseButton";
        
        //Add nodes
        [self addChild:label];
        [self addChild:pauseButton];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //Pauses Scene
    if ([node.name isEqualToString:@"pauseButton"])
    {
        NSLog(@"Pause button pressed");
        MyScene *myScene2 = [MyScene new];
        myScene2.wasJustPaused = TRUE;
        
        //SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
        SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
        [self.view presentScene:myScene transition:nil];
        
        
    }
}


@end
