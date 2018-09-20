//
//  ZRSWLoansController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoansController.h"
#import "ZRSWNeedLoansController.h"

@interface ZRSWLoansController ()

@end

@implementation ZRSWLoansController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ZRSWNeedLoansController *needLoans = [[ZRSWNeedLoansController alloc] init];
    needLoans.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:needLoans animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"我要贷款";
}


@end
