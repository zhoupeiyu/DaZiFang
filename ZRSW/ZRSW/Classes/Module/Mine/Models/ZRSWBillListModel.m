//
//  ZRSWBillListModel.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBillListModel.h"

@implementation ZRSWBillModel

@end

@implementation ZRSWBillListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWBillModel class],
             };
}
@end
