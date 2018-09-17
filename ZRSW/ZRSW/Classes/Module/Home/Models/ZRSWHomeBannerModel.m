//
//  ZRSWHomeBannerModel.m
//  ZRSW
//
//  Created by King on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWHomeBannerModel.h"
@implementation HomeBannerModelDetails

@end

@implementation ZRSWHomeBannerModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [HomeBannerModelDetails class],
             };
}
@end
