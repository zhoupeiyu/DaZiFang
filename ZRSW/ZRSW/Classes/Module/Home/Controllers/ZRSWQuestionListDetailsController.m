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
@interface ZRSWQuestionListDetailsController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@end

@implementation ZRSWQuestionListDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - NetWork
- (void)requsetCommentQuestionList{
    [[[UserService alloc] init] getCommentQuestionList:nil delegate:self];
}

- (void)refreshData{
    [self.dataListSource removeAllObjects];
    [[[UserService alloc] init] getCommentQuestionList:nil delegate:self];
}

- (void)loadMoreData{
    CommentQuestionModel *questionModel = self.dataListSource.lastObject;
    [[[UserService alloc] init] getCommentQuestionList:questionModel.id delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetCommentQuestionListRequest]) {
            CommentQuestionListModel *model = (CommentQuestionListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    CommentQuestionModel *detailModel = model.data[i];
                    [self.dataListSource addObject:detailModel];
                    [self.tableView reloadData];
                }
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
