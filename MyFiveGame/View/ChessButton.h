//
//  ChessButton.h
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/29.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//  棋子

#import <UIKit/UIKit.h>

typedef enum
{
    tag_white = -1,
    tag_empty = 0 ,
    tag_black = 1
}chessType_tag;

@interface ChessButton : UIButton

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) chessType_tag whatColor;

@property (nonatomic , strong)UIColor *layerColor;

@end
