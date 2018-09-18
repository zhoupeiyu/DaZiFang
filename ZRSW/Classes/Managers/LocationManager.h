//
//  LocationManager.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

+ (LocationManager *)sharedInstance;

- (void)setUpLocationManager;

- (void)getCityLocationSuccess:(void (^)(id result))success;

@end
