//
//  WinFunctionModel.m
//  MyFiveGame
//
//  Created by WilliamZhang on 15/4/13.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "WinFunctionModel.h"

@implementation WinFunctionModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.canWin = YES;
        self.arrPoint = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Interface Method
- (CGPoint)getPointWithIndex:(NSInteger)index
{
    if (index >4)
    {
        return CGPointZero;
    }
    NSValue *valuePoint = self.arrPoint[index];
    return [valuePoint CGPointValue];
}

@end
