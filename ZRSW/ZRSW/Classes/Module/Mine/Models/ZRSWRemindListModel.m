//
//  ZRSWRemindListModel.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRemindListModel.h"

@implementation ZRSWRemindModel

@end

@implementation ZRSWRemindListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWRemindModel class],
             };
}
@end
