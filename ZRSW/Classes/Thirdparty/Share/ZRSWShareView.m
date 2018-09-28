//
//  ZRSWShareView.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWShareView.h"
#import "SynthesizeSingleton.h"
#import "ZRSWActionSheetView.h"
@interface ZRSWShareView ()<PlatformButtonClickDelegate>

@property (nonatomic, weak) id<ShareHandlerDelegate> shareDelegate;
@property (nonatomic, assign) ShareSourceType shareType;
@property (nonatomic, strong) ZRSWShareModel *content;
@property (nonatomic, assign) BOOL sharingApp;

@end

@implementation ZRSWShareView
//单例
SYNTHESIZE_SINGLETON_ARC(ZRSWShareView)

+ (void)shareContent:(ZRSWShareModel *)content shareSourceType:(ShareSourceType)type delegate:(id<ShareHandlerDelegate>)delegate {
   if (type == ShareSourceWap) {
        content.content =   content.content.length > 100 ? [content.content substringToIndex:99] : content.content;
        CGFloat compressWith = 600;
        UIImage *image = content.thumbImage;
        if(image.size.height > compressWith || image.size.width > compressWith){
            if (image.size.width > image.size.height) {
                image = [image scaleToSize:CGSizeMake(compressWith, image.size.height / image.size.width * compressWith)];
            }else{
                image = [image scaleToSize:CGSizeMake(image.size.width / image.size.height * compressWith, compressWith)];
            }
        }
        content.thumbImage = image;
    }
    [[self sharedInstance] showShareView:content shareSourceType:type delegate:delegate];
}
+ (void)shareImage:(UIImage *)shareImage delegate:(id<ShareHandlerDelegate>)delegate {
    ZRSWShareModel *shareModel = [[ZRSWShareModel alloc] init];
    shareModel.thumbImage = shareImage;
    [[self sharedInstance] showShareView:shareModel shareSourceType:ShareSourceImage delegate:delegate];
}
+ (void)shareImageURL:(NSString *)shareImageUrl delegate:(id<ShareHandlerDelegate>)delegate {
    ZRSWShareModel *shareModel = [[ZRSWShareModel alloc] init];
    shareModel.thumImageUrlStr = shareImageUrl;
    [[self sharedInstance] showShareView:shareModel shareSourceType:ShareSourceImage delegate:delegate];
}
- (void)showShareView:(ZRSWShareModel *)content shareSourceType:(ShareSourceType)type delegate:(id<ShareHandlerDelegate>)delegate {
    ZRSWActionSheetView *actionSheetView=[[ZRSWActionSheetView alloc] initAtionSheetView];
    actionSheetView.delegate=self;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:actionSheetView];
    [window bringSubviewToFront:actionSheetView];
    self.shareType = type;
    self.shareDelegate = delegate;
    self.content = content;
}

- (void) customActionSheetButtonClick:(ZRSWActionSheetButton *) btn{
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    BOOL qqavailable = [ZRSWShareManager isInstallQQ];
    BOOL wxavailable = [ZRSWShareManager isInstallWeChat];
    BOOL wbavailable = [ZRSWShareManager isImstallWeiBo];

    switch (btn.tag)
    {
        case 0:
        {
            type = UMSocialPlatformType_WechatSession;
            LLog(@"微信好友");
        }
            break;
        case 1:
        {
            type = UMSocialPlatformType_QQ;
             LLog(@"QQ好友");

        }
            break;
        case 2:
        {
            type = UMSocialPlatformType_WechatTimeLine;
             LLog(@"朋友圈");

        }
            break;
        case 3:
        {
             type = UMSocialPlatformType_Sina;
             LLog(@"新浪微博");

        }
            break;
        default:
        {

        }
            break;
    }
    if (type == UMSocialPlatformType_WechatSession || type == UMSocialPlatformType_WechatTimeLine) {
        if (wxavailable) {
            [self shareActionWithUMSocialPlatformType:type content:self.content shareSourceType:self.shareType delegate:self.shareDelegate];
        }else{
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请安装微信" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];
        }
    }else  if (type == UMSocialPlatformType_QQ) {
        if (qqavailable) {
            [self shareActionWithUMSocialPlatformType:type content:self.content shareSourceType:self.shareType delegate:self.shareDelegate];
        }else{
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请安装QQ" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];
        }
    }else  if (type == UMSocialPlatformType_WechatSession) {
        if (wbavailable) {
            [self shareActionWithUMSocialPlatformType:type content:self.content shareSourceType:self.shareType delegate:self.shareDelegate];
        }else{
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请安装微信" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];
        }
    }else  if (type == UMSocialPlatformType_Sina) {
        if (wxavailable) {
            [self shareActionWithUMSocialPlatformType:type content:self.content shareSourceType:self.shareType delegate:self.shareDelegate];
        }else{
            UIAlertAction * confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请安装新浪微博" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:confirmAction];
            [[self appRootViewController] presentViewController:alertView animated:YES completion:nil];
        }
    }
}

- (void)shareActionWithUMSocialPlatformType:(UMSocialPlatformType)type content:(ZRSWShareModel *)content shareSourceType:(ShareSourceType)sourcetype delegate:(id<ShareHandlerDelegate>)delegate{

     [ZRSWShareManager shareToPlatformType:type Content:content shareSourceType:sourcetype delegate:delegate];
}

- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC =appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


@end
