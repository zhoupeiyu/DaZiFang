//
//  ZRSWNewsListDetailsController.m
//  ZRSW
//
//  Created by King on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWNewsListDetailsController.h"
#import "ZRSWHomeNewsCell.h"
#import "ZRSWNewAndQuestionDetailsController.h"
@interface ZRSWNewsListDetailsController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation ZRSWNewsListDetailsController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    if (self.type == NewListTypePopularInformation) {
        self.navigationItem.title = @"热门资讯";
    }else if (self.type == NewListTypePopularInformation){
        self.navigationItem.title = @"系统公告";
    }
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self enableRefreshHeader:YES];
    [self enableLoadMore:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == NewListTypePopularInformation) {
        [self requsetPopularInformationList];
    }else if (self.type == NewListTypeSystemNotification){
        [self requsetSystemNotificationList];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRSWHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeNewsCell"];
    if (!cell) {
        cell = [[ZRSWHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeNewsCell"];
    }
    NewDetailModel *model = self.dataListSource[indexPath.row];
    cell.detailModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(120);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LLog(@"热门资讯详情");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
    if (self.type == NewListTypePopularInformation) {
        detailsVC.type = DetailsTypePopularInformation;
    }else if (self.type == NewListTypePopularInformation){
        detailsVC.type = DetailsTypeSystemNotification;
    }
    detailsVC.detailModel = self.dataListSource[indexPath.row];
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - NetWork
- (void)requsetPopularInformationList{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil pageSize:20 delegate:self];
}
- (void)requsetSystemNotificationList{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:nil pageSize:20 delegate:self];
}

- (void)refreshData{
    [TipViewManager showLoading];
    [self.tableView.mj_footer resetNoMoreData];
    [self.dataListSource removeAllObjects];
    self.lastId = nil;
    if (self.type == NewListTypePopularInformation) {
        [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil pageSize:20 delegate:self];
    }else if (self.type == NewListTypeSystemNotification){
        [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:nil pageSize:20 delegate:self];
    }
}


- (void)loadMoreData{
    [TipViewManager showLoading];
    NewDetailModel *detailModel = self.dataListSource.lastObject;
    self.lastId = detailModel.id;
    if (self.type == NewListTypePopularInformation) {
        [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:self.lastId  pageSize:100 delegate:self];
    }else if (self.type == NewListTypeSystemNotification){
        [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:self.lastId  pageSize:100 delegate:self];
    }
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetNewsListPopInfoRequest]) {
            NewListModel *model = (NewListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    NewDetailModel *detailModel = model.data[i];
                    if ([detailModel.id isEqualToString:self.lastId]) {
                        if (self.dataListSource.count != 0) {
                            [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        return;
                    }
                    [self.dataListSource addObject:detailModel];
                }
                 [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }else if ([reqType isEqualToString:KGetNewsListSysNotiRequest]) {
            NewListModel *model = (NewListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    NewDetailModel *detailModel = model.data[i];
                    if ([detailModel.id isEqualToString:self.lastId]) {
                        if (self.dataListSource.count != 0) {
                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        return;
                    }
                    [self.dataListSource addObject:detailModel];
                }
                [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
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
