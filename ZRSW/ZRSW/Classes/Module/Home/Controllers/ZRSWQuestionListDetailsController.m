//
//  ZRSWQuestionListDetailsController.m
//  ZRSW
//
//  Created by King on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWQuestionListDetailsController.h"
#import "ZRSWHomeQuestionCell.h"
#import "UserService.h"
#import "ZRSWNewAndQuestionDetailsController.h"
#define  kPageSize 20
@interface ZRSWQuestionListDetailsController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@property (nonatomic, strong) NSString *lastId;
@end

@implementation ZRSWQuestionListDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
    [self requsetCommentQuestionList];
}


- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.navigationItem.title = @"常见问题";
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
    ZRSWHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeQuestionCell"];
    if (!cell) {
        cell = [[ZRSWHomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeQuestionCell"];
    }
    CommentQuestionModel *model = self.dataListSource[indexPath.row];
    cell.questionModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(120);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
    detailsVC.type = DetailsTypeCommentQuestion;
    detailsVC.questionModel = self.dataListSource[indexPath.row];
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - NetWork
- (void)requsetCommentQuestionList{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getCommentQuestionList:nil pageSize:kPageSize delegate:self];
}

- (void)refreshData{
    [TipViewManager showLoading];
    [self.tableView.mj_footer resetNoMoreData];
    [self.dataListSource removeAllObjects];
    self.lastId = nil;
    [[[UserService alloc] init] getCommentQuestionList:nil pageSize:kPageSize delegate:self];
}

- (void)loadMoreData{
    [TipViewManager showLoading];
    CommentQuestionModel *questionModel = self.dataListSource.lastObject;
    self.lastId = questionModel.id;
    [[[UserService alloc] init] getCommentQuestionList:self.lastId pageSize:kPageSize delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetCommentQuestionListRequest]) {
            CommentQuestionListModel *model = (CommentQuestionListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [self.dataListSource addObjectsFromArray:model.data];
                if (model.data.count < kPageSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }
    }else{
        LLog(@"请求失败");
    }
    if(self.dataListSource.count == 0){
        [self hiddenFooter:YES];
    }else{
        [self hiddenFooter:NO];
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
