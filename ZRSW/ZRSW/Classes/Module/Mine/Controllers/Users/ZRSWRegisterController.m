//
//  ZRSWRegisterController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRegisterController.h"
#import "ZRSWLoginCustomView.h"
#import "UserService.h"

#define CountDownSecond             60

@interface ZRSWRegisterController ()<LoginCustomViewDelegate,UserAgreementViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *phoneView;
@property (nonatomic, strong) ZRSWLoginCustomView *codeView;
@property (nonatomic, strong) ZRSWLoginCustomView *pwdView;
@property (nonatomic, strong) ZRSWUserAgreementView *agreeView;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UserService *userService;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *codeNum;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL isChecked;

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
    self.scrollView.scrollEnabled = YES;
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

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.userNameView) {
        self.userName = text;
    }
    else if (customView == self.phoneView) {
        self.phoneNum = text;
        
    }
    else if (customView == self.codeView) {
        self.codeNum = text;
    }
    else if (customView == self.pwdView) {
        self.password = text;
    }
    self.registerBtn.enabled = [self checkRegisterEnabled];
    return YES;
}
- (void)userAgreementViewChecked:(BOOL)check {
    self.isChecked = check;
    self.registerBtn.enabled = [self checkRegisterEnabled];
}
- (void)countDownButtonAction:(UIButton *)button {
    if ([MatchManager checkTelNumber:self.phoneNum]) {
        [self.userService getUserPhoneCode:ImageCodeTypeRegister phone:self.phoneNum delegate:self];
    }
    else {
        [TipViewManager showToastMessage:@"请输入正确的手机号"];
    }
}
#pragma mark - Action
- (void)registerAction {
    
    [TipViewManager showLoading];
    [self.userService userRegisterLoginId:self.userName phone:self.phoneNum password:self.password validateCode:self.codeNum nickName:self.userName delegate:self];
}

- (BOOL)checkRegisterEnabled {
    return _userName.length > 0 && _phoneNum.length > 0 && _codeNum.length > 0 && _password.length > 0 && _isChecked;
}


#pragma mark - network
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserRegisterRequest]) {
            
        }
        else if ([reqType isEqualToString:KGetPhoneCodeRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"短信验证码发送成功!"];
                [self.phoneView startCountDownWithSecond:CountDownSecond];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }
    else {
        [TipViewManager showToastMessage:NetworkError];
    }
}
#pragma mark - lazy

- (ZRSWLoginCustomView *)userNameView {
    if (!_userNameView) {
        _userNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"用户名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _userNameView.delegate = self;
    }
    return _userNameView;
}
- (ZRSWLoginCustomView *)phoneView {
    if (!_phoneView) {
        _phoneView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"手机号" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypePhonePad isNeedCountDownButton:YES isNeedBottomLine:YES];
        _phoneView.delegate = self;
    }
    return _phoneView;
}
- (ZRSWLoginCustomView *)codeView {
    if (!_codeView) {
        _codeView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"验证码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _codeView.delegate = self;
    }
    return _codeView;
}
- (ZRSWLoginCustomView *)pwdView {
    if (!_pwdView) {
        NSString *title = @"请输入登录密码";
        NSString *tip = @"(字母+数字不少于6位)";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,tip]];
        [str addAttribute:NSForegroundColorAttributeName value:[ZRSWLoginCustomView placeHoledColor] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[ZRSWLoginCustomView placeHoledNormalFont] range:NSMakeRange(0, str.length)];
        [str addAttribute:NSFontAttributeName value:[ZRSWLoginCustomView placeHoledSmallFont] range:NSMakeRange(title.length, tip.length)];
        _pwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"密码" placeHoled:str keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _phoneView.delegate = self;
    }
    return _pwdView;
}
- (ZRSWUserAgreementView *)agreeView {
    if (!_agreeView) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《中融盛旺用户协议》"];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x999999] range:NSMakeRange(0, 7)];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x4771f2] range:NSMakeRange(7, 10)];
        _agreeView = [ZRSWUserAgreementView getUserAgreeViewWithTitle:att agreeHtmlName:@"LoginAgreement"];
        _agreeView.delegate = self;
    }
    return _agreeView;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [ZRSWViewFactoryTool getBlueBtn:@"注册" target:self action:@selector(registerAction)];
        _registerBtn.enabled = NO;
    }
    return _registerBtn;
}
- (UserService *)userService {
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
}
@end
