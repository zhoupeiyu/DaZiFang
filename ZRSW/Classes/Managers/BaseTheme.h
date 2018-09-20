//
//  TabBarControllerManager.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTabBarViewController.h"

@interface BaseTheme : NSObject

#pragma mark - 配置
+ (UIColor *)baseViewColor;

+ (UIColor *)tabBarTitleNormalColor;
+ (UIColor *)tabBarTitleSelectedColor;


+ (UIColor *)navBarTitleColor;
+ (UIFont *)navBarTitleFont;
+ (UIImage *)navBackgroundImage;
+ (UIColor *)navBarBottomLineColor;
+ (UIColor *)navBarLeftTextColor;
+ (UIColor *)navBarRightTextColor;
+ (UIColor *)navBarLeftHTextColor;
+ (UIColor *)navBarRightHTextColor;

+ (UIFont *)navBarLeftTextFont;
+ (UIFont *)navBarRightTextFont;

#pragma mark -tabBarController

+ (BaseTheme *)sharedInstance;

+ (BaseTabBarViewController *)tabBarController;

@end
