//
//  ChessBoardView.m
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/29.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "ChessBoardView.h"
#import "ChessButton.h"
#import <Masonry.h>
//#import "WinFunctionModel.h"

#define WIDTH_CHESSBOARD 15

@interface ChessBoardView () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *arrChess;

// Data
@property (nonatomic) chessType_tag  nowIsWho;// 初始化白色
@property (nonatomic) NSMutableArray *arrStep;// 记录走过步数
@property (nonatomic) BOOL isWin;

@end

@implementation ChessBoardView

- (id)init
{
    if (self = [super init])
    {
        [self initComponents];
    }
    return self;
}

- (void)initComponents
{
    self.nowIsWho = tag_white;
    for (NSInteger i = 0; i< WIDTH_CHESSBOARD; i ++)
    {
        for (NSInteger j = 0; j < WIDTH_CHESSBOARD; j ++)
        {
            ChessButton *btnChess = [[ChessButton alloc] init];
            [btnChess setX:i];
            [btnChess setY:j];
            [btnChess setTag:(i * WIDTH_CHESSBOARD + j)];
            [btnChess setWhatColor:tag_empty];
            [btnChess addTarget:self action:@selector(setWhatColor:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnChess];
            [self.arrChess addObject:btnChess];
        }
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    ChessButton *tmpChess = [self.arrChess firstObject];
    [tmpChess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.mas_width).dividedBy(WIDTH_CHESSBOARD);
        make.left.top.equalTo(self);
    }];
    
    for (ChessButton *btnChess in self.arrChess)
    {
        if (btnChess != tmpChess)
        {
            [btnChess mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(tmpChess);
                if (btnChess.y == 0)
                {
                    make.left.equalTo(tmpChess);
                }
                else
                {
                    make.left.equalTo(tmpChess.mas_right).multipliedBy(btnChess.y);
                }
                if (btnChess.x == 0)
                {
                    make.top.equalTo(tmpChess);
                }
                else
                {
                    make.top.equalTo(tmpChess.mas_bottom).multipliedBy(btnChess.x);
                }
            }];
        }

    }
    
    [super updateConstraints];
}

#pragma mark - Interface method
- (void)reStart
{
    self.nowIsWho = tag_white;
    self.isWin = NO;
    [self setUserInteractionEnabled:YES];
    
    for (NSNumber *number in self.arrStep)
    {
        NSInteger step = [number integerValue];
        ChessButton *btn = self.arrChess[step];
        [btn setWhatColor:tag_empty];
        [btn setLayerColor:[UIColor grayColor]];
    }
}

- (void)undo
{
    // 人机悔棋
    if (self.tag_mode == tag_single)
    {
        if (self.arrStep.count)
        {
            NSNumber *indexPath = [self.arrStep lastObject];
            ChessButton *btn = self.arrChess[[indexPath integerValue]];
            if (btn.whatColor == tag_black)
            {
                [self undoNormal];
                [self undoNormal];
            }
        }
    }
    else
    {
        [self undoNormal];
    }
}

// 正常悔棋
- (void)undoNormal
{
    if (self.isWin)
    {
        return;
    }
    
    if (self.arrStep.count)
    {
        NSInteger number = [[self.arrStep lastObject] integerValue];
        [self setEmptyColorWithIndex:number];
        
        self.nowIsWho = (self.nowIsWho == tag_white ? tag_black : tag_white);
        [self.arrStep removeLastObject];
        
        // 如果还有步数，则标记最后一个为当前下子
        if (self.arrStep.count)
        {
            NSInteger numberNow = [[self.arrStep lastObject] integerValue];
            ChessButton *btnNow = self.arrChess[numberNow];
            [btnNow setLayerColor:[UIColor orangeColor]];
        }
    }
}

#pragma mark - Private method
/**
 *  下子
 *
 *  @param btn 下子位置按钮
 */
- (void)setWhatColor:(ChessButton *)btn
{
    [btn setWhatColor:self.nowIsWho];
    [btn setLayerColor:[UIColor redColor]];
    
    self.nowIsWho = (self.nowIsWho == tag_white ? tag_black : tag_white);
    
    if (self.arrStep.count)
    {
        NSInteger numberNow = [[self.arrStep lastObject] integerValue];
        [self setBorderColor:[UIColor grayColor] index:numberNow];
    }

    [self.arrStep addObject:@(btn.tag)];
    
    [self isWinWithChess:btn];
    
    if (self.tag_mode == tag_single && !self.isWin)
    {
        // 计算机走
        NSInteger bestIndex = [self computerReturnBestIndexPath];
        ChessButton *btnPC = self.arrChess[bestIndex];
        [btnPC setWhatColor:self.nowIsWho];
        [btnPC setLayerColor:[UIColor redColor]];
        
        self.nowIsWho = (self.nowIsWho == tag_white ? tag_black : tag_white);
        
        NSInteger numberNow = [[self.arrStep lastObject] integerValue];
        [self setBorderColor:[UIColor grayColor] index:numberNow];
        
        [self.arrStep addObject:@(btnPC.tag)];
        
        // 是否胜利
        [self isWinWithChess:btnPC];
    }
}

/**
 *  设置为空子
 *
 *  @param index 位置
 */
- (void)setEmptyColorWithIndex:(NSInteger)index
{
    ChessButton *btn = self.arrChess[index];
    [btn setWhatColor:tag_empty];

    [btn setLayerColor:[UIColor grayColor]];

}

/**
 *  设置棋子边框色
 *
 *  @param color 颜色
 *  @param index 棋子所在数组位置
 */
- (void)setBorderColor:(UIColor *)color index:(NSInteger)index
{
    ChessButton *btn = self.arrChess[index];
    [btn.layer setBorderColor:[color CGColor]];
}

/**
 *  是否赢得比赛
 *
 *  @param button 当前下子
 *
 *  @return 是否赢得比赛
 */
- (void)isWinWithChess:(ChessButton *)button
{
    BOOL isWin = NO;

    NSArray *arrDirection = @[[NSValue valueWithCGPoint:CGPointMake(1, 1)],
                              [NSValue valueWithCGPoint:CGPointMake(0, 1)],
                              [NSValue valueWithCGPoint:CGPointMake(-1, 1)],
                              [NSValue valueWithCGPoint:CGPointMake(1, 0)]];
    
    for (NSValue *value in arrDirection)
    {
        CGPoint pointDirection = [value CGPointValue];
        // 当前相同子数为1
        NSInteger sameChess = 1;
        sameChess += [self sameChessWithChess:button direction:pointDirection];
        
        CGPoint pointDirection2 = CGPointMake(-pointDirection.x, -pointDirection.y);
        sameChess += [self sameChessWithChess:button direction:pointDirection2];
        
        if (sameChess >= 5)
        {
            isWin = YES;
            break;
        }
    }
    // 是否胜利
    if (isWin == YES)
    {
        NSString *strWin = [NSString stringWithFormat:@"%@赢了!!!",(button.whatColor == tag_white ? @"白色" : @"黑色")];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:strWin message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        [self setUserInteractionEnabled:NO];
        self.isWin = YES;
    }
}

/**
 *  在此方向相同棋子数
 *
 *  @param index 棋子位置
 *  @param point 棋子方向
 *
 *  @return 棋子相同个数
 */
- (NSInteger)sameChessWithChess:(ChessButton *)chessButton direction:(CGPoint)point
{
    NSInteger sameChess = 0;
    for (NSInteger i = 1 ; i < 5 ; i ++)
    {
        NSInteger x = chessButton.x - i * point.x;
        NSInteger y = chessButton.y - i * point.y;
        if (x < 0 || (x > WIDTH_CHESSBOARD - 1) ||
            y < 0 || (y > WIDTH_CHESSBOARD - 1))
        {
            break;
        }
        
        ChessButton *btnTmp = self.arrChess[x * WIDTH_CHESSBOARD + y];
        if (chessButton.whatColor == btnTmp.whatColor)
        {
            sameChess ++ ;
        }
        else
        {
            break;
        }
    }
    
    return sameChess;
}

/** 
 *
 *  @return 返回最佳
 */
- (NSInteger)computerReturnBestIndexPath
{
    // pc 子颜色
    //chessType_tag tag_pc = self.nowIsWho;
    
    // 算分数
    NSInteger bestIndexPC       = 0;
    NSInteger bestScorePC       = -10000;

    NSInteger bestIndexMan      = 0;
    NSInteger bestScoreMan      = -10000;
    
    for (ChessButton *btnChess in self.arrChess)
    {
        if (btnChess.whatColor == tag_empty)
        {
            // 计算计算机分值
            NSInteger scorePCTmp = [self calScoreAtIndex:btnChess.tag withType:tag_black];
            if (scorePCTmp > bestScorePC)
            {
                bestScorePC = scorePCTmp;
                bestIndexPC = btnChess.tag;
            }
            
            // 计算人分值
            NSInteger scoreManTmp = [self calScoreAtIndex:btnChess.tag withType:tag_white];
            if (DEBUG)
            {
                NSLog(@"%ld:pc%ld     man:%ld",btnChess.tag,scorePCTmp,scoreManTmp);
            }
            
            if (scoreManTmp > bestScoreMan)
            {
                bestScoreMan = scoreManTmp;
                bestIndexMan = btnChess.tag;
            }
        }
    }
    
    return (bestScorePC >= bestScoreMan ? bestIndexPC : bestIndexMan);
}

/**
 *  计算分数
 *
 *  @param index 空子所在位置
 *  @param tag   棋色
 *
 *  @return 返回分数
 */
- (NSInteger)calScoreAtIndex:(NSInteger)index withType:(chessType_tag)tag
{
    // 落子位置
    NSInteger x = index / WIDTH_CHESSBOARD;
    NSInteger y = index % WIDTH_CHESSBOARD;
    
    NSInteger score = 0;
    NSInteger numSame = 0;      // 相同子个数
    NSInteger numSeperator = 0; // 边缘截断
    ///// "丨"
    //top
    for (NSInteger i = 1; i<= x; i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x - i) * WIDTH_CHESSBOARD + y];
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            // 边缘检测
            if (x - i == 0)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        
        // 不同色
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    // bottom
    for (NSInteger i = 1; i <= WIDTH_CHESSBOARD - 1 - x; i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x + i) * WIDTH_CHESSBOARD + y];
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
        
            if (x + i == WIDTH_CHESSBOARD - 1)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    // 自己就是边缘
    if (x == 0 || x == WIDTH_CHESSBOARD - 1)
    {
        numSeperator ++;
    }
    score += [self GetScoreChessOfNumber:numSame withSeperatorOfNumber:numSeperator];

    ////// "\"
    // 斜上
    numSeperator = 0;
    numSame      = 0;
    for (NSInteger i = 1; i <= x && i <= y; i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x - i) *WIDTH_CHESSBOARD + (y - i)];

        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            if ((x - i) == 0 || (y - i) == 0)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    // 斜下
    for (NSInteger i = 1; i <= (WIDTH_CHESSBOARD - 1 -x) && i <= (WIDTH_CHESSBOARD - 1 - y); i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x + i) * WIDTH_CHESSBOARD + (y + i)];
        
        if (btnTmp.whatColor == tag)
        {
            numSame ++ ;
            if ((x + i) == (WIDTH_CHESSBOARD - 1) || (y + i) == (WIDTH_CHESSBOARD - 1))
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    if (x == 0 || y == 0 || x == (WIDTH_CHESSBOARD - 1) || y == (WIDTH_CHESSBOARD - 1))
    {
        numSeperator ++;
    }
    score += [self GetScoreChessOfNumber:numSame withSeperatorOfNumber:numSeperator];
    
    ////// "一"
    // left
    numSame      = 0;
    numSeperator = 0;
    for (NSInteger i = 1 ; i <= y; i ++)
    {
        ChessButton *btnTmp = self.arrChess[x * WIDTH_CHESSBOARD + (y - i)];
        
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            if (y - i == 0)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    // right
    for (NSInteger i = 1 ; i <= WIDTH_CHESSBOARD - 1 - y; i ++)
    {
        ChessButton *btnTmp = self.arrChess[x * WIDTH_CHESSBOARD + y + i];
        
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            if (y + i == WIDTH_CHESSBOARD - 1)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    if (y == 0 || y == WIDTH_CHESSBOARD - 1)
    {
        numSeperator ++;
    }
    score += [self GetScoreChessOfNumber:numSame withSeperatorOfNumber:numSeperator];
    
    ////// "/"
    numSame      = 0;
    numSeperator = 0;
    // 斜下
    for (NSInteger i = 1; (i <= WIDTH_CHESSBOARD - 1 - x) && (i <= y); i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x + i) * WIDTH_CHESSBOARD + y - i];
        
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            if ((x + i == WIDTH_CHESSBOARD - 1) || (y - i) == 0)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    // 斜上
    for (NSInteger i = 1; (i <= x) && (i <= WIDTH_CHESSBOARD - 1 - y); i ++)
    {
        ChessButton *btnTmp = self.arrChess[(x - i) * WIDTH_CHESSBOARD + (y + i)];
        
        if (btnTmp.whatColor == tag)
        {
            numSame ++;
            if ((x - i) == 0 || (y + i) == WIDTH_CHESSBOARD - 1)
            {
                numSeperator ++;
            }
        }
        else if (btnTmp.whatColor == tag_empty)
        {
            break;
        }
        else
        {
            numSeperator ++;
            break;
        }
    }
    
    if (x == 0 || x == WIDTH_CHESSBOARD - 1 || y == 0 || y == WIDTH_CHESSBOARD - 1)
    {
        numSeperator ++;
    }
    score += [self GetScoreChessOfNumber:numSame withSeperatorOfNumber:numSeperator];
    
    return score;
}

/**
 *  根据棋子数计算分值
 *
 *  @param number          连子数量
 *  @param seperatorNumber 被分割情况
 *
 *  @return 返回分数
 */
- (NSInteger)GetScoreChessOfNumber:(NSInteger)number withSeperatorOfNumber:(NSInteger)seperatorNumber
{
    NSInteger score = 0;
    
    // 五子
    if (number >= 4)
    {
        score = 10000;
    }
    
    // 四子
    else if (number == 3)
    {
        switch (seperatorNumber)
        {
            case 0:
                // 活四
                score = 3000;
                break;
            case 1:
                // 冲四
                score = 900;
                break;
            case 2:
                // 死四 不做操作
            default:
                break;
        }
    }
    
    // 三子
    else if (number == 2)
    {
        switch (seperatorNumber)
        {
            case 0:
                // 活三
                score = 460;
                break;
            case 1:
                // 冲三
                score = 30;
                break;
            default:
                break;
        }
    }
    
    // 二子
    else if (number == 1)
    {
        switch (seperatorNumber)
        {
            case 0:
                // 活二
                score = 45;
                break;
            case 1:
                // 冲二
                score = 5;
            default:
                break;
        }
    }
    
    // 单子
    else
    {
        switch (seperatorNumber) {
            case 0:
                score = 3;
                break;
            case 1:
                score = 1;
                break;
            default:
                break;
        }
    }
    
    return score;
}
#pragma mark - Init
- (NSMutableArray *)arrChess
{
    if (!_arrChess)
    {
        _arrChess = [NSMutableArray array];
    }
    return _arrChess;
}

- (NSMutableArray *)arrStep
{
    if (!_arrStep)
    {
        _arrStep = [NSMutableArray array];
    }
    return _arrStep;
}

- (void)setTag_mode:(GameMode_Tag)tag_mode
{
    _tag_mode = tag_mode;
    // 单人模式，初始化致胜表
    if (tag_mode == tag_single)
    {
        
    }
}
@end
