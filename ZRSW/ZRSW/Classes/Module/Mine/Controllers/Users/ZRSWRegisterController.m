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
    [self.view addSubview:self.userNameView];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.pwdView];
    
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
//        [str addAttribute:NSFontAttributeName value:[ZRSWLoginCustomView placeHoledNormalFont] range:NSMakeRange(0, str.length)];
//        [str addAttribute:NSFontAttributeName value:[ZRSWLoginCustomView placeHoledSmallFont] range:NSMakeRange(title.length - 1, tip.length)];
//        [str addAttribute:NSFontAttributeName value:[ZRSWLoginCustomView placeHoledSmallFont] range:NSMakeRange(0, tip.length)];
        _pwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"密码" placeHoled:str keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
    }
    return _pwdView;
}
- (ZRSWUserAgreementView *)agreeView {
    if (!_agreeView) {
        
//        _agreeView = [ZRSWUserAgreementView getUserAgreeViewWithTitle:<#(NSMutableAttributedString *)#> agreeHtmlName:<#(NSString *)#>];
    }
    return _agreeView;
}
@end
