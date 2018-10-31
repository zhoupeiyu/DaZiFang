//
//  ZRSWLoginController.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseScrollViewController.h"

typedef void(^CancelBlock)(void);

@interface ZRSWLoginController : BaseScrollViewController

@property (nonatomic, copy) CancelBlock cancelBlock;

+ (ZRSWLoginController *)getLoginViewController;

+ (void)showLoginViewController;



@end
