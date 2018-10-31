//
//  ZRSWBindPhoneController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/10/26.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWBindPhoneController.h"
#import "ZRSWLoginCustomView.h"
#import "UserService.h"
#import "ZRSWRegisterController.h"
#import "ZRSWLoginController.h"

#define CountDownSecond             60

@interface ZRSWBindPhoneController ()<LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *phoneView;
@property (nonatomic, strong) ZRSWLoginCustomView *codeView;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UserService *userService;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *codeNum;

@end

@implementation ZRSWBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setupConfig {
    self.title = @"绑定手机号";
    [self setLeftBackBarButton];
}

- (void)setupUI {
     [super setupUI];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.codeView];
    [self.scrollView addSubview:self.registerBtn];
    [self setupLayOut];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.phoneView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(30);
    }];
}
#pragma mark - delegate

- (void)countDownButtonAction:(UIButton *)button customView:(ZRSWLoginCustomView *)customView{
    if ([MatchManager checkTelNumber:self.phoneNum]) {
        [[[UserService alloc] init] getUserPhoneCode:ImageCodeTypeLogin phone:self.phoneNum delegate:self];
    }
    else {
        [TipViewManager showToastMessage:@"请输入正确的手机号"];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
    if (customView == self.phoneView) {
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
    }
    else if (customView == self.codeView) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 6) {
            return NO;//限制长度
        }
        return YES;
    }
    return YES;
}
- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.phoneView) {
        self.phoneNum = text;
        
    }
    else if (customView == self.codeView) {
        self.codeNum = text;
    }
    
    self.registerBtn.enabled = [self checkRegisterEnabled];
}

- (void)registerAction {
    [self.scrollView endEditing:YES];
    [TipViewManager showLoadingWithText:@"绑定中..."];
    [[[UserService alloc] init] userLoginWithPhoneNum:self.phoneNum code:self.codeNum qqOpenID:self.qqOpenID wechatOpenID:self.weiChatOpenID weiboUid:self.weiboUid delegate:self];
}
- (BOOL)checkRegisterEnabled {
    return _phoneNum.length > 0 && _codeNum.length > 0;
}
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetLoginCodeRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"短信验证码发送成功!"];
                [self.phoneView startCountDownWithSecond:CountDownSecond];
            }
            else if (model.error_code.integerValue == 1003) { //手机号未注册
                [TipViewManager showToastMessage:@"您要绑定的手机号还未注册，请先注册后再绑定第三方登录，谢谢！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ZRSWRegisterController *registerVC = [[ZRSWRegisterController alloc] init];
                    [self.navigationController pushViewController:registerVC animated:YES];
                });
                
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
        else if ([reqType isEqualToString:KCodeLoginRequest]) {
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
                for (BaseViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[ZRSWLoginController class]]) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [(ZRSWLoginController *)vc dismissViewControllerAnimated:NO completion:nil];
                    }
                }
            }
            else if (model.error_code.integerValue == 1003) { //手机号未注册
                [TipViewManager showToastMessage:@"您要绑定的手机号还未注册，请先注册后再绑定第三方登录，谢谢！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ZRSWRegisterController *registerVC = [[ZRSWRegisterController alloc] init];
                    [self.navigationController pushViewController:registerVC animated:YES];
                });
                
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }
}
- (ZRSWLoginCustomView *)phoneView {
    if (!_phoneView) {
        _phoneView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"手机号/用户名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypePhonePad isNeedCountDownButton:YES isNeedBottomLine:YES];
        _phoneView.delegate = self;
    }
    return _phoneView;
}
- (ZRSWLoginCustomView *)codeView {
    if (!_codeView) {
        _codeView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"验证码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:NO];
        _codeView.delegate = self;
    }
    return _codeView;
}
- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [ZRSWViewFactoryTool getBlueBtn:@"绑定" target:self action:@selector(registerAction)];
        _registerBtn.enabled = NO;
    }
    return _registerBtn;
}
@end
