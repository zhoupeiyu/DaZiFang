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

+ (NSDictionary *)netWorkHeader {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    NSMutableDictionary *auth = [NSMutableDictionary dictionary];
    [auth setObject:@"" forKey:@"imei"];
    [auth setObject:@"iOS" forKey:@"os"];
    [auth setObject:[[UIDevice currentDevice] systemVersion] forKey:@"os_version"];
    [auth setObject:[UIApplication sharedApplication].appVersion forKey:@"app_version"];
    [auth setObject:[NSDate getTimeSecond] forKey:@"time_stamp"];
    [auth setObject:[self getLoginToken] forKey:@"token"];
    [auth setObject:[self getUserID] forKey:@"user_id"];
    [header setObject:auth forKey:@"auth"];
    return header;
}
+ (void)configNetWorkService {
    [HYBNetworking updateBaseUrl:API_Host];
    [HYBNetworking configRequestType:kHYBRequestTypeJSON responseType:kHYBResponseTypeJSON shouldAutoEncodeUrl:NO callbackOnCancelRequest:YES];
    [HYBNetworking configCommonHttpHeaders:[self netWorkHeader]];
}
-(void)GET:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache {
    WS(weakSelf);
    [HYBNetworking getWithUrl:interface refreshCache:needCache params:dic progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        
    } success:^(id response) {
        [self logInterfaceInfo:response url:interface params:dic error:nil];
        [weakSelf successBlock:response delegate:delegate ObjcClass:objecClass reqType:type];
        
    } fail:^(NSError *error) {
        [self logInterfaceInfo:nil url:interface params:dic error:error];
        [weakSelf failBlock:error delegate:delegate reqType:type];
    }];
}

-(void)POST:(NSString *)interface reqType:(NSString *)type delegate:(id<BaseNetWorkServiceDelegate>) delegate parameters:(NSMutableDictionary *)dic ObjcClass:(Class)objecClass NeedCache:(BOOL)needCache {
    WS(weakSelf);
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
- (void)logInterfaceInfo:(id)resObj url:(NSString *)url params:(id)params  error:(NSError *)err{
    DLog(@"\n\n******************* request log *******************\n\nurl: %@\n\nparameters: %@\n\nresponseObject: %@\n\n\nerror: %@\n******************* request end *******************\n\n\n", url, params, resObj, err);
}
@end
