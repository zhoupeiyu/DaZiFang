//
//  ZRSWOrderListDetailController.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/29.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "BaseTableViewController.h"

typedef enum : NSUInteger {
    OrderTypeAll, // 全部
    OrderTypeUnderReview, // 审核中
    OrderTypePass, // 已通过
    OrderTypeCredit,// 已放款
    OrderTypeRefuse // 已完成
} OrderType;
NS_ASSUME_NONNULL_BEGIN

@interface ZRSWOrderListDetailController : BaseTableViewController

@property (nonatomic, assign) OrderType tabType;

@end

NS_ASSUME_NONNULL_END
