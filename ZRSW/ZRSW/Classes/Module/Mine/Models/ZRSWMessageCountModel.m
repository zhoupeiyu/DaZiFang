//
//  ZRSWMessageCountModel.m
//  ZRSW
//
//  Created by King on 2018/10/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWMessageCountModel.h"
@implementation CountModel

@end

@implementation ZRSWMessageCountModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [CountModel class],
             };
}
@end
