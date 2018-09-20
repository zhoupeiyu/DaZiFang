//
//  ZRSWNeedLoansController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWNeedLoansController.h"

@interface ZRSWNeedLoansController ()

@end

@implementation ZRSWNeedLoansController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    
}

- (void)setupUI {
    [super setupUI];
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"我要贷款";
    [self setLeftBackBarButton];
    
}

- (void)setupLayOut {
    [super setupLayOut];
}
- (void)goBack {
    NSUInteger lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TabBarDidClickNotificationKey];
    [self.tabBarController setSelectedIndex:lastIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
