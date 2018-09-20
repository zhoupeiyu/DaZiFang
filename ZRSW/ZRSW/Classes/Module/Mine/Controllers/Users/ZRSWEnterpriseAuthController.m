//
//  ZRSWEnterpriseAuthController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWEnterpriseAuthController.h"
#import "ZRSWLoginCustomView.h"
#import "ZRSWIPCardView.h"

@interface ZRSWEnterpriseAuthController ()<LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *companyNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *departmentNameView;
@property (nonatomic, strong) ZRSWIPCardView *workCardView;

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *departmentName;
@end


@implementation ZRSWEnterpriseAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.companyNameView];
    [self.scrollView addSubview:self.departmentNameView];
    [self.scrollView addSubview:self.workCardView];
    
    [self setupLayOut];
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"企业认证";
    [self setLeftBackBarButton];
    [self setRightBarButtonWithText:@"提交"];
    [self.rightBarButton addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBarButton setAdjustsImageWhenHighlighted:YES];
    [self.rightBarButton setAdjustsImageWhenDisabled:YES];
}
- (void)setupLayOut {
    [super setupLayOut];
    [self.companyNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.departmentNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.companyNameView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.workCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.departmentNameView.mas_bottom);
        make.height.mas_equalTo([ZRSWIPCardView viewHeight:IPCardViewTypeCompany]);
    }];
}
#pragma mark - action

- (void)commitBtnAction {
    
}

- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.companyNameView) {
        self.companyName = text;
    }
    else if (customView == self.departmentNameView) {
        self.departmentName = text;
    }
}

#pragma mark - lazy
- (ZRSWLoginCustomView *)companyNameView {
    if (!_companyNameView) {
        _companyNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"公司名称" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入公司全称" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _companyNameView.delegate = self;
    }
    return _companyNameView;
}
- (ZRSWLoginCustomView *)departmentNameView {
    if (!_departmentNameView) {
        _departmentNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"部门" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入所在部门" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _departmentNameView.delegate = self;
    }
    return _departmentNameView;
}
- (ZRSWIPCardView *)workCardView {
    if (!_workCardView) {
        _workCardView = [ZRSWIPCardView getIPCardViewWithType:IPCardViewTypeCompany title:@"上传工牌照片" fristViewContent:@"" secondContent:@"" isNeedBottomLine:NO presentVC:self];
    }
    return _workCardView;
}



@end
