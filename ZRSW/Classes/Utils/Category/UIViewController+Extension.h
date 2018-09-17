//
//  UIViewController+Extension.h
//  LXMath
//
//  Created by 周培玉 on 2018/1/19.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)
//找到当前视图控制器
+ (UIViewController *)currentViewController;

//找到当前导航控制器
+ (UINavigationController *)currentNavigatonController;

/**
 * 在当前视图控制器中添加子控制器，将子控制器的视图添加到 view 中
 *
 * @param childController 要添加的子控制器
 * @param view            要添加到的视图
 */
- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view;

@property (copy, nonatomic) NSString *method;

@end
