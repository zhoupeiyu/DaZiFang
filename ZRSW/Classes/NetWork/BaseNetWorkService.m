//
//  BaseNetWorkService.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseNetWorkService.h"

static NSString *const UserIDKey = @"UserIDKey";
static NSString *const UserLoginTokenKey = @"UserLoginTokenKey";

@implementation BaseNetWorkService

SYNTHESIZE_SINGLETON_ARC(BaseNetWorkService);

- (void)setUserID:(NSString *)userID {
    if (![_userID isEqualToString:userID]) {
        _userID = userID;
        [[NSUserDefaults standardUserDefaults] setValue:userID forKey:UserIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
+ (NSString *)getUserID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:UserIDKey];
}

- (void)setLoginToken:(NSString *)loginToken {
    if (![_loginToken isEqualToString:loginToken]) {
        _loginToken = loginToken;
        [[NSUserDefaults standardUserDefaults] setValue:loginToken forKey:UserLoginTokenKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *)getLoginToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:UserLoginTokenKey];
}
+ (void)removeUserToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserLoginTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)isReachable {
   Reachability *reach = [Reachability reachabilityForInternetConnection];
    return [reach isReachable];
}

+ (NSMutableDictionary *)netWorkHeader {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    NSString *auth = @{
                       @"imei":@"",
                       @"os" : @"iOS",
                       @"os_version" : [[UIDevice currentDevice] systemVersion],
                       @"app_version" : [UIApplication sharedApplication].appVersion,
                       @"time_stamp" : [NSDate getScond],
                       @"token" : [self getLoginToken],
                       @"user_id" : [self getUserID]
                       }.yy_modelToJSONString;

    [header setObject:auth forKey:@"auth"];
    return header;
}
+ (void)configNetWorkService {
    [HYBNetworking updateBaseUrl:API_Host];
//    [HYBNetworking configRequestType:kHYBRequestTypeJSON responseType:kHYBResponseTypeJSON shouldAutoEncodeUrl:NO callbackOnCancelRequest:YES];
}
- (void)GET:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache {
    WS(weakSelf);
    [HYBNetworking configCommonHttpHeaders:[BaseNetWorkService netWorkHeader]];
    [HYBNetworking getWithUrl:interface refreshCache:needCache params:dic progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
    } success:^(id response) {
        [self logInterfaceInfo:response url:interface params:dic error:nil];
        [weakSelf successBlock:response delegate:delegate ObjcClass:objecClass reqType:type];
        
    } fail:^(NSError *error) {
        [self logInterfaceInfo:nil url:interface params:dic error:error];
        [weakSelf failBlock:error delegate:delegate reqType:type];
    }];
}

- (void)POST:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache {
    WS(weakSelf);
    [HYBNetworking configCommonHttpHeaders:[BaseNetWorkService netWorkHeader]];
    [HYBNetworking postWithUrl:interface refreshCache:needCache params:dic progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
    } success:^(id response) {
        [self logInterfaceInfo:response url:interface params:dic error:nil];
        [weakSelf successBlock:response delegate:delegate ObjcClass:objecClass reqType:type];
    } fail:^(NSError *error) {
        [self logInterfaceInfo:nil url:interface params:dic error:error];
        [weakSelf failBlock:error delegate:delegate reqType:type];
    }];
}

- (void)successBlock:(id)response delegate:(id<BaseNetWorkServiceDelegate>)delegate ObjcClass:(Class)objecClass reqType:(NSString *)type{
    [self checkServerStatus:response ObjcClass:objecClass];
    if ([response isKindOfClass:[NSDictionary class]]) {
        if (response) {
            BaseModel *baseModel = [[objecClass class] yy_modelWithJSON:response];
            if ([delegate respondsToSelector:@selector(requestFinishedWithStatus:resObj:reqType:)]) {
                [delegate requestFinishedWithStatus:RequestFinishedStatusSuccess resObj:baseModel reqType:type];
            }
        }
        else {
            
            if ([delegate respondsToSelector:@selector(requestFinishedWithStatus:resObj:reqType:)]) {
                [delegate requestFinishedWithStatus:RequestFinishedStatusSuccess resObj:response reqType:type];
            }
        }
    }
    else {
        if ([delegate respondsToSelector:@selector(requestFinishedWithStatus:resObj:reqType:)]) {
            [delegate requestFinishedWithStatus:RequestFinishedStatusSuccess resObj:response reqType:type];
        }
    }
}
- (void)failBlock:(NSError *)error delegate:(id<BaseNetWorkServiceDelegate>)delegate reqType:(NSString *)type{
    if ([delegate respondsToSelector:@selector(requestFinishedWithStatus:resObj:reqType:)]) {
        [delegate requestFinishedWithStatus:RequestFinishedStatusFail resObj:nil reqType:type];
    }
}
- (void)checkServerStatus:(id)response ObjcClass:(Class)objecClass {
    if ([response isKindOfClass:[NSDictionary class]]) {
        BaseModel *baseModel = [[objecClass class] yy_modelWithJSON:response];
        NSInteger error_code = baseModel.error_code.integerValue;
        // 1000 用户未登陆或登陆已失效 9101 token无效，请使用帐密登陆 9102 token登陆过期，请重新登陆！
        if (error_code == 1000 || error_code == 9101 || error_code == 9102) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginErrorNotification object:[NSDictionary dictionaryWithObjectsAndKeys:baseModel.error_msg,@"error_msg", nil]];
        }
    }
}
- (void)logInterfaceInfo:(id)resObj url:(NSString *)url params:(id)params  error:(NSError *)err{
    DLog(@"\n\n******************* request log *******************\n\nurl: %@\n\nparameters: %@\n\nresponseObject: %@\n\n\nerror: %@\n******************* request end *******************\n\n\n", url, params, resObj, err);
}
@end
