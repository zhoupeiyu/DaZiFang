//
//  ZRSWUserInfoController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWUserInfoController.h"
#import "ZRSWUserInfoCell.h"
#import "ZRSWUserInfoListModel.h"


@interface ZRSWUserInfoController ()
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation ZRSWUserInfoController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"基础消息";
    [self setRightBarButtonWithText:@"保存"];
    [self.rightBarButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    [super setupUI];
    
}
- (void)saveAction {
    LLog(@"保存");
}

#pragma mark - delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}
@end
