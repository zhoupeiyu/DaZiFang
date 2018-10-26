//
//  UserFaceDetectModel.m
//  ZRSW
//
//  Created by King on 2018/10/22.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "UserFaceDetectModel.h"
@implementation FaceTokenModel

@end

@implementation UserFaceDetectModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [FaceTokenModel class],
             };
}
@end
