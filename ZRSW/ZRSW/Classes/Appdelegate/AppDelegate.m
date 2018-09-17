//
//  AppDelegate.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/16.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AppDelegteManager sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [self setupTabBar];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[AppDelegteManager sharedInstance] applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   [[AppDelegteManager sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[AppDelegteManager sharedInstance] applicationWillEnterForeground:application];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AppDelegteManager sharedInstance] applicationDidBecomeActive:application];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[AppDelegteManager sharedInstance] applicationWillTerminate:application];

}
- (void)setupTabBar {
    UITabBarController *rvc = [BaseTheme tabBarController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [BaseTheme baseViewColor];
    [self.window setRootViewController:rvc];
    [self.window makeKeyAndVisible];
}

@end
