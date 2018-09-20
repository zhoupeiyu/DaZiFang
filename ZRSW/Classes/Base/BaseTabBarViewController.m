//
//  BaseTabBarViewController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()
@property (nonatomic, assign) NSInteger lastSelectItemIndex;
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSInteger index = [tabBar.items indexOfObject:item];
    if (index != self.lastSelectItemIndex) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TabBarDidClickNotification object:@{TabBarDidClickNotificationKey : @(self.lastSelectItemIndex)} userInfo:nil];
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.lastSelectItemIndex forKey:TabBarDidClickNotificationKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.lastSelectItemIndex = index;
    
}
@end
