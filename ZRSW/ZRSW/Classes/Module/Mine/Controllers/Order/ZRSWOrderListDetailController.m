//
//  ZRSWOrderListDetailController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/29.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWOrderListDetailController.h"
#import "OrderService.h"
#import "ZRSWOrderModel.h"
#import "ZRSWOrderListCell.h"

@interface ZRSWOrderListDetailController ()
@property (nonatomic, strong) OrderService *service;
@property (nonatomic, strong) NSString *lastID;
@property (nonatomic, strong) NSMutableArray *totalList;

@end

@implementation ZRSWOrderListDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}
- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    [self setupTableView];
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
}
- (void)setupTableView {
    [self enableLoadMore:YES];
    [self enableRefreshHeader:YES];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)refreshData {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        self.lastID = @"";
        if (self.tabType == 0) {
            [self.service getOrderList:self.lastID orderStatus:[self getOrderStates] delegate:self];
        }
        else {
            [self.service getOrderList:self.lastID orderStatus:[self getOrderStates] delegate:self];
        }
        [self hiddenFooter:YES];
    }
    
}
- (NSString *)getOrderStates {
//    订单状态：0=审核中；1=已通过；3=已放款；8=已拒绝（包含初审未过和拒绝放款）;默认为空，查询所有订单
    NSString *states = @"";
    if (self.tabType == 0) {
        states = @"";
    }
    else if (self.tabType == 1) {
        states = @"0";
    }
    else if (self.tabType == 2) {
        states = @"1";
    }
    else if (self.tabType == 3) {
        states = @"3";
    }
    else if (self.tabType == 4) {
        states = @"8";
    }
    return states;
}
- (void)loadMoreData {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        ZRSWOrderListDetailModel *detailModel = self.totalList.lastObject;
        if (self.tabType == 0) {
            [self.service getOrderList:detailModel.id orderStatus:[self getOrderStates] delegate:self];
        }
        else {
            [self.service getOrderList:detailModel.id orderStatus:[self getOrderStates] delegate:self];
        }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWOrderListCell *cell = [ZRSWOrderListCell getCellWithTableView:tableView];
    ZRSWOrderListDetailModel *detailModel = self.totalList[indexPath.section];
    [cell setListModel:detailModel];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.totalList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = self.view.backgroundColor;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 9);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZRSWOrderListCell cellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetOrderListRequest]) {
            ZRSWOrderListModel *listModel = (ZRSWOrderListModel *)resObj;
            if (listModel.error_code.integerValue == 0) {
                if (self.lastID.length == 0) {
                    [self.totalList removeAllObjects];
                    [self.totalList addObjectsFromArray:listModel.data];
                    self.tableView.mj_footer.hidden = NO;
                }
                else {
                    [self.totalList addObjectsFromArray:listModel.data];
                }
                // 每页20
                self.tableView.mj_footer.hidden = listModel.data.count < 15;
                if (self.totalList.count == 0) {
                    [self hiddenFooter:YES];
                    [self hiddenHeader:YES];
                }
                [self.tableView reloadData];
            }
            else {
                [TipViewManager showToastMessage:listModel.error_msg];
            }
        }
    }
    else {
        [TipViewManager showToastMessage:@"请求失败,请稍后重试！"];
    }
}
- (OrderService *)service {
    if (!_service) {
        _service = [[OrderService alloc] init];
    }
    return _service;
}
- (NSMutableArray *)totalList {
    if (!_totalList) {
        _totalList = [[NSMutableArray alloc] init];
    }
    return _totalList;
}
@end
