//
//  AppDelegteManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "AppDelegteManager.h"
#import "ZRSWShareManager.h"
#import "DeviceID.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegteManager ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) NSString *pushURL;
@property (nonatomic, strong) NSDictionary *pushInfo;
@property (strong, nonatomic) CLLocationManager* locationManager;
@end
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
    //分享
    [self setupShareConfig];
    //推送
    [self setupJpushWithOptions:launchOptions];
    //环信
    [self setupEMClientConfig];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    //环信进入后台
     [[EMClient sharedClient] applicationDidEnterBackground:application];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    //环信进入前台
    [[EMClient sharedClient] applicationWillEnterForeground:application];
//    [self updateMessageCount];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:notification.applicationIconBadgeNumber];
    [JPUSHService setBadge:0];
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [self remoteNotificationWith:userInfo];
    LLog(@"---%@---",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self updateMessageCount];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self remoteNotificationWith:userInfo];
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [self updateMessageCount];
}

#pragma mark - JPUSHRegisterDelegate
// iOS 10 Support App在前台获取通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler NS_AVAILABLE_IOS(10_0) {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self updateMessageCount];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler NS_AVAILABLE_IOS(10_0) {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];

//         [[NSNotificationCenter defaultCenter] postNotificationName:NotifyReceiveNotification object:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [self remoteNotificationWith:userInfo];
}

- (void)remoteNotificationWith:(NSDictionary *)userInfo {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}

#pragma mark -
-(void)resetBageNumber{
    UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
    /*
     iOS 11后，直接设置badgeNumber不生效了。故先发一个静默push（即没有soundName和alert）。如果原来app的badge是0也无所谓。对于本地push0就是不操作。
     后面在applicationIconBadgeNumber = -1
     */
    clearEpisodeNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    clearEpisodeNotification.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
}


#pragma mark - event
- (void)addNotify {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginError:) name:UserLoginErrorNotification object:nil];
}

- (void)userLoginError:(NSNotification *)noti {
    
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
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    [[LocationManager sharedInstance] setUpLocationManager];
#else
    
#endif
}
- (void)setupNetWorkConfig {
    [BaseNetWorkService configNetWorkService];
}

//分享
- (void)setupShareConfig {
    [ZRSWShareManager registerPlaformInfo];
}

//推送
- (void)setupJpushWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCount) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [DeviceID idfaStr];
    if (advertisingId) {
        [[NSUserDefaults standardUserDefaults] setObject:advertisingId forKey:@"advertisingId"];
    }

    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:kJupushKey
                          channel:@"App Store"
                 apsForProduction:[isProductionJPush boolValue]
            advertisingIdentifier:advertisingId];
    //设置红色角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];

    UIApplication *application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

- (void)updateMessageCount{
     [[NSNotificationCenter defaultCenter] postNotificationName:UpdateMsgStatusNotification object:nil];
}

//环信
- (void)setupEMClientConfig {
    HDOptions *option = [[HDOptions alloc] init];
    option.appkey = kHuanXinAppKey; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = kHuanXinTenantId;// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
//    option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option];
    if (!initError) { // 初始化错误
        LLog(@"环信初始化成功");
    }
}

@end
