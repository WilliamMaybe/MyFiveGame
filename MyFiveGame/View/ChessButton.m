//
//  ChessButton.m
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/29.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "ChessButton.h"

#define AnimationDuration   1.0

@implementation ChessButton

- (id)init
{
    if (self = [super init])
    {
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[[UIColor grayColor] CGColor]];
    }
    return self;
}


- (void)setWhatColor:(chessType_tag)whatColor
{
    _whatColor = whatColor;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AnimationDuration];
    
    switch (whatColor)
    {
        case tag_white:
            [self setBackgroundColor:[UIColor whiteColor]];
            [self setEnabled:NO];
            break;
        case tag_black:
            [self setBackgroundColor:[UIColor blackColor]];
            [self setEnabled:NO];
            break;
        default:
            [self setBackgroundColor:[UIColor clearColor]];
            [self setEnabled:YES];
            break;
    }
    
    [UIView commitAnimations];
}

- (void)setLayerColor:(UIColor *)layerColor
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:AnimationDuration];
    
    [self.layer setBorderColor:[layerColor CGColor]];
    
    [UIView commitAnimations];
}

@end
