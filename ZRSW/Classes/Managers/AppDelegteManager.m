//
//  AppDelegteManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "AppDelegteManager.h"

@implementation AppDelegteManager

SYNTHESIZE_SINGLETON_ARC(AppDelegteManager);

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 键盘管理
    [self keyboardManager];
    // 百度统计
    [self baiduMobStat];
    // 定位信息
    [self loactionManager];
    // 网络
    [self setupNetWorkConfig];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}




#pragma mark -  manager

- (void)keyboardManager {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
- (void)baiduMobStat {
    
#ifdef NeedBaiduMobStat
    [[BaiduMobStat defaultStat] startWithAppId:BaiduMobStatKey];
#else
    
#endif
    
}
- (void)loactionManager {
    
#ifdef NeedLocationManager
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
    }
    [[LocationManager sharedInstance] setUpLocationManager];
#else
    
#endif
}
- (void)setupNetWorkConfig {
    [BaseNetWorkService configNetWorkService];
}
@end
