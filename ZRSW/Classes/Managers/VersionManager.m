//
//  VersionManager.m
//  ZRSW
//
//  Created by 周培玉 on 2018/11/23.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "VersionManager.h"
#import "AppDelegate.h"
#import "UIAlertController+Extension.h"
#import "UserService.h"

typedef void(^CompleteBlock)(NSError *error, NSDictionary *result);

#define APP_GET_URL @"https://itunes.apple.com/cn/app/id"
#define APP_GET_COMMENT_URL @"https://itunes.apple.com/app/id"

NSString * const kAppVersionManagerVersionKey = @"AppVersionManagerVersionKey";
NSString * const kAppVersionManagerForceUpdateKey = @"AppVersionManagerForceUpdateKey";

@interface VersionManager ()<UIAlertViewDelegate,BaseNetWorkServiceDelegate>

@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *latestVersion;
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, assign) BOOL isShowingAlert;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL serverForceUpdate;
@property (nonatomic, strong) VersionModel *versionModel;

@end
@implementation VersionManager

SYNTHESIZE_SINGLETON_ARC(VersionManager);

+ (void)updateVersionInfo {
    [[self sharedInstance] updateVersionInfo];
}

+ (void)showUpdateAlerts {
    [[self sharedInstance] showUpdateAlerts];
}

+ (void)openSelfInAppStore {
    NSString *urlStr = [self appStoreURLString];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

+ (NSString *)currentVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)appStoreURLString {
    NSString *appID = [[self sharedInstance] appID];
    if (appID.length > 0) {
        NSString *baseURLStr = APP_GET_COMMENT_URL;
        return [baseURLStr stringByAppendingString:appID];
    }
    return nil;
}

+ (void)showForceUpdateAlertByErrorCode
{
    [[self sharedInstance] showForceUpdateAlertByErrorCode];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadInfo];
        self.appID = itunes_app_id;
    }
    return self;
}

- (void)loadInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [[self class] currentVersion];
    _latestVersion = [defaults objectForKey:kAppVersionManagerVersionKey];
    if (_latestVersion.length == 0) {
        _latestVersion = currentVersion;
    }
    _forceUpdate = [defaults boolForKey:kAppVersionManagerForceUpdateKey];
    _isShowingAlert = NO;
}

- (void)updateVersionInfo { // 发送网络请求
    [[[UserService alloc] init] getAppVersionInfoDelegate:self];
}
#pragma mark - 网络相关

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetAppVersionInfoRequest]) {
            UpdateVersionModel *model = (UpdateVersionModel *)resObj;
            if (model.error_code.integerValue != 0) return;
            VersionModel *versionModel = model.data;
            if (!versionModel || versionModel.app_version.length == 0) return;
            BOOL forceUpdate = NO;
            NSString *currentVersion = [[self class] currentVersion];
            if ([currentVersion compare:versionModel.app_version] == NSOrderedAscending) {
                forceUpdate = YES;
            }else {
                forceUpdate = NO;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@(!forceUpdate) forKey:@"cancleUpdate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.forceUpdate = forceUpdate;
            self.latestVersion = versionModel.app_version;
            self.content = versionModel.app_content;
            self.serverForceUpdate = versionModel.is_force.boolValue;
            //    ;
            self.versionModel = versionModel;
            [self saveInfo];
            [self showUpdateAlerts];
        }
    }
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.isShowingAlert = NO;
    if (buttonIndex == 1) { // 立即更新
        [[self class] openSelfInAppStore];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"cancleUpdate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
- (void)exitApplication {
    exit(0);
}


- (void)showUpdateAlerts {
    if (self.isShowingAlert) {
        return;
    }
    if (![self hasNewVersion]) {
        return;
    }
    BOOL isCancel = ((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"cancleUpdate"]).boolValue;
    if (isCancel) {
        return;
    }
    if (self.forceUpdate) {
        NSString *currentVersion = [[self class] currentVersion];
        NSString *title = [NSString stringWithFormat:@"发现新版本"];
        
        self.isShowingAlert = YES;
        UIAlertController *vc = [self showAlertTitle:title withMessage:self.content cancelTitle:@"取消" confirmTitle:@"立即更新"];
        vc.messageLabel.textAlignment = NSTextAlignmentLeft;
        UIViewController *presentVC = [UIViewController currentViewController];
        [presentVC presentViewController:vc animated:YES completion:nil];
    }
}

- (void)showForceUpdateAlertByErrorCode
{
    if (self.isShowingAlert) {
        return;
    }
    
    NSString *currentVersion = [[self class] currentVersion];
    NSString *title = @"有新版本";
    NSString *content = self.content;
    
    self.isShowingAlert = YES;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                 message:content
                                                delegate:self
                                       cancelButtonTitle:@"去更新"
                                       otherButtonTitles: nil];
    av.tag = 1;
    [av show];
}

- (BOOL)hasNewVersion {
    NSString *currentVersion= [[self class] currentVersion];
    return [self.latestVersion compare:currentVersion] == NSOrderedDescending;
}

- (void)saveInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.latestVersion forKey:kAppVersionManagerVersionKey];
    [defaults setBool:self.forceUpdate forKey:kAppVersionManagerForceUpdateKey];
}

- (void)getAppVersionInfoComplate:(CompleteBlock)result {
    
}

- (UIAlertController *)showAlertTitle:(NSString *)title withMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self alertView:nil clickedButtonAtIndex:1];
        }
    }];
    [alertController addAction:okAction];
    
    
    if (!_serverForceUpdate) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if ([self respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
                [self alertView:nil clickedButtonAtIndex:0];
            }
        }];
        [alertController addAction:cancelAction];
    }
    return alertController;
}


@end

@implementation UpdateVersionModel

@end

@implementation VersionModel

@end
