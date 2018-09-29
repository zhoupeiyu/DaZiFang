//
//  ZRSWBillListModel.h
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"

@interface ZRSWBillModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *loanTitle;
@property (nonatomic, assign) int loanNumber;
@property (nonatomic, assign) int loanCycle;
@property (nonatomic, strong) NSString *loanMoney;
@property (nonatomic, strong) NSString *loanUserName;
@property (nonatomic, strong) NSString *loanUserPhone;
@property (nonatomic, strong) NSString *loanTime;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int *urgedTimes;
@end

@interface ZRSWBillListModel : BaseModel
@property (nonatomic, strong) NSArray *data;
@end
