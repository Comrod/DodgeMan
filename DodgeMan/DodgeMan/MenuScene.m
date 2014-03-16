//
//  MenuScene.m
//  DodgeMan
//
//  Created by Cormac Chester on 3/15/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "MenuScene.h"
#import "MyScene.h"

@implementation MenuScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Set Background
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        
        //Set Ground
        ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
        ground.position = CGPointMake(CGRectGetMidX(self.frame), 34);
        ground.xScale = 0.5;
        ground.yScale = 0.5;
        
        //Start Label
        startLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        startLabel.text = @"Start";
        startLabel.name = @"startLabel";
        startLabel.fontSize = 40;
        startLabel.fontColor = [SKColor blackColor];
        startLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self addChild:ground];
        [self addChild:startLabel];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches)
    {
        //Gets location of touch
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];

        if ([node.name isEqualToString:@"startLabel"])
        {
            SKTransition *dissolve = [SKTransition fadeWithDuration:0.5];
            SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
            [self.view presentScene:myScene transition:dissolve];
        }
    }
    
    NSLog(@"Touch ended");
}

@end
