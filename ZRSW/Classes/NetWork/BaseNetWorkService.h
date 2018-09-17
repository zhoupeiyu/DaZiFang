//
//  BaseNetWorkService.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RequestFinishedStatusSuccess = 0,
    RequestFinishedStatusFail = -1
} RequestFinishedStatus;

@protocol BaseNetWorkServiceDelegate <NSObject>

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType;

@end

@interface BaseNetWorkService : NSObject

@property (nonatomic, strong) NSString *loginToken;
@property (nonatomic, strong) NSString *userID;

+ (void)removeUserToken;

+ (BaseNetWorkService *)sharedInstance;

+ (BOOL)isReachable;

+ (void)configNetWorkService;

+ (NSDictionary *)netWorkHeader;

-(void)GET:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache;

-(void)POST:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache;


@end
