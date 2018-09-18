//
//  ZRSWRetrievePasswordController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRetrievePasswordController.h"
#import "ZRSWLoginCustomView.h"

@interface ZRSWRetrievePasswordController ()
@property (nonatomic, strong) ZRSWLoginCustomView *oldPwdView;
@property (nonatomic, strong) ZRSWLoginCustomView *newPwdView;
@property (nonatomic, strong) UIButton *commitBtn;

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


#pragma mark - action
- (void)commitSureAction:(UIButton *)sureBtn {
    
}
#pragma mark - lazy
- (ZRSWLoginCustomView *)oldPwdView {
    if (!_oldPwdView) {
        _oldPwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"新密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
    }
    return _oldPwdView;
}
- (ZRSWLoginCustomView *)newPwdView {
    if (!_newPwdView) {
        _newPwdView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"确认密码" placeHoled:[[NSAttributedString alloc] initWithString:@"请再次输入新密码" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:NO];
    }
    return _newPwdView;
}
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [ZRSWViewFactoryTool getBlueBtn:@"确认提交" target:self action:@selector(commitSureAction:)];
    }
    return _commitBtn;
}
@end
