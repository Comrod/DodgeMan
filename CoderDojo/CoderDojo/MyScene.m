//
//  MyScene.m
//  CoderDojo
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        playerLocX = 50;
        playerLocY = 292;
        isTouching = NO;
        
        //Background Color
        self.backgroundColor = [SKColor colorWithRed:0.53 green:0.81 blue:0.92 alpha:1.0];
        
        //Background
        /*SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundiP5"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        background.name = @"BACKGROUND";*/
        
        //Character
        self.playerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        self.playerSprite.position = CGPointMake(playerLocX, playerLocY);
        [self addChild:self.playerSprite];
        
        //Random label
        /*SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));*/
        
        //[self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    [super touchesBegan:touches withEvent:event];
    
    isTouching = YES;
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        self.playerSprite.position = location;
        
        /*if (location.x < self.playerSprite.position.x)
        {
            NSLog(@"Touched to left of character");
            self.playerSprite.position = CGPointMake(playerLocX - 2, playerLocY);
            NSLog(@"Player Location X: %i", playerLocX);
        }
        else if (location.x > self.playerSprite.position.x)
        {
            NSLog(@"Touched to  right of character");
            self.playerSprite.position = CGPointMake(playerLocX + 2, playerLocY);
            NSLog(@"Player Location X: %i", playerLocX);
        }*/
        
        NSLog(@"Touch Location X: %f \n Touch Location Y: %f", location.x, location.y);
        SKAction
        
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        //[self addChild:sprite];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    isTouching = NO;
    NSLog(@"Touch ended");
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
