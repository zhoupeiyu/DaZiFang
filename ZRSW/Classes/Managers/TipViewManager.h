//
//  TipViewManager.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PSTAlertController.h>
#import <TYAlertController.h>
#import <LYEmptyView.h>

#define NetworkError @"网络错误，请检查网络!"

@interface TipViewManager : NSObject

+ (TipViewManager *)sharedInstance;

// 弹框
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PSTAlertControllerStyle)style actionTitle:(NSString *)actionTitle handler:(void (^)(PSTAlertAction *action))handler controller:(UIViewController *)controller completion:(void (^)(void))completion;

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(PSTAlertControllerStyle)style actionTitleOne:(NSString *)actionTitleOne handlerOne:(void (^)(PSTAlertAction *action))handlerOne  actionTitleTwo:(NSString *)actionTitleTwo handlerTwo:(void (^)(PSTAlertAction *action))handlerTwo controller:(UIViewController *)controller completion:(void (^)(void))completion;

+ (void)showAlertViewCustomView:(UIView *)customView willShowHandler:(void (^)(UIView *view))willShowHandler didShowHandler:(void (^)(UIView *view))didShowHandler willHideHandler:(void (^)(UIView *view))willHideHandler didHideHandler:(void (^)(UIView *view))didHideHandler dismissComplete:(void (^)(void))dismissComplete controller:(UIViewController *)controller completion:(void (^)(void))completion;


+ (void)showLoading;
+ (void)dismissLoading;

+ (BOOL)showNetErrorToast;
+ (void)showToastMessage:(NSString *)errorMsg;

// 无网界面
+ (LYEmptyView *)netWorkErrorView:(void (^)(void))action;

@end
