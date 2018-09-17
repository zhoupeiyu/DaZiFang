//
//  ZRSWMineController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWMineController.h"
#import "ZRSWLoginController.h"

@interface ZRSWMineController ()

@end

@implementation ZRSWMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"我的";
}

- (void)setupUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jumpLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)jumpLogin {
    ZRSWLoginController *login = [[ZRSWLoginController alloc] init];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
}
@end
