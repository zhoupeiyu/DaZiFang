//
//  ZRSWLoginController.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseScrollViewController.h"

typedef enum : NSUInteger {
    LoginVCTypeNormal, // 正常
    LoginVCTypeMine
} LoginVCType;
@interface ZRSWLoginController : BaseScrollViewController

+ (ZRSWLoginController *)getLoginViewController:(LoginVCType)type;

@end
