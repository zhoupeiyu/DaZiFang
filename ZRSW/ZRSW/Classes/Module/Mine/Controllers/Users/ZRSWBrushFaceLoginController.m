//
//  ZRSWBrushFaceLoginController.m
//  ZRSW
//
//  Created by King on 2018/9/24.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBrushFaceLoginController.h"
#import "FaceStreamDetectorViewController.h"
#import "UserService.h"

@interface ZRSWBrushFaceLoginController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,FaceDetectorDelegate>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *headeImageView;
@property (nonatomic, strong) UIButton *faceLoginBtn;
@property (nonatomic, strong) UIButton *toggleLoginModeBtn;
@property (nonatomic, strong) UserService *service;
@property (nonatomic, strong) UploadImagesManager *imageManager;
@property (nonatomic, strong) NSString *loginId;
@property (nonatomic, assign) NSInteger sendFaceCount;



@end

@implementation ZRSWBrushFaceLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TipViewManager showLoading];
    [self.scrollView reloadEmptyDataSet];
    [self setViewHidden:YES];
    self.sendFaceCount = 0;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserIocnImageKey];
    self.iconImageView.image = [UIImage imageWithData:data];
    if (!self.iconImageView.image) {
        self.iconImageView.image = [UIImage imageNamed:@"my_head"];
    }
    self.loginId = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoginSuccessfulUserLoginIdKey];
    NSMutableString *phoneNum = [NSMutableString stringWithString:self.loginId];
    if ([MatchManager checkTelNumber:phoneNum]){
        [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.phoneLabel.text = phoneNum.copy;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.scrollView.emptyDataSetSource = nil;
        [self.scrollView reloadEmptyDataSet];
        [self setViewHidden:NO];
        [TipViewManager dismissLoading];
    });
}

- (void)setViewHidden:(BOOL)hidden{
    self.headView.hidden = hidden;
    self.iconImageView.hidden = hidden;
    self.phoneLabel.hidden = hidden;
    self.headeImageView.hidden = hidden;
    self.faceLoginBtn.hidden = hidden;
    self.toggleLoginModeBtn.hidden = hidden;
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.headView];
    [self.headView addSubview:self.iconImageView];
    [self.headView addSubview:self.phoneLabel];
    [self.scrollView addSubview:self.headeImageView];
    [self.scrollView addSubview:self.faceLoginBtn];
    [self.scrollView addSubview:self.toggleLoginModeBtn];
    self.scrollView.emptyDataSetSource = self;
    self.scrollView.emptyDataSetDelegate = self;
    [self setupLayOut];
}



- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"刷脸登录";
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.height.mas_equalTo(70);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(111);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50,50));
    }];
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.mas_equalTo(27);
        make.height.mas_equalTo(16);
    }];

    [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(255,230));
    }];

    [self.faceLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headeImageView.mas_bottom).offset(60);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo(44);
    }];
    [self.toggleLoginModeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceLoginBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(261);
    }];

}


#pragma mark - event
- (void)toggleLoginModeBtnClick {
    LLog(@"切换登录方式");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)faceLoginBtnClick {
    LLog(@"刷脸登录");
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)sendFaceImage:(UIImage *)faceImage{
    self.sendFaceCount++;
    if (self.sendFaceCount == 6) {
        self.sendFaceCount = 0;
        self.headeImageView.image = faceImage;
        [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
            make.centerX.mas_equalTo(self.scrollView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(240,320));
        }];
        self.faceLoginBtn.hidden = YES;
        self.toggleLoginModeBtn.hidden = YES;
        WS(weakSelf);
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:faceImage];
        if ([TipViewManager showNetErrorToast]) {
            [TipViewManager showLoadingWithText:@"认证中..."];
            [weakSelf.imageManager uploadImagesWithImagesArray:arr completeBlock:^(NSMutableArray * _Nullable imageUrls) {
                if (arr.count != imageUrls.count) {
                    [TipViewManager dismissLoading];
                    [TipViewManager showToastMessage:@"认证失败，请重新认证"];
                    return ;
                }
                NSString *faceImgUrl = [imageUrls objectAtIndex:0];
                [weakSelf userFaceDetect:faceImgUrl];
            }];
        }
    }
}

- (void)userFaceDetect:(NSString *)faceImgUrl{
    [self.service userFaceDetect:faceImgUrl delegate:self];
}


- (void)userFaceCompare:(NSString *)faceToken{
    [self.service userFaceCompare:self.loginId faceToken:faceToken delegate:self];
}



- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KFaceDetectRequest]) {
            UserFaceDetectModel *model = (UserFaceDetectModel *)resObj;
            if (model.error_code.integerValue == 0) {
                 WS(weakSelf);
                FaceTokenModel *faceTokenModel = model.data;
                NSString *faceToken = faceTokenModel.faceToken;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [weakSelf userFaceCompare:faceToken];
                });
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }else if ([reqType isEqualToString:KFaceCompareFaceRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"登录成功"];
                model.data.hasLogin = YES;
                [UserModel updateUserModel:model];
                UserInfoModel *suer = model.data;
                //设置LoginToke
                [[BaseNetWorkService sharedInstance] setLoginToken:suer.token];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccessNotification object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {

                [TipViewManager showToastMessage:model.error_msg];
//                [TipViewManager showToastMessage:@"认证失败，请重新认证"];
                self.faceLoginBtn.hidden = NO;
                self.toggleLoginModeBtn.hidden = NO;
                self.headeImageView.image = [UIImage imageNamed:@"sign_face"];
                [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
                    make.centerX.mas_equalTo(self.scrollView.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(255,230));
                }];

            }
        }
    }
    else {
        [TipViewManager showToastMessage:@"认证失败，请重新认证"];
        self.faceLoginBtn.hidden = NO;
        self.toggleLoginModeBtn.hidden = NO;
        self.headeImageView.image = [UIImage imageNamed:@"sign_face"];
        [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
            make.centerX.mas_equalTo(self.scrollView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(255,230));
        }];

    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ![BaseNetWorkService isReachable] ? @"无网络" : @"无数据";
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:21];
    UIColor *textColor = [UIColor colorFromRGB:0x474455];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ![BaseNetWorkService isReachable] ? @"当前网络连接失败，\n快去重新连接一下试试吧！" : @"当前没有相应数据，快去看看别的吧！";
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
    UIColor *textColor = [UIColor colorWithHex:0x666666 alpha:0.7];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ![BaseNetWorkService isReachable] ? [UIImage imageNamed:@"currency_no_network"] : [UIImage imageNamed:@"currency_no_data"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return ![BaseNetWorkService isReachable] ? [[NSAttributedString alloc] initWithString:@"重试" attributes:@{
                                                                                                             NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                             NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                                                                             }] : [[NSAttributedString alloc] initWithString:@""];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-28, -100, -25, -100);
    UIImage *image = [UIImage imageNamed:@"currency_no_network_button"];
    return ![BaseNetWorkService isReachable] ? [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets] : nil;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - kNavigationBarH;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {

}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {

}


#pragma mark - lazy
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
    }
    return _headView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"my_head"];
    }
    return _iconImageView;

}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor colorFromRGB:0xFF1D1D26];
        _phoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _phoneLabel;
}

- (UIImageView *)headeImageView{
    if (!_headeImageView) {
        _headeImageView = [[UIImageView alloc] init];
        _headeImageView.image = [UIImage imageNamed:@"sign_face"];
    }
    return _headeImageView;
}

- (UIButton *)faceLoginBtn {
    if (!_faceLoginBtn) {
        _faceLoginBtn = [ZRSWViewFactoryTool getBlueBtn:@"点击进行刷脸登录" target:self action:@selector(faceLoginBtnClick)];
    }
    return _faceLoginBtn;
}

- (UIButton *)toggleLoginModeBtn {
    if (!_toggleLoginModeBtn) {
        _toggleLoginModeBtn = [self getGrayBtn:@"切换登录方式" action:@selector(toggleLoginModeBtnClick)];
    }
    return _toggleLoginModeBtn;
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
