//
//  TipViewManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "TipViewManager.h"

static NSString *const LoadingText = @"加载中,请稍后...";
static NSString *NetWorkErrorText = @"当前网络不给力，请在试一次";


@interface TipViewManager ()

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) CSToastStyle *toastStyle;

@end
@implementation TipViewManager

SYNTHESIZE_SINGLETON_ARC(TipViewManager);

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PSTAlertControllerStyle)style actionTitle:(NSString *)actionTitle handler:(void (^)(PSTAlertAction *action))handler controller:(UIViewController *)controller completion:(void (^)(void))completion {
    [self showAlertControllerWithTitle:title message:message preferredStyle:style actionTitleOne:actionTitle handlerOne:handler actionTitleTwo:@"" handlerTwo:nil controller:controller completion:completion];
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PSTAlertControllerStyle)style actionTitleOne:(NSString *)actionTitleOne handlerOne:(void (^)(PSTAlertAction *action))handlerOne  actionTitleTwo:(NSString *)actionTitleTwo handlerTwo:(void (^)(PSTAlertAction *action))handlerTwo controller:(UIViewController *)controller completion:(void (^)(void))completion {
    PSTAlertController *alertVC = [PSTAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    [alertVC addAction:[PSTAlertAction actionWithTitle:actionTitleOne handler:handlerOne]];
    [alertVC addAction:[PSTAlertAction actionWithTitle:actionTitleTwo handler:handlerTwo]];
    [alertVC showWithSender:nil controller:controller animated:YES completion:completion];
}

+ (void)showAlertViewCustomView:(UIView *)customView willShowHandler:(void (^)(UIView *view))willShowHandler didShowHandler:(void (^)(UIView *view))didShowHandler willHideHandler:(void (^)(UIView *view))willHideHandler didHideHandler:(void (^)(UIView *view))didHideHandler dismissComplete:(void (^)(void))dismissComplete controller:(UIViewController *)controller completion:(void (^)(void))completion {
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:customView preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationScaleFade];
    [alertController setViewWillHideHandler:willShowHandler];
    [alertController setViewDidShowHandler:didShowHandler];
    [alertController setViewWillHideHandler:willHideHandler];
    [alertController setViewDidHideHandler:didHideHandler];
    [alertController setDismissComplete:dismissComplete];
    [controller presentViewController:alertController animated:YES completion:completion];
}

+ (void)showLoading {
    [[self sharedInstance] showLoading];
}
+ (void)dismissLoading {
    [[self sharedInstance] dismissLoading];
}

- (void)showLoading {
    [self.hud removeFromSuperview];
    UIViewController *vc = [UIViewController currentViewController];
    if (!vc.navigationController.view){
        return;
    }
    self.hud = [[MBProgressHUD alloc] initWithView:vc.navigationController.view];
    [vc.navigationController.view addSubview:self.hud];
    self.hud.label.text = LoadingText;
    self.hud.label.font = [UIFont systemFontOfSize:13.f];
    self.hud.bezelView.backgroundColor = [UIColor blackColor];
    self.hud.label.textColor = [UIColor whiteColor];
    self.hud.activityIndicatorColor = [UIColor whiteColor];
    [self.hud showAnimated:YES];
}
- (void)dismissLoading {
    [self.hud removeFromSuperview];
    self.hud = nil;
}

- (UIImage *)errorImage {
    return [UIImage imageNamed:@"toast_error"];
}
- (UIImage *)successImage {
    return [UIImage imageNamed:@"toast_done"];
}
- (UIImage *)attentionImage {
    return [UIImage imageNamed:@"toast_attention"];
}

- (CSToastStyle *)toastStyle {
    if (!_toastStyle) {
        _toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        _toastStyle.backgroundColor = [[UIColor blackColor] colorWithMinimumSaturation:0.5];
        _toastStyle.titleColor = [UIColor whiteColor];
        _toastStyle.messageColor = [UIColor whiteColor];
        _toastStyle.titleFont = [UIFont systemFontOfSize:18];
        _toastStyle.titleNumberOfLines = 0;
        _toastStyle.cornerRadius = 6;
    }
    return _toastStyle;
}
- (BOOL)showNetErrorToast {
    if ([BaseNetWorkService isReachable]) {
        return YES;
    }
    else {
        [self showToastMessage:NetWorkErrorText];
        return NO;
    }
}

- (void)showToastMessage:(NSString *)errorMsg {
    UIViewController *vc = [UIViewController currentViewController];
    [vc.view makeToast:@"" duration:0.3 position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5 - kNavigationBarH)] title:errorMsg image:nil style:[self toastStyle] completion:nil];
}

+ (BOOL)showNetErrorToast {
    return [[self sharedInstance] showNetErrorToast];
}
+ (void)showToastMessage:(NSString *)errorMsg {
    return [[self sharedInstance] showToastMessage:errorMsg];
}

//+ (LYEmptyView *)netWorkErrorView:(void (^)(void))action; {
//    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"currency_no_network"
//                                                             titleStr:@"无网络"
//                                                            detailStr:@"当前网络连接失败，\n快去重新连接一下试试吧！"
//                                                          btnTitleStr:@"重试"
//                                                        btnClickBlock:action];
//    emptyView.subViewMargin = 20.f;
//    emptyView.contentViewOffset = - 50;
//    
//    emptyView.titleLabFont = [UIFont fontWithName:@"MicrosoftYaHei" size:21];
//    emptyView.titleLabTextColor = [UIColor colorFromRGB:0x474455];
//    emptyView.detailLabFont = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
//    emptyView.detailLabTextColor = [UIColor colorWithHex:0x666666 alpha:0.7];
//    
//    emptyView.actionBtnFont = [UIFont systemFontOfSize:21];
//    emptyView.actionBtnTitleColor = [UIColor whiteColor];
//    emptyView.actionBtnHeight = 40.f;
//    emptyView.actionBtnHorizontalMargin = 50;
//    emptyView.actionBtnCornerRadius = 4.f;
//    emptyView.actionBtnBorderColor = [UIColor colorWithHex:0x4771f2 alpha:1];
//    emptyView.actionBtnBorderWidth = KSeparatorLineHeight;
//    emptyView.actionBtnBackGroundColor = [UIColor colorWithHex:0x4771f2 alpha:1];
//    return emptyView;
//}
@end
