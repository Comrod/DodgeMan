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
        
        //Sets player location
        playerLocX = 50;
        playerLocY = 292;
        
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

NSDate *startTime;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    [super touchesBegan:touches withEvent:event];
    
    //Starts Timer
    startTime = [NSDate date];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch ends */
    [super touchesEnded:touches withEvent:event];
    
    NSTimeInterval elapsedTime = [startTime timeIntervalSinceNow];
    NSString *elapsedTimeString = [NSString stringWithFormat:@"Elapsed time: %f", elapsedTime];
    NSLog(@"%@", elapsedTimeString);
    
    for (UITouch *touch in touches)
    {
        //Gets location of touch
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch Location X: %f \n Touch Location Y: %f", location.x, location.y);
        
        //Moves and animates player
        int velocity = elapsedTime * -1500;
        NSLog(@"Velocity: %i", velocity);
        float realMoveDuration = self.size.width / velocity;
        SKAction *actionMove = [SKAction moveTo:location duration:realMoveDuration];
        [self.playerSprite runAction:[SKAction sequence:@[actionMove]]];
    }
    
    NSLog(@"Touch ended");
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
