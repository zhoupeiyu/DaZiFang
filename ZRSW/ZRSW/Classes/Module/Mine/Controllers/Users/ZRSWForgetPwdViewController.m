//
//  ZRSWForgetPwdViewController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWForgetPwdViewController.h"
#import "ZRSWLoginCustomView.h"
#import "UserService.h"
#import "ZRSWRetrievePasswordController.h"

#define CountDownSecond             60

@interface ZRSWForgetPwdViewController ()<LoginCustomViewDelegate>

@property (nonatomic, strong) ZRSWLoginCustomView *phoneView;
@property (nonatomic, strong) ZRSWLoginCustomView *codeView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UserService *userService;

@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *codeNum;

@end

@implementation ZRSWForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"找回密码";
    [self setLeftBackBarButton];
    self.scrollView.scrollEnabled = YES;
}
- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.codeView];
    [self.scrollView addSubview:self.nextBtn];
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
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.codeView.mas_bottom).offset(30);
    }];
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
    self.nextBtn.enabled = [self checkRegisterEnabled];
}
- (void)countDownButtonAction:(UIButton *)button customView:(ZRSWLoginCustomView *)customView{
    if ([MatchManager checkTelNumber:self.phoneNum]) {
        [TipViewManager showLoading];
        [self.userService getUserPhoneCode:ImageCodeTypePwd phone:self.phoneNum delegate:self];
    }
    else {
        [TipViewManager showToastMessage:@"请输入正确的手机号"];
    }
}
- (BOOL)checkRegisterEnabled {
    return _phoneNum.length > 0 && _codeNum.length > 0;
}

- (void)nextAction {
    ZRSWRetrievePasswordController *retrievePasswordController = [[ZRSWRetrievePasswordController alloc] init];
    retrievePasswordController.codeNum = self.codeNum;
    retrievePasswordController.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:retrievePasswordController animated:YES];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
    if ([reqType isEqualToString:KGetPhoneCodeRequest]) {
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
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [ZRSWViewFactoryTool getBlueBtn:@"注册" target:self action:@selector(nextAction)];
        _nextBtn.enabled = NO;
    }
    return _nextBtn;
}
- (UserService *)userService {
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
}

@end
