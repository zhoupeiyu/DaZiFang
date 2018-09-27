//
//  ZRSWRetrievePasswordController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRetrievePasswordController.h"
#import "ZRSWLoginCustomView.h"
#import "UserService.h"

@interface ZRSWRetrievePasswordController ()<LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *oldPwdView;
@property (nonatomic, strong) ZRSWLoginCustomView *newPwdView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) NSString *nPwd;
@property (nonatomic, strong) NSString *oldPwd;
@property (nonatomic, strong) UserService *service;

@end

@implementation ZRSWRetrievePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.oldPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.newPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oldPwdView);
        make.top.mas_equalTo(self.oldPwdView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * 30);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.newPwdView.mas_bottom).offset(30);
    }];
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.oldPwdView];
    [self.scrollView addSubview:self.newPwdView];
    [self.scrollView addSubview:self.commitBtn];
    [self setupLayOut];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"找回密码";
}
- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.newPwdView) {
        self.nPwd = text;
    }
    else if (customView == self.oldPwdView) {
        self.oldPwd = text;
    }
    self.commitBtn.enabled = [self checkRegisterEnabled];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
    if (customView == self.oldPwdView) {
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
    else if (customView == self.newPwdView) {
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
#pragma mark - action
- (void)commitSureAction:(UIButton *)sureBtn {
    [self endEditing];
    if (![self.nPwd isEqualToString:self.oldPwd]) {
        [TipViewManager showToastMessage:@"两次密码必须一致！"];
        return;
    }
    [TipViewManager showLoading];
    [self.service userResetPassword:self.phoneNum password:self.oldPwd validateCode:self.codeNum delegate:self];
}
- (BOOL)checkRegisterEnabled {
    return _nPwd.length >= 6 && _oldPwd.length >= 6;
}
- (void)endEditing {
    [self.view endEditing:YES];
    [self.newPwdView endEditing];
    [self.oldPwdView endEditing];
}
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserResetPasswordRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [UserModel updateUserModel:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
        
    }
}
#pragma mark - lazy
- (ZRSWLoginCustomView *)oldPwdView {
    if (!_oldPwdView) {
        _oldPwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"新密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _oldPwdView.delegate = self;
        [_oldPwdView setSecurityInput:YES];

    }
    return _oldPwdView;
}
- (ZRSWLoginCustomView *)newPwdView {
    if (!_newPwdView) {
        _newPwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"确认密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请再次输入新密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:NO];
        _newPwdView.delegate = self;
        [_newPwdView setSecurityInput:YES];

    }
    return _newPwdView;
}
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [ZRSWViewFactoryTool getBlueBtn:@"确认提交" target:self action:@selector(commitSureAction:)];
        _commitBtn.enabled = NO;
    }
    return _commitBtn;
}
- (UserService *)service {
    if (!_service) {
        _service = [[UserService alloc] init];
    }
    return _service;
}
@end
