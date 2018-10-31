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
#import "ZRSWThirdLoginView.h"
#import "ZRSWRetrievePasswordController.h"
#import "UserService.h"
#import "ZRSWBrushFaceLoginController.h"
#import "ZRSWForgetPwdViewController.h"
#import "ZRSWBindPhoneController.h"

@interface ZRSWLoginController ()<LoginCustomViewDelegate,ZRSWThirdLoginViewDelegate>

@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *pwdView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *faceLoginBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) NSMutableArray *thirdPartyIcon;
@property (nonatomic, strong) ZRSWThirdLoginView *loginView;


@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *wechatOpenID;
@property (nonatomic, strong) NSString *qqOpenID;
@property (nonatomic, strong) NSString *weiBoUid;

@end

@implementation ZRSWLoginController

- (void)goBack {
    [self.view endEditing:YES];
    if (self.cancelBlock) {
        self.cancelBlock();
        return;
    }
    [super goBack];
    [self dismissViewControllerAnimated:YES completion:nil];
}
+ (ZRSWLoginController *)getLoginViewController {
    ZRSWLoginController *vc = [[ZRSWLoginController alloc] init];
    
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated{
    NSString  *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginSuccessfulUserLoginIdKey];
    BOOL faceCertification = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",loginId,BrushFaceCertificationKey]];
    if (faceCertification) {
        self.faceLoginBtn.hidden = NO;
    }else{
        self.faceLoginBtn.hidden = YES;
    }
}


- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.userNameView];
    [self.scrollView addSubview:self.pwdView];
    [self.scrollView addSubview:self.loginBtn];
    [self.scrollView addSubview:self.faceLoginBtn];
    [self.scrollView addSubview:self.forgetPwdBtn];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.loginView];
    
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
    [self.faceLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_left);
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(5);
        make.height.mas_equalTo(44);
    }];
    [self.forgetPwdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.faceLoginBtn);
        make.right.mas_equalTo(self.loginBtn);
    }];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(94);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.loginView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([ZRSWThirdLoginView thirdLoginViewHeight]);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(35);
    }];
}

#pragma mark - delegate && dataSource

- (void)loginSuccessWithType:(ThirdLoginType)loginType userInfoResponse:(UMSocialUserInfoResponse *)response {
    [TipViewManager showLoadingWithText:@"登录中..."];
    if (loginType == ThirdLoginTypeWeChat) {
        NSString *openID = response.openid;
        self.wechatOpenID = openID;
        [[[UserService alloc] init] userLoginWithWeChatOpenID:openID delegate:self];
    }
    else if (loginType == ThirdLoginTypeQQ) {
        NSString *openID = response.openid;
        self.qqOpenID = openID;
        [[[UserService alloc] init] userLoginWithQQID:openID delegate:self];
    }
    else if (loginType == ThirdLoginTypeSina) {
        NSString *uid = response.uid;
        self.weiBoUid = uid;
        [[[UserService alloc] init] userLoginWithWeiBo:uid delegate:self];
    }
}

- (void)loginFailedWithType:(ThirdLoginType)loginType error:(NSError *)error {
    NSDictionary<NSErrorUserInfoKey, id> *dict = error.userInfo;
    NSString *err = dict[NSLocalizedFailureReasonErrorKey];
    [TipViewManager showToastMessage:err];
}
- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.userNameView) {
        self.userName = text;
    }
    else if (customView == self.pwdView) {
        self.password = text;
    }
    self.loginBtn.enabled = [self checkRegisterEnabled];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
   if (customView == self.pwdView) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        return YES;
    }
    return YES;
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserLoginRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                model.data.hasLogin = YES;
                if (model.data.phone) {
                    [[NSUserDefaults standardUserDefaults] setObject:model.data.phone forKey:LastLoginSuccessfulUserLoginIdKey];
                }
                if (model.data.faceLogin == 1) {
                     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",model.data.phone,BrushFaceCertificationKey]];
                }
                [UserModel updateUserModel:model];
                UserInfoModel *suer = model.data;
                //设置LoginToke
                [[BaseNetWorkService sharedInstance] setLoginToken:suer.token];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
        else if ([reqType isEqualToString:KWeXinLoginRequest] || [reqType isEqualToString:KQQLoginRequest] || [reqType isEqualToString:KWeiBoLoginRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                model.data.hasLogin = YES;
                if (model.data.phone) {
                    [[NSUserDefaults standardUserDefaults] setObject:model.data.phone forKey:LastLoginSuccessfulUserLoginIdKey];
                }
                if (model.data.faceLogin == 1) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",model.data.phone,BrushFaceCertificationKey]];
                }
                [UserModel updateUserModel:model];
                UserInfoModel *suer = model.data;
                //设置LoginToke
                [[BaseNetWorkService sharedInstance] setLoginToken:suer.token];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
                if (model.error_code.integerValue == 1008 || model.error_code.integerValue == 1009 || model.error_code.integerValue == 1010) { // 1008 微信未绑定
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ZRSWBindPhoneController *bindVC = [[ZRSWBindPhoneController alloc] init];
                        bindVC.qqOpenID = self.qqOpenID;
                        bindVC.weiboUid = self.weiBoUid;
                        bindVC.weiChatOpenID = self.wechatOpenID;
                        [self.navigationController pushViewController:bindVC animated:YES];
                    });
                }
            }
        }
    }
}
#pragma mark - event

+ (void)showLoginViewController {
    UIViewController *presentVC = [UIViewController currentViewController];
    [TipViewManager showAlertControllerWithTitle:@"" message:@"您尚未登录，请登录！" preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"确定" handler:^(PSTAlertAction *action) {
        ZRSWLoginController *loginVC = [[ZRSWLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        [presentVC presentViewController:nav animated:YES completion:nil];
    } controller:presentVC completion:^{
        
    }];
    
}
- (BOOL)checkRegisterEnabled {
    return _userName.length > 0 && _password.length >= 6;
}
- (void)forgetPwdBtnAction {
    [self endEditing];
    ZRSWForgetPwdViewController *retrievePassword = [[ZRSWForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:retrievePassword animated:YES];
}
- (void)faceLogin {
    [self endEditing];
    [TipViewManager showToastMessage:@"     敬请期待     "];
    return;
    ZRSWBrushFaceLoginController *brushFaceLoginVC = [[ZRSWBrushFaceLoginController alloc] init];
    [self.navigationController pushViewController:brushFaceLoginVC animated:YES];

}
- (void)login {
    [self endEditing];
    [TipViewManager showLoading];
    [[[UserService alloc] init] userLoginWithUserName:self.userName password:self.password delegate:self];
}
- (void)jumpRegister {
    [self endEditing];
    ZRSWRegisterController *registerVC = [[ZRSWRegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)endEditing {
    [self.view endEditing:YES];
    [self.userNameView endEditing];
    [self.pwdView endEditing];
}
#pragma mark - lazy

- (ZRSWLoginCustomView *)userNameView {
    if (!_userNameView) {
        _userNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"手机号/用户名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入手机号或用户名" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _userNameView.delegate = self;
    }
    return _userNameView;
}

- (ZRSWLoginCustomView *)pwdView {
    if (!_pwdView) {
        _pwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入登录密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:NO];
        _pwdView.delegate = self;
        [_pwdView setSecurityInput:YES];
    }
    return _pwdView;
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [ZRSWViewFactoryTool getBlueBtn:@"登录" target:self action:@selector(login)];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIButton *)faceLoginBtn {
    if (!_faceLoginBtn) {
        _faceLoginBtn = [self getGrayBtn:@"刷脸登录" action:@selector(faceLogin)];
    }
    return _faceLoginBtn;
}
- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        _forgetPwdBtn = [self getGrayBtn:@"忘记密码" action:@selector(forgetPwdBtnAction)];
    }
    return _forgetPwdBtn;
}
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 14)];
        _headView.backgroundColor = [UIColor redColor];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = @"第三方登录";
        lbl.textColor = [UIColor colorFromRGB:0x8f8f8f];
        lbl.font = [UIFont fontWithName:@"MicrosoftYaHei" size:13];
        [lbl sizeToFit];
        [_headView addSubview:lbl];
        [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_headView);
        }];
        {
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = [UIColor colorFromRGB:0xcccccc];
        [_headView addSubview:leftLine];
        [leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(32.5);
            make.centerY.mas_equalTo(lbl.mas_centerY);
            make.right.mas_equalTo(lbl.mas_left).offset(- 5);
            make.height.mas_equalTo(KSeparatorLineHeight);
        }];
        }
        {
            UIView *leftLine = [[UIView alloc] init];
            leftLine.backgroundColor = [UIColor colorFromRGB:0xcccccc];
            [_headView addSubview:leftLine];
            [leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(32.5);
                make.centerY.mas_equalTo(lbl.mas_centerY);
                make.left.mas_equalTo(lbl.mas_right).offset(5);
                make.height.mas_equalTo(KSeparatorLineHeight);
            }];
        }
    }
    return _headView;
}

- (NSMutableArray *)thirdPartyIcon {
    if (!_thirdPartyIcon) {
        _thirdPartyIcon = [[NSMutableArray alloc] init];
        [_thirdPartyIcon addObject:@"sign_other_blog"];
        [_thirdPartyIcon addObject:@"sign_other_wechat"];
        [_thirdPartyIcon addObject:@"share_friends"];
    }
    return _thirdPartyIcon;
}
- (ZRSWThirdLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[ZRSWThirdLoginView alloc] init];
        [_loginView updateAvailable];
        _loginView.delegate = self;
    }
    return _loginView;
}
- (UIButton *)getGrayBtn:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorFromRGB:0x666666] forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:YES];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
