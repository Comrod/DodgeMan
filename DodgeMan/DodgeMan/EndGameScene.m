//
//  EndGameScene.m
//  DodgeMan
//
//  Created by Cormac Chester on 3/8/14.
//  Copyright (c) 2014 Testman Industries. All rights reserved.
//

#import "EndGameScene.h"
#import "MyScene.h"

@implementation EndGameScene

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
        
        NSString *message = @"You Died";
        NSString *message2 = @"Play Again?";
        
        MyScene *myScene = [MyScene new];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        SKLabelNode *label2 = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial-BoldMT"];
        
        scoreLabel.fontSize = 30;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(self.frame.size.width/2, 260);
        finalScore = [myScene.storeData stringForKey:@"scoreStringKey"];
        if ([finalScore length] == 0)
        {
            //Checks if string is equal to null; if so, then sets the string to 0
            finalScore = @"0";
        }
        NSString *finalScoreString = [NSString stringWithFormat:@"Final Score: %@", finalScore];
        scoreLabel.text = finalScoreString;
        NSLog(@"%@", finalScoreString);
        
        label.text = message;
        label.fontSize = 50;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        label2.text = message2;
        label2.fontSize = 50;
        label2.fontColor = [SKColor blackColor];
        label2.position = CGPointMake(self.size.width/2, self.size.height/3);
        
        [self addChild:label];
        [self addChild:label2];
        [self addChild:scoreLabel];
        
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
        NSLog(@"Touch Location X: %f \n Touch Location Y: %f", location.x, location.y);

        SKTransition *dissolve = [SKTransition fadeWithDuration:0.5];
        SKScene *myScene = [[MyScene alloc] initWithSize:self.size];
        [self.view presentScene:myScene transition:dissolve];
    }
    
    NSLog(@"Touch ended");
}

@end
