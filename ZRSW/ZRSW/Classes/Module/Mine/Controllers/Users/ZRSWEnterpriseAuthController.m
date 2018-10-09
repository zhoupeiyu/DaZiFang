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
#import "UserService.h"

@interface ZRSWEnterpriseAuthController ()<LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *companyNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *departmentNameView;
@property (nonatomic, strong) ZRSWIPCardView *workCardView;
@property (nonatomic, strong) UploadImagesManager *imageManager;
@property (nonatomic, strong) UserService *service;

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
    if (self.companyName.length == 0) {
        [TipViewManager showToastMessage:@"请输入公司名称！"];
        return;
    }
    if (self.departmentName.length == 0) {
        [TipViewManager showToastMessage:@"请输入部门名称！"];
        return;
    }
    if ([self.workCardView getSelectedImages].count == 0) {
        [TipViewManager showToastMessage:@"请上传工牌照片！"];
        return;
    }
    WS(weakSelf);
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [self.imageManager uploadImagesWithImagesArray:[self.workCardView getSelectedImages] completeBlock:^(NSMutableArray * _Nullable imageUrls) {
            NSString *idCardImg3 = [imageUrls objectAtIndex:0];
            [weakSelf.service userValidationCompany:self.companyName deptName:self.departmentName workCardUrl:idCardImg3 delegate:self];
        }];
    }
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
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserValidationCompanyRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"提交成功!"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }
    else {
        [TipViewManager showNetErrorToast];
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
- (UploadImagesManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [UploadImagesManager sharedInstance];
        _imageManager.imageType = UploadImageTypeJpg;
        _imageManager.name = @"file";
        _imageManager.url = @"api/user/uploadFile";
    }
    return _imageManager;
}
- (UserService *)service {
    if (!_service) {
        _service = [[UserService alloc] init];
    }
    return _service;
}

@end
