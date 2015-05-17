//
//  ChessBoardView.h
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/29.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//  棋盘界面

#import <UIKit/UIKit.h>
#import "MyDefine.h"

@interface ChessBoardView : UIView

- (void)reStart;

- (void)undo;

@property (nonatomic) GameMode_Tag tag_mode;    // 比赛模式

@end
