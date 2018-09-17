//
//  TabBarControllerManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseTheme.h"

@interface BaseTheme ()

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *tabBarItemsAttributes;


@end
@implementation BaseTheme

SYNTHESIZE_SINGLETON_ARC(BaseTheme);

+ (UIColor *)baseViewColor {
    return [UIColor colorFromRGB:0xf2f2f2];
}

+ (UIColor *)tabBarTitleNormalColor {
    return [UIColor colorFromRGB:0xB8B8B8];
}
+ (UIColor *)tabBarTitleSelectedColor {
    return [UIColor colorFromRGB:0x474455];
}


+ (UIColor *)navBarTitleColor {
    return [UIColor colorFromRGB:0xffffff];
}
+ (UIFont *)navBarTitleFont {
    return [UIFont systemFontOfSize:21];
}
+ (UIImage *)navBackgroundImage {
    UIColor *color1 = [UIColor colorFromRGB:0x62606E];
    UIColor *color2 = [UIColor colorFromRGB:0x474455];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavigationBarH) andColors:@[color1,color2]]];
    return image;
}
+ (UIColor *)navBarBottomLineColor {
    return [UIColor colorFromRGB:0xdfdfdf];
}
+ (UIColor *)navBarLeftTextColor {
    return [UIColor colorFromRGB:0xffffff];
}
+ (UIColor *)navBarRightTextColor {
    return [UIColor colorFromRGB:0xffffff];
}
+ (UIFont *)navBarLeftTextFont {
    return [UIFont systemFontOfSize:16];
}
+ (UIFont *)navBarRightTextFont {
    return [UIFont systemFontOfSize:16];
}
+ (UIColor *)navBarLeftHTextColor {
    return [UIColor colorWithHex:0x888888 alpha:0.4];
}
+ (UIColor *)navBarRightHTextColor {
    return [UIColor colorWithHex:0x888888 alpha:0.4];
}
- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc] init];
        {
            ZRSWHomeController *vc = [[ZRSWHomeController alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [_controllers addObject:nav];
        }
        {
            ZRSWLoansController *vc = [[ZRSWLoansController alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [_controllers addObject:nav];
        }
        {
            ZRSWMineController *vc = [[ZRSWMineController alloc] init];
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
            [_controllers addObject:nav];
        }
    }
    return _controllers;
}

- (NSMutableArray *)tabBarItemsAttributes {
    if (!_tabBarItemsAttributes) {
        _tabBarItemsAttributes = [[NSMutableArray alloc] init];
        {
            NSMutableDictionary *infoDic = [BaseTheme infoDicWithTitle:@"首页" normalImage:@"currency_bottom_home_default" selectedImage:@"currency_bottom_home_select"];
            [_tabBarItemsAttributes addObject:infoDic];
        }
        {
            NSMutableDictionary *infoDic = [BaseTheme infoDicWithTitle:@"我要贷款" normalImage:@"currency_bottom_loan_default" selectedImage:@"currency_bottom_loan_select"];
            [_tabBarItemsAttributes addObject:infoDic];
        }
        {
            NSMutableDictionary *infoDic = [BaseTheme infoDicWithTitle:@"我的" normalImage:@"currency_bottom_my_default" selectedImage:@"currency_bottom_my_select"];
            [_tabBarItemsAttributes addObject:infoDic];
        }
    }
    
    return _tabBarItemsAttributes;
}
+ (NSMutableDictionary *)infoDicWithTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:title forKey:CYLTabBarItemTitle];
    [dic setObject:[[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:CYLTabBarItemImage];
    [dic setObject:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:CYLTabBarItemSelectedImage];
    return dic;
}

+ (CYLTabBarController *)tabBarController {
    return [[self sharedInstance] tabBarController];
}
- (CYLTabBarController *)tabBarController {
    CYLTabBarController *tabBar = [[CYLTabBarController alloc] initWithViewControllers:self.controllers tabBarItemsAttributes:self.tabBarItemsAttributes];
    UIImage *backImage = [UIImage imageNamed:@""];
    backImage = [backImage stretchableImageWithLeftCapWidth:backImage.size.width * 0.5 topCapHeight:backImage.size.height * 0.5];
    [tabBar.tabBar setBackgroundImage:backImage];
    return tabBar;
}

@end
