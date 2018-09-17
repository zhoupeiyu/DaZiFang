//
//  ZRSWRegisterController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRegisterController.h"

@interface ZRSWRegisterController ()

@end

@implementation ZRSWRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"注册";
    [self setLeftBackBarButton];
    [self setRightBarButtonWithText:@"登录"];
    [self.rightBarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    [super setupUI];
    
}

@end
