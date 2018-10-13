//
//  ZRSWResetPhoneController.m
//  ZRSW
//
//  Created by King on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWResetPhoneController.h"
#import "ZRSWLoginCustomView.h"
#import "UserService.h"

#define CountDownSecond             60

@interface ZRSWResetPhoneController ()<LoginCustomViewDelegate>
@property (nonatomic, strong) UILabel *currentPhoneLabel;
@property (nonatomic, strong) ZRSWLoginCustomView *newPhoneView;
@property (nonatomic, strong) ZRSWLoginCustomView *currentCodeView;
@property (nonatomic, strong) ZRSWLoginCustomView *newCodeView;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UserService *userService;

@property (nonatomic, strong) NSString *currentPhoneNum;
@property (nonatomic, strong) NSString *currentCodeNum;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *codeNum;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL isChecked;

@end

@implementation ZRSWResetPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"更换手机号";
    [self setLeftBackBarButton];
    self.scrollView.scrollEnabled = YES;
    UserModel *userModel = [UserModel getCurrentModel];
    UserInfoModel *userInfoModel = userModel.data;
    self.currentPhoneNum = userInfoModel.phone;
     NSMutableString *phoneNum = [NSMutableString stringWithString:self.currentPhoneNum];
    if ([MatchManager checkTelNumber:phoneNum]){
        [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        phoneNum = [NSMutableString stringWithString:@"手机号错误，请联系客服"];
    }
    self.currentPhoneLabel.text = [NSString stringWithFormat:@"已绑定手机号码：%@",phoneNum.copy];
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.currentPhoneLabel];
    [self.scrollView addSubview:self.currentCodeView];
    [self.scrollView addSubview:self.newPhoneView];
    [self.scrollView addSubview:self.newCodeView];
    [self.scrollView addSubview:self.resetBtn];
    [self setupLayOut];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.currentPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(SCREEN_WIDTH - 14*2);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(43);
    }];
    [self.currentCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.currentPhoneLabel.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.newPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentCodeView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.currentCodeView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.newCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currentCodeView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.newPhoneView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.newCodeView.mas_bottom).offset(30);
    }];
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
    if (customView == self.newPhoneView) {
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 11) {
            return NO;//限制长度
        }
    }
    else if (customView == self.currentCodeView || customView == self.newCodeView ) {
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
    if (customView == self.currentCodeView) {
        self.currentCodeNum = text;
    }else if (customView == self.newPhoneView) {
        self.phoneNum = text;
    }
    else if (customView == self.newCodeView) {
        self.codeNum = text;
    }
    self.resetBtn.enabled = [self checkRegisterEnabled];
}

- (void)countDownButtonAction:(UIButton *)button customView:(ZRSWLoginCustomView *)customView{
    if (customView.tag == 101) {
        if ([MatchManager checkTelNumber:self.currentPhoneNum]) {
            [self.userService getUserPhoneCode:ImageCodeTypeResetPhone2 phone:self.currentPhoneNum delegate:self];
        }
    }else if (customView.tag == 102){
        if ([MatchManager checkTelNumber:self.phoneNum]) {
            [self.userService getUserPhoneCode:ImageCodeTypeResetPhone phone:self.phoneNum delegate:self];
        }else {
            [TipViewManager showToastMessage:@"请输入正确的手机号"];
        }
    }
}

#pragma mark - Action
- (void)resetAction{
    [TipViewManager showLoading];
    [self.userService userResetPhone:self.currentPhoneNum validateCode1:self.currentCodeNum newPhone:self.phoneNum validateCode2:self.codeNum delegate:self];
}

- (BOOL)checkRegisterEnabled {
    return  _phoneNum.length > 0 && _currentCodeNum.length == 4 && _codeNum.length == 4;
}


#pragma mark - network
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserResetPhoneRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [UserModel updateUserModel:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
        else if ([reqType isEqualToString:KGetOldPhoneCodeRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"短信验证码发送成功!"];
                [self.currentCodeView startCountDownWithSecond:CountDownSecond];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
        else if ([reqType isEqualToString:KGetNewPhoneCodeRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"短信验证码发送成功!"];
                [self.newPhoneView startCountDownWithSecond:CountDownSecond];
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
- (UILabel *)currentPhoneLabel {
    if (!_currentPhoneLabel) {
        _currentPhoneLabel = [[UILabel alloc] init];
        _currentPhoneLabel.textColor = [UIColor colorFromRGB:0x666666];
        _currentPhoneLabel.font = [UIFont systemFontOfSize:13];
        _currentPhoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _currentPhoneLabel;
}
- (ZRSWLoginCustomView *)currentCodeView {
    if (!_currentCodeView) {
        _currentCodeView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"验证码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeNumberPad isNeedCountDownButton:YES isNeedBottomLine:YES];
        _currentCodeView.tag = 101;
        _currentCodeView.delegate = self;
    }
    return _currentCodeView;
}

- (ZRSWLoginCustomView *)newPhoneView {
    if (!_newPhoneView) {
        _newPhoneView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"新手机号" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入新手机号" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeNumberPad isNeedCountDownButton:YES isNeedBottomLine:YES];
        _newPhoneView.tag = 102;
        _newPhoneView.delegate = self;
    }
    return _newPhoneView;
}

- (ZRSWLoginCustomView *)newCodeView {
    if (!_newCodeView) {
        _newCodeView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"验证码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeNumberPad isNeedCountDownButton:NO isNeedBottomLine:YES];
        _newCodeView.delegate = self;
    }
    return _newCodeView;
}


- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [ZRSWViewFactoryTool getBlueBtn:@"确认修改" target:self action:@selector(resetAction)];
        _resetBtn.enabled = NO;
    }
    return _resetBtn;
}
- (UserService *)userService {
    if (!_userService) {
        _userService = [[UserService alloc] init];
    }
    return _userService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
