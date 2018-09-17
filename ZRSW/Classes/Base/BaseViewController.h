//
//  BaseViewController.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetWorkService.h"

@interface BaseViewController : UIViewController <BaseNetWorkServiceDelegate>

@property (nonatomic, strong) UIButton *leftBarButton; //导航左侧按钮
@property (nonatomic, strong) UIButton *rightBarButton; //导航右侧按钮

@property (nonatomic, assign) BOOL preferNavigationHidden; // 隐藏导航，在viewWillAppear中

- (void)setupConfig;

- (void)setupUI;

- (void)setupLayOut;

/**
 状态栏是否显示
 
 @param aHidden 显示字段
 */
- (void)setStatusBarHidden:(BOOL)aHidden;

/**
 *  设置导航默认返回按钮
 */
- (void)setLeftBackBarButton;
/**
 *  设置导航左侧按钮图片
 *
 *  @param normalImage    正常图片
 *  @param highLightImage 高亮图片
 */
- (void)setLeftBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage;

- (void)setLeftBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage AndText:(NSString *)text;
/**
 *  设置导航左侧按钮文本
 *
 *  @param text 导航按钮文本
 */
- (void)setLeftBarButtonWithText:(NSString *)text;
/**
 *  设置导航右侧按钮图片
 *
 *  @param normalImage    正常图片
 *  @param highLightImage 高亮图片
 */
- (void)setRightBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage;
/**
 *  设置导航右侧按钮文本
 *
 *  @param text 导航按钮文本
 */
- (void)setRightBarButtonWithText:(NSString *)text;
- (void)setRightBarRightButton:(UIButton *)rightButton leftButton:(UIButton *)leftButton;

@end
