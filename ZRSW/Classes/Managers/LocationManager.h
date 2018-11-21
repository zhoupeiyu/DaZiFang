//
//  LocationManager.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocation.h>

@protocol LocationManagerDelegate <NSObject>
- (void)didChangeAuthorizationStatus;
@end

@interface LocationManager : NSObject

@property (nonatomic, weak) id<LocationManagerDelegate> delegate;

+ (LocationManager *)sharedInstance;

- (void)setUpLocationManager;
- (void)getCityLocationSuccess:(void (^)(id result,CLLocation *location))success failure:(void (^)(id error))failure;
@end
