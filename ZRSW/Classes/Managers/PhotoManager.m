//
//  PhotoManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "PhotoManager.h"

@interface  PhotoManager()<UIImagePickerControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) UIViewController *presentedVC;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, assign) PhotoPickType photoPickType;
@property (nonatomic, copy) SelectedImagesBlock selectedBlcok;

@end
@implementation PhotoManager

SYNTHESIZE_SINGLETON_ARC(PhotoManager);

- (void)showPhotoPickForMaxCount:(NSInteger)maxCount presentedViewController:(UIViewController *)presentedVC photoPickType:(PhotoPickType)photoPickType complete:(SelectedImagesBlock)selectedBlcok {
    self.maxCount = maxCount;
    self.presentedVC = presentedVC;
    self.photoPickType = photoPickType;
    self.selectedBlcok = selectedBlcok;
    
    if (_imageArr.count > 0) {
        [_imageArr removeAllObjects];
    }
    [self showPickView];
}
- (void)showPhotoPickForMaxCount:(NSInteger)maxCount presentedViewController:(UIViewController *)presentedVC photoPickType:(PhotoPickType)photoPickType{
    [self showPhotoPickForMaxCount:maxCount presentedViewController:presentedVC photoPickType:photoPickType complete:nil];
}

- (void)showPickView {
    if (self.photoPickType == PhotoPickTypeSystem) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库", nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.presentedVC.view];
    }
    else if (self.photoPickType == PhotoPickTypeWeChat) {
        WS(weakSelf);
        UIColor *titleColor = [UIColor colorFromRGB:0x444152];
        UIFont *titleFont = [UIFont systemFontOfSize:18];
        SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeRaiseUp];
        
        SPAlertAction *photoAction = [SPAlertAction actionWithTitle:@"拍照或录像" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            [weakSelf takePhoto];
        }];
        photoAction.titleFont = titleFont;
        photoAction.titleColor = titleColor;
        
        SPAlertAction *albumAction = [SPAlertAction actionWithTitle:@"照片图库" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
            [self localPhoto];
        }];
        albumAction.titleFont = titleFont;
        albumAction.titleColor = titleColor;
        
        SPAlertAction *cancelAction = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
            
        }];
        cancelAction.titleFont = titleFont;
        cancelAction.titleColor = titleColor;
        
        [alertController addAction:photoAction];
        [alertController addAction:albumAction];
        [alertController addAction:cancelAction];
        [self.presentedVC presentViewController:alertController animated:YES completion:nil];
    }
}
- (NSMutableArray *)selectedImages {
    return self.imageArr;
}
- (void)takePhoto{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)localPhoto{
    NSUInteger maxImageCount = self.maxCount - self.imageArr.count;
    NSUInteger colNum = 3;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount columnNumber:colNum delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.navigationBar.translucent = YES;
    imagePickerVc.isSelectOriginalPhoto = YES;
    //默认为YES，如果设置为NO,拍照按钮将隐藏,用户将不能选择照片
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.isAllowShowNum = YES;
    imagePickerVc.isStatusBarDefault = YES;
    imagePickerVc.needShowStatusBar = YES;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.circleCropRadius = SCREEN_WIDTH/2.f;
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleColor = [UIColor getFontBlackColor];
    imagePickerVc.naviTitleFont = [UIFont systemFontOfSize:17];
    imagePickerVc.barItemTextColor = [UIColor getFontBlackColor];
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:15];
    imagePickerVc.photoPreviewOriginDefImageName = @"post_originalimage_normal";
    imagePickerVc.photoOriginSelImageName = @"post_originalimage_selected";
    imagePickerVc.photoOriginDefImageName = @"post_originalimage_normal";
    imagePickerVc.photoOriginSelImageName = @"post_originalimage_selected";
    imagePickerVc.oKButtonTitleColorNormal = [UIColor getFontBlueColor];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor colorFromRGB:0xb5b5b5];
    imagePickerVc.oKButtonTitleColorHighlighted = [UIColor getFontPressesBlueColor];
    imagePickerVc.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
        [leftButton setImage:[UIImage imageNamed:@"navi_back_26x26_"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"navi_back_shadow_26x26_"] forState:UIControlStateHighlighted];
        [leftButton setTitle:@"相册" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor getFontBlackColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor getFontBlackColor] forState:UIControlStateHighlighted];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [leftButton sizeToFit];
        
    };
    [self.presentedVC presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self.imageArr addObjectsFromArray:photos];
    if (self.selectedBlcok) {
        self.selectedBlcok(self.imageArr);
    }
}
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //TODO:选择照片或者照相完成以后的处理
    __block UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if (!_imageArr) {
            _imageArr = [NSMutableArray array];
        }
        [_imageArr addObject:image];
        if (self.selectedBlcok) {
            self.selectedBlcok(self.imageArr);
        }
    }];
}
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self.presentedVC presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==101) {
        switch (buttonIndex) {
            case 0:{
                [self takePhoto];
                break;
            }
            case 1:{
                [self localPhoto];
                break;
            }
            default:
                break;
        }
    }
    else{
    }
}

#pragma mark - lazy

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (ISIOS7_ORLESS) {
            _imagePickerVc.navigationBar.barTintColor = self.presentedVC.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.presentedVC.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (ISIOS9_GREATER) {
            if (@available(iOS 9.0, *)) {
                tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            } else {
            }
            if (@available(iOS 9.0, *)) {
                BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            } else {
                // Fallback on earlier versions
            }
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

@end
