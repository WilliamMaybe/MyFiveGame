//
//  ViewController.m
//  MyFiveGame
//
//  Created by WilliamZhang on 15/3/14.
//  Copyright (c) 2015年 WilliamZhang. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "MyDefine.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic ,strong) UILabel *lbTitle;

@property (nonatomic ,strong) UIButton *btnDouble;
@property (nonatomic ,strong) UIButton *btnSingle;
@property (nonatomic ,strong) UIButton *btnOnline;

@end

@implementation ViewController

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
    [self.view addSubview:self.lbTitle];
    [self.view addSubview:self.btnSingle];
    [self.view addSubview:self.btnDouble];
//    [self.view addSubview:self.btnOnline];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    [self.lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
    }];
    
    [self.btnDouble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
    }];
    
    [self.btnSingle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(50);
    }];
    
/*
    [self.btnDouble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.btnSingle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnDouble.mas_top).offset(-20);
        make.left.equalTo(self.btnDouble);
    }];
    
    [self.btnOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnDouble.mas_bottom).offset(20);
        make.left.equalTo(self.btnDouble);
    }];
  */
    [super updateViewConstraints];
}

#pragma mark - Private Method
- (void)beginGame:(id)sender
{
    UIButton *btnClicked = (UIButton *)sender;
    
    GameViewController *GVC = [[GameViewController alloc] init];
    [GVC setTag_mode:(GameMode_Tag)btnClicked.tag];
    [GVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:GVC animated:YES completion:nil];
}

#pragma mark - UI
- (UILabel *)lbTitle
{
    if (!_lbTitle)
    {
        _lbTitle = [[UILabel alloc] init];
        [_lbTitle setText:@"五子棋"];
        [_lbTitle setFont:[UIFont systemFontOfSize:30]];
    }
    return _lbTitle;
}


- (UIButton *)btnDouble
{
    if (!_btnDouble)
    {
        _btnDouble = [[UIButton alloc] init];
        [_btnDouble setTitle:@"双人游戏" forState:UIControlStateNormal];
        [_btnDouble.titleLabel  setFont:[UIFont systemFontOfSize:25]];
        [_btnDouble addTarget:self action:@selector(beginGame:) forControlEvents:UIControlEventTouchUpInside];
        [_btnDouble setTag:tag_double];
    }
    return _btnDouble;
}

- (UIButton *)btnSingle
{
    if (!_btnSingle) {
        _btnSingle = [[UIButton alloc] init];
        [_btnSingle setTitle:@"单人游戏" forState:UIControlStateNormal];
        [_btnSingle.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnSingle addTarget:self action:@selector(beginGame:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSingle setTag:tag_single];
    }
    return _btnSingle;
}

- (UIButton *)btnOnline
{
    if (!_btnOnline)
    {
        _btnOnline = [[UIButton alloc] init];
        [_btnOnline setTitle:@"局域网" forState:UIControlStateNormal];
        [_btnOnline.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_btnOnline addTarget:self action:@selector(beginGame:) forControlEvents:UIControlEventTouchUpInside];
        [_btnOnline setTag:tag_online];
    }
    return _btnOnline;
}

@end