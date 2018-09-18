//
//  LocationManager.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<BMKLocationAuthDelegate,BMKLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;
@end
@implementation LocationManager

SYNTHESIZE_SINGLETON_ARC(LocationManager);

- (void)setUpLocationManager {
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiDuLocationKey authDelegate:self];
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    if (iError == BMKLocationAuthErrorSuccess) {
        [self locationManager];
    }
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    return _locationManager;
}

- (void)getCityLocationSuccess:(void (^)(id result))success{
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if(error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        if(location) {//得到定位信息，添加annotation
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
                NSString *result = location.rgcData.city;
                if (!result) {
                    result = location.rgcData.province;
                    if (success) {
                        success(result);
                    }
                }
            }
        }
        NSLog(@"netstate = %d",state);
    }];
}

@end
