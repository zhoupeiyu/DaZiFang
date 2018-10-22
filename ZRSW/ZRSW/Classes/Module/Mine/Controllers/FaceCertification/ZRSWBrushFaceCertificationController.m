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


@end

@implementation ZRSWBrushFaceCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.isCertificed = NO;
    self.title = @"刷脸认证";
    UserModel *userModel = [UserModel getCurrentModel];
    UserInfoModel *userInfoModel = userModel.data;
    self.loginId = userInfoModel.loginId;
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
    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
    faceVC.faceDelegate = self;
    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)sendFaceImage:(UIImage *)faceImage{
    self.imageView.image = faceImage;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(240,320));
    }];
    self.titleLabel.hidden = YES;
    self.certificeBtn.hidden = YES;
    WS(weakSelf);
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:faceImage];
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoadingWithText:@"认证中..."];
        [self.imageManager uploadImagesWithImagesArray:arr completeBlock:^(NSMutableArray * _Nullable imageUrls) {
            if (arr.count != imageUrls.count) {
                [TipViewManager showToastMessage:@"图片上传失败，请重新上传！"];
                return ;
            }
            NSString *faceImgUrl = [imageUrls objectAtIndex:0];
            [weakSelf.service userFaceDetect:faceImgUrl delegate:self];
        }];
    }
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
                    [weakSelf.service userAddFace:self.loginId faceToken:faceToken delegate:self];
                });
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }else if ([reqType isEqualToString:KFaceAddFaceRequest]) {
            UserAddFaceModel *model = (UserAddFaceModel *)resObj;
            if (model.error_code.integerValue == 0) {
                AddFaceModel *addFaceModel = model.data;
                [TipViewManager showToastMessage:addFaceModel.successMsg];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }
    else {
        [TipViewManager showToastMessage:@"认证失败，请重新认证"];
        self.titleLabel.hidden = NO;
        self.certificeBtn.hidden = NO;
        if (self.isCertificed) {
            self.imageView.image = [UIImage imageNamed:@"face_icon_certified"];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
                make.centerX.mas_equalTo(self.scrollView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(150, 150));
            }];
        }else{
            self.imageView.image = [UIImage imageNamed:@"face_icon_uncertified"];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
                make.centerX.mas_equalTo(self.scrollView.mas_centerX);
                make.centerX.mas_equalTo(self.scrollView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(290,371));
            }];
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
