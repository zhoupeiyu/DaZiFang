//
//  ZRSWBillListController.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBillListController.h"
#import "ZRSWBillListCell.h"
#import "UserService.h"
#import "ZRSWRemindListController.h"
@interface ZRSWBillListController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@end

@implementation ZRSWBillListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self requsetRemindList];
    [self requsetBillList];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"my_remind"] AndHighLightImage:[UIImage imageNamed:@""]];
    [self.rightBarButton addTarget:self action:@selector(goToRemindListController) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"账单列表";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self enableRefreshHeader:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListSource.count+5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRSWBillListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWBillListCell"];
    if (!cell) {
        cell = [[ZRSWBillListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWBillListCell"];
    }
//    ZRSWBillModel *model = self.dataListSource[indexPath.row];
//    cell.billModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(160);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)goToRemindListController{
    ZRSWRemindListController *remindListVC = [[ZRSWRemindListController alloc] init];
    [self.navigationController pushViewController:remindListVC animated:YES];
}


#pragma mark - NetWork
- (void)requsetBillList{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getBillList:@"18600886745" password:@"123456" name:@"18511691940" delegate:self];
}

- (void)refreshData{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getRemindList:@"18600886745" password:@"123456" name:@"18511691940" delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetBillListRequest]) {
            ZRSWBillListModel *model = (ZRSWBillListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    ZRSWBillModel *billModel = model.data[i];
                    [self.dataListSource addObject:billModel];
                    [self.tableView reloadData];
                }
            }else{
                LLog(@"请求失败:%@",model.error_msg);
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }else{
        LLog(@"请求失败");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
