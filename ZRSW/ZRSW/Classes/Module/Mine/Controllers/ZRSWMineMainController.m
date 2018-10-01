//
//  ZRSWMineMainController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/30.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWMineMainController.h"
#import "ZRSWMineController.h"
#import "ZRSWLoginController.h"

@interface ZRSWMineMainController ()

@property (nonatomic, strong) ZRSWMineController *mineController;
@property (nonatomic, strong) ZRSWLoginController *loginController;
@property (nonatomic, strong) UIView *currentView;

@end

@implementation ZRSWMineMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (ZRSWMineController *)mineController {
    if (!_mineController) {
        _mineController = [[ZRSWMineController alloc] init];
    }
    return _mineController;
}
- (ZRSWLoginController *)loginController {
    if (!_loginController) {
        _loginController = [[ZRSWLoginController alloc] init];
    }
    return _loginController;
}
@end
