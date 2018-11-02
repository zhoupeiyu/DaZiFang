//
//  ZRSWShareManager.h
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRSWShareModel.h"
typedef NS_ENUM(NSUInteger, ShareSourceType) {
    ShareSourceMessage,//网页文本
    ShareSourceWap,//网页分享
    ShareSourceImage // 分享图片
};

@protocol ShareHandlerDelegate <NSObject>
//分享成功
- (void)shareHandlerSuccess:(id)data;
//分享失败
- (void)shareHandlerFailed:(NSError *)error;

@end

@interface ZRSWShareManager : NSObject

/**
 分享内容

 @param platformType 分享平台
 @param shareModel 分享内容
 */
+ (void)shareToPlatformType:(UMSocialPlatformType)platformType Content:(ZRSWShareModel *)shareModel shareSourceType:(ShareSourceType)sourcetype delegate:(id<ShareHandlerDelegate>)delegate;

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation;

+ (NSString *)getClientParameters;

+ (void)registerPlaformInfo;

+ (BOOL)isInstallQQ;
+ (BOOL)isInstallWeChat;
+ (BOOL)isImstallWeiBo;

@end
