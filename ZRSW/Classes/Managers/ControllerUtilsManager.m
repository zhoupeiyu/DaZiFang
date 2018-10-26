//
//  ControllerUtilsManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ControllerUtilsManager.h"
#import "BaseWebViewController.h"

@implementation ControllerUtilsManager

+ (BOOL)isHTTPURL:(NSString *)url {
    return [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"];
}

+ (BOOL)canShowViewWithURL:(NSString *)url {
    if ([url isEqual:[NSNull null]]) {
        return NO;
    }
    if ([self isHTTPURL:url]) {
        return YES;
    }
    return NO;
}

+ (void)showNormalWebViewWithURL:(NSString *)url {
    if (0 == url.length) {
        return;
    }
    if (![self canShowViewWithURL:url]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法打开连接" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self isHTTPURL:url]) {
        BaseWebViewController *webViewController = [[BaseWebViewController alloc] init];
        BaseNavigationViewController *nvc = [[BaseNavigationViewController alloc]initWithRootViewController:webViewController];
        [webViewController showWebView:url];
        [[UIViewController currentViewController] presentViewController:nvc animated:YES completion:nil];
        return;
    }
}
+ (void)showViewWithURL:(NSString *)url {
    if (0 == url.length) {
        return;
    }
    if (![self canShowViewWithURL:url]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法打开连接" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self isHTTPURL:url]) {
        NSURL *rurl = [NSURL URLWithString:url];
        TOWebViewController *webViewController = [self webViewControllerWithURL:rurl];
        BaseNavigationViewController *nvc = [[BaseNavigationViewController alloc]initWithRootViewController:webViewController];
        webViewController.doneButtonTitle = @"取消";
        webViewController.buttonTintColor = [UIColor whiteColor];
        webViewController.showActionButton = NO;
        [[UIViewController currentViewController] presentViewController:nvc animated:YES completion:nil];
        return;
    }
}

+ (TOWebViewController *)webViewControllerWithURL:(NSURL *)url {
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    webViewController.showUrlWhileLoading = NO;
    return webViewController;
}
@end
