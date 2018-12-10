//
//  VersionManager.h
//  ZRSW
//
//  Created by 周培玉 on 2018/11/23.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KVersionJudge [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByAppendingString:@"Judge"]

#define Kjudge @"judge"

#define itunes_app_id @"1441755828"

@interface VersionManager : NSObject

+ (VersionManager *)sharedInstance;

//从网络获取最新版本
+ (void)updateVersionInfo;

//显示版本更新提示框
+ (void)showUpdateAlerts;

//跳转到App Store评分
+ (void)openSelfInAppStore;

//获取当前版本
+ (NSString *)currentVersion;

//errerCode=800 显示强制更新提示框
+ (void)showForceUpdateAlertByErrorCode;

@end


@class VersionModel;

@interface UpdateVersionModel : BaseModel

@property (nonatomic, strong) VersionModel *data;
@end

@interface VersionModel : NSObject

@property (nonatomic, strong) NSNumber *status; // /*状态：0表示正常*/
@property (nonatomic, strong) NSString *app_version; //"3.0.0",/*版本号*/
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *app_url; // /*apk下载地址*/
@property (nonatomic, strong) NSString *app_content; // "云音3.0.0"
@property (nonatomic, strong) NSString *is_force; ///*是否强制更新 0不强制 1强制*/
@property (nonatomic, strong) NSString *add_time; // "2018-04-19 18:42:49",

@end
