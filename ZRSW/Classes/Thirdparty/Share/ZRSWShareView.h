//
//  ZRSWShareView.h
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRSWShareManager.h"
@interface ZRSWShareView : NSObject
// 第三方登录用的原生 分享用的友盟 回调有冲突
@property (nonatomic, assign) BOOL isShareCallBack;

+ (ZRSWShareView *)sharedInstance;
+ (void)shareApp:(id<ShareHandlerDelegate>)delegate;
+ (void)shareImage:(UIImage *)shareImage delegate:(id<ShareHandlerDelegate>)delegate;
+ (void)shareImageURL:(NSString *)shareImageUrl delegate:(id<ShareHandlerDelegate>)delegate;
+ (void)shareContent:(ZRSWShareModel *)content shareSourceType:(ShareSourceType)type delegate:(id<ShareHandlerDelegate>)delegate;
+ (void)dismissShareView;

@end
