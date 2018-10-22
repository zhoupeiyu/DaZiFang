//
//  UserAddFaceModel.m
//  ZRSW
//
//  Created by King on 2018/10/22.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "UserAddFaceModel.h"

@implementation AddFaceModel

@end

@implementation UserAddFaceModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [AddFaceModel class],
             };
}
@end
