//
//  WinFunctionModel.h
//  MyFiveGame
//
//  Created by WilliamZhang on 15/4/13.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//  获胜方式

#import <UIKit/UIKit.h>

@interface WinFunctionModel : NSObject

@property (nonatomic         ) BOOL           canWin;           // 能否胜利
@property (nonatomic , strong) NSMutableArray *arrPoint;        // 存放5个棋子

/**
 *  获取棋子
 *
 *  @param index 五子位置
 */
- (CGPoint)getPointWithIndex:(NSInteger)index;

@end
