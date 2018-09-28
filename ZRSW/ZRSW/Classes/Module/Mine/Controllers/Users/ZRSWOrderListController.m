//
//  ZRSWOrderListController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWOrderListController.h"
#import "ZRSWOnlineCustomerServiceController.h"

@interface ZRSWOrderListController ()

@end

@implementation ZRSWOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"我的订单";
    [self setRightBarButtonWithText:@"客服"];
    [self.rightBarButton addTarget:self action:@selector(customerServiceAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)customerServiceAction {
    ZRSWOnlineCustomerServiceController *vc = [[ZRSWOnlineCustomerServiceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
