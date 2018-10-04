//
//  ZRSWLinePrejudicationController.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseScrollViewController.h"
#import "ZRSWOrderModel.h"


@interface ZRSWLinePrejudicationController : BaseScrollViewController

// 贷款条件
@property (nonatomic, strong) NSArray <ZRSWOrderLoanInfoCondition *>*loanCondition;
// 贷款产品
@property (nonatomic, strong) NSString *loanId;

@end
