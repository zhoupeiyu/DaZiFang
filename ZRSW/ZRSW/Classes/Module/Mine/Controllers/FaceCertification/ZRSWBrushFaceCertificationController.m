//
//  ZRSWBrushFaceCertificationController.m
//  ZRSW
//
//  Created by King on 2018/10/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBrushFaceCertificationController.h"
#import "FaceStreamDetectorViewController.h"
#import "UserService.h"
@interface ZRSWBrushFaceCertificationController ()<FaceDetectorDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *certificeBtn;
@property (nonatomic, assign) BOOL isCertificed;
@property (nonatomic, strong) UserService *service;
@property (nonatomic, strong) UploadImagesManager *imageManager;
@property (nonatomic, strong) NSString *loginId;
@property (nonatomic, assign) NSInteger sendFaceCount;
@property (nonatomic, assign) NSInteger addFaceCount;
@property (nonatomic, assign) BOOL certificationError;
@property (nonatomic, copy) NSString *faceTokens;


@end

@implementation ZRSWBrushFaceCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.sendFaceCount = 0;
    self.addFaceCount = 0;
    self.faceTokens = nil;
    self.certificationError = NO;
}


- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.certificeBtn];
    [self setupLayOut];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    UserModel *userModel = [UserModel getCurrentModel];
    UserInfoModel *userInfoModel = userModel.data;
    self.loginId = userInfoModel.phone;
    self.isCertificed = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@%@",self.loginId,BrushFaceCertificationKey]];
    self.title = @"刷脸认证";
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(16);
    }];
    if (self.isCertificed) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.scrollView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(150, 150));
        }];
        [self.certificeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(50);
            make.left.mas_equalTo(30);
            make.width.mas_equalTo(SCREEN_WIDTH-60);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
            make.centerX.mas_equalTo(self.scrollView.mas_centerX);
            make.centerX.mas_equalTo(self.scrollView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(290,371));
        }];
        [self.certificeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(40);
            make.left.mas_equalTo(30);
            make.width.mas_equalTo(SCREEN_WIDTH-60);
            make.height.mas_equalTo(44);
        }];
    }
}


#pragma mark - event
- (void)certificeBtnClick {
    LLog(@"开始认证");
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
             WS(weakSelf);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [weakSelf certificeBtnClick];
                    });
                }
            }];
        } else {
            [self certificeBtnClick];
        }
    }else{
        FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
        faceVC.faceDelegate = self;
        [self.navigationController pushViewController:faceVC animated:YES];
    }
}

-(void)sendFaceImage:(UIImage *)faceImage{
    self.sendFaceCount++;
    WS(weakSelf);
    NSMutableArray *arr = [NSMutableArray array];
    if (faceImage) {
        [arr addObject:faceImage];
    }
    if ([TipViewManager showNetErrorToast]) {
        if (self.sendFaceCount == 6) {
            [TipViewManager showLoadingWithText:@"认证中..."];
        }
        [self.imageManager uploadImagesWithImagesArray:arr completeBlock:^(NSMutableArray * _Nullable imageUrls) {
            if (arr.count != imageUrls.count) {
                LLog(@"图片上传失败，请重新上传！");
                [TipViewManager dismissLoading];
                if (!self.certificationError) {
                    self.certificationError = YES;
                    [TipViewManager showToastMessage:@"认证失败，请重新认证"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BrushFaceCertificationResultNotification object:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"result", nil]];
                }
                return ;
            }
            NSString *faceImgUrl = [imageUrls objectAtIndex:0];
            [weakSelf userFaceDetect:faceImgUrl];
        }];
    }
}

- (void)userFaceDetect:(NSString *)faceImgUrl{
  [self.service userFaceDetect:faceImgUrl delegate:self];
}


- (void)userAddFace:(NSString *)faceToken{
    [self.service userAddFace:self.loginId faceToken:faceToken delegate:self];
}


- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KFaceDetectRequest]) {
            UserFaceDetectModel *model = (UserFaceDetectModel *)resObj;
            if (model.error_code.integerValue == 0) {
                WS(weakSelf);
                FaceTokenModel *faceTokenModel = model.data;
                NSString *faceToken = faceTokenModel.faceToken;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakSelf userAddFace:faceToken];
                    self.addFaceCount++;
                    if (self.faceTokens.length>0) {
                        self.faceTokens = [self.faceTokens stringByAppendingString:[NSString stringWithFormat:@",%@",faceToken]];
                    }else{
                        self.faceTokens = [NSString stringWithFormat:@"%@",faceToken];
                    }
                    if (self.addFaceCount == 6) {
                        [weakSelf userAddFace:self.faceTokens];
                    }
                });
            }else {
                [TipViewManager dismissLoading];
                if (!self.certificationError) {
                    self.certificationError = YES;
                    [TipViewManager showToastMessage:model.error_msg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BrushFaceCertificationResultNotification object:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"result", nil]];
                }
            }
        }else if ([reqType isEqualToString:KFaceAddFaceRequest]) {
            UserAddFaceModel *model = (UserAddFaceModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager dismissLoading];
                [TipViewManager showToastMessage:@"认证成功"];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@%@",self.loginId,BrushFaceCertificationKey]];
                [[NSNotificationCenter defaultCenter] postNotificationName:BrushFaceCertificationResultNotification object:[NSDictionary dictionaryWithObjectsAndKeys:@"Successful",@"result", nil]];
            }else {
                [TipViewManager dismissLoading];
                if (!self.certificationError) {
                    self.certificationError = YES;
                    [TipViewManager showToastMessage:model.error_msg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BrushFaceCertificationResultNotification object:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"result", nil]];
                }
            }
        }
    }
    else {
        [TipViewManager dismissLoading];
        if (!self.certificationError) {
            self.certificationError = YES;
            [TipViewManager showToastMessage:@"认证失败，请重新认证"];
            [[NSNotificationCenter defaultCenter] postNotificationName:BrushFaceCertificationResultNotification object:[NSDictionary dictionaryWithObjectsAndKeys:@"Error",@"result", nil]];
        }
    }
}

#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        if (self.isCertificed) {
            _titleLabel.text = @"已认证";
            _titleLabel.textColor = [UIColor colorFromRGB:0x4771F2];
        }else{
            _titleLabel.text = @"请将正对手机去，确保光线充足";
            _titleLabel.textColor = [UIColor colorFromRGB:0x999999];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        if (self.isCertificed) {
            _imageView.image = [UIImage imageNamed:@"face_icon_certified"];
        }else{
            _imageView.image = [UIImage imageNamed:@"face_icon_uncertified"];
        }
    }
    return _imageView;
}

- (UIButton *)certificeBtn {
    if (!_certificeBtn) {
        if (self.isCertificed) {
             _certificeBtn = [ZRSWViewFactoryTool getBlueBtn:@"重新认证" target:self action:@selector(certificeBtnClick)];
        }else{
             _certificeBtn = [ZRSWViewFactoryTool getBlueBtn:@"开始认证" target:self action:@selector(certificeBtnClick)];
        }
    }
    return _certificeBtn;
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
