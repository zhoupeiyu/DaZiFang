//
//  ZRSWRegisterController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRegisterController.h"
#import "ZRSWLoginCustomView.h"

@interface ZRSWRegisterController ()
@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *phoneView;
@property (nonatomic, strong) ZRSWLoginCustomView *codeView;
@property (nonatomic, strong) ZRSWLoginCustomView *pwdView;
@property (nonatomic, strong) ZRSWUserAgreementView *agreeView;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation ZRSWRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"注册";
    [self setLeftBackBarButton];
    [self setRightBarButtonWithText:@"登录"];
    [self.rightBarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.userNameView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.codeView];
    [self.scrollView addSubview:self.pwdView];
    [self.scrollView addSubview:self.agreeView];
    [self.scrollView addSubview:self.registerBtn];
    [self setupLayOut];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.userNameView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.phoneView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.codeView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.pwdView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([ZRSWUserAgreementView viewHeight]);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.agreeView.mas_bottom).offset(30);
    }];
}

#pragma mark - Action
- (void)registerAction {
    
}
#pragma mark - lazy

- (ZRSWLoginCustomView *)userNameView {
    if (!_userNameView) {
        _userNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"用户名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
    }
    return _userNameView;
}
- (ZRSWLoginCustomView *)phoneView {
    if (!_phoneView) {
        _phoneView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"手机号" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypePhonePad isNeedCountDownButton:YES isNeedBottomLine:YES];
        [_phoneView startCountDownWithSecond:60];
    }
    return _phoneView;
}
- (ZRSWLoginCustomView *)codeView {
    if (!_codeView) {
        _codeView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"验证码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
    }
    return _codeView;
}
- (ZRSWLoginCustomView *)pwdView {
    if (!_pwdView) {
        NSString *title = @"请输入登录密码";
        NSString *tip = @"(字母+数字不少于6位)";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,tip]];
        [str addAttribute:NSForegroundColorAttributeName value:[ZRSWLoginCustomView placeHoledColor] range:NSMakeRange(0, str.length)];
        _pwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"密码" placeHoled:str keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
    }
    return _pwdView;
}
- (ZRSWUserAgreementView *)agreeView {
    if (!_agreeView) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《中融盛旺用户协议》"];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x999999] range:NSMakeRange(0, 7)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x4771f2] range:NSMakeRange(7, 10)];
        _agreeView = [ZRSWUserAgreementView getUserAgreeViewWithTitle:att agreeHtmlName:@"LoginAgreement"];
    }
    return _agreeView;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [ZRSWViewFactoryTool getBlueBtn:@"注册" target:self action:@selector(registerAction)];
    }
    return _registerBtn;
}
@end
