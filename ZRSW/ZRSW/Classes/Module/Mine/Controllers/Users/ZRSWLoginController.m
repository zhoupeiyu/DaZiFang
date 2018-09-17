//
//  ZRSWLoginController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoginController.h"
#import "ZRSWRegisterController.h"
#import "ZRSWLoginCustomView.h"

@interface ZRSWLoginController ()

@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *pwdView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *faceLoginBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;


@end

@implementation ZRSWLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.userNameView];
    [self.scrollView addSubview:self.pwdView];
    [self.scrollView addSubview:self.loginBtn];
    
    [self setupLayOut];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    [self setRightBarButtonWithText:@"注册"];
    self.title = @"登录";
    [self.rightBarButton addTarget:self action:@selector(jumpRegister) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.userNameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.pwdView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.userNameView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdView.mas_bottom).offset(30);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 60);
        make.height.mas_equalTo(44);
    }];
}
#pragma mark - event

- (void)login {
    LLog(@"登录");
}
- (void)jumpRegister {
    ZRSWRegisterController *registerVC = [[ZRSWRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - lazy

- (ZRSWLoginCustomView *)userNameView {
    if (!_userNameView) {
        _userNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"手机号/用户名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入手机号或用户名" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:YES isNeedBottomLine:YES];
    }
    return _userNameView;
}

- (ZRSWLoginCustomView *)pwdView {
    if (!_pwdView) {
        _pwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeNumberPad isNeedCountDownButton:NO isNeedBottomLine:NO];
    }
    return _pwdView;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [ZRSWViewFactoryTool getBlueBtn:@"登录" target:self action:@selector(login)];
    }
    return _loginBtn;
}

@end
