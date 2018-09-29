//
//  ZRSWRemindListController.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRemindListController.h"
#import "ZRSWRemindListCell.h"
#import "UserService.h"
#import "ZRSWNewAndQuestionDetailsController.h"
#define  kPageSize 20
@interface ZRSWRemindListController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@property (nonatomic, assign) int pageNum;
@end

@implementation ZRSWRemindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
    self.pageNum = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requsetRemindList];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"提醒列表";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self enableRefreshHeader:YES];
    [self enableLoadMore:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRSWRemindListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWRemindListCell"];
    if (!cell) {
        cell = [[ZRSWRemindListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWRemindListCell"];
    }
    ZRSWRemindModel *model = self.dataListSource[indexPath.row];
    cell.remindModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(155);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
    detailsVC.type = DetailsTypeCommentQuestion;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - NetWork
- (void)requsetRemindList{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getRemindList:kPageSize pageNum:self.pageNum delegate:self];
}

- (void)refreshData{
    self.pageNum = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [TipViewManager showLoading];
    [self requsetRemindList];
}

- (void)loadMoreData{
    [self requsetRemindList];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetRemindListRequest]) {
            ZRSWRemindListModel *model = (ZRSWRemindListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.dataListSource.count > 0 && self.pageNum == 1) {
                    [self.dataListSource removeAllObjects];
                }
                if (model.data.count > 0) {
                    self.pageNum++;
                }else{
                    if (self.dataListSource.count != 0) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    return;
                }
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    ZRSWRemindModel *remindModel = model.data[i];
                    [self.dataListSource addObject:remindModel];
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
