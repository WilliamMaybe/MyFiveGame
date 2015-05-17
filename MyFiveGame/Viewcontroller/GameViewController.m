//
//  GameViewController.m
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/29.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "GameViewController.h"
#import "ChessBoardView.h"
#import "MyDefine.h"
#import <Masonry.h>

@interface GameViewController ()

@property (nonatomic ,strong) ChessBoardView *chessBoardView;
@property (nonatomic ,strong) UIButton *btnMenu;    // 主菜单
@property (nonatomic ,strong) UIButton *btnUndo;    // 悔棋
@property (nonatomic ,strong) UIButton *btnRestart; // 重新开始

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:COLOR_THEME];
    
    [self initComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initComponents
{
    [self.view addSubview:self.chessBoardView];
    [self.view addSubview:self.btnRestart];
    [self.view addSubview:self.btnMenu];
    [self.view addSubview:self.btnUndo];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.chessBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(self.view.mas_width).offset(-10);
    }];
    
    [self.btnUndo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
    }];
    
    [self.btnMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnUndo);
        make.width.height.equalTo(self.btnUndo);
        make.right.equalTo(self.btnUndo.mas_left).offset(-20);
    }];
    
    [self.btnRestart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnUndo);
        make.width.height.equalTo(self.btnUndo);
        make.left.equalTo(self.btnUndo.mas_right).offset(20);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - Private Method
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)undo
{
    [self.chessBoardView undo];
}

- (void)reStart
{
    [self.chessBoardView reStart];
}

#pragma mark - Init UI
- (ChessBoardView *)chessBoardView
{
    if (!_chessBoardView)
    {
        _chessBoardView = [[ChessBoardView alloc] init];
    }
    return _chessBoardView;
}

- (UIButton *)btnMenu
{
    if (!_btnMenu)
    {
        _btnMenu = [[UIButton alloc] init];
        [_btnMenu setTitle:@"主菜单" forState:UIControlStateNormal];
        [_btnMenu.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnMenu addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnMenu;
}

- (UIButton *)btnUndo
{
    if (!_btnUndo)
    {
        _btnUndo = [[UIButton alloc] init];
        [_btnUndo setTitle:@"悔棋" forState:UIControlStateNormal];
        [_btnUndo.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnUndo addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnUndo;
}

- (UIButton *)btnRestart
{
    if (!_btnRestart)
    {
        _btnRestart = [[UIButton alloc] init];
        [_btnRestart setTitle:@"重新开始" forState:UIControlStateNormal];
        [_btnRestart.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnRestart addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRestart;
}

- (void)setTag_mode:(GameMode_Tag)tag_mode
{
    _tag_mode =tag_mode;
    [self.chessBoardView setTag_mode:tag_mode];
}

@end
