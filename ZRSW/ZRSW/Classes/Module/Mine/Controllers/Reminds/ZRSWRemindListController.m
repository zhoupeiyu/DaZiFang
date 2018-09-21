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

@interface ZRSWRemindListController ()<BaseNetWorkServiceDelegate>
@property (nonatomic, strong) NSMutableArray *dataListSource;
@end

@implementation ZRSWRemindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.dataListSource = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requsetRemindList];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"还款提醒";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self enableRefreshHeader:YES];
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
    [[[UserService alloc] init] getRemindList:@"" password:@"" name:@"" delegate:self];
}

- (void)refreshData{
    [TipViewManager showLoading];
   [[[UserService alloc] init] getRemindList:@"" password:@"" name:@"" delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
    [self endHeadRefreshing];
    [self endFootRefreshing];
    ZRSWRemindModel *remindModel1 = [[ZRSWRemindModel alloc] init];
    remindModel1.name = @"2018/09/28 11:25:27";
    remindModel1.username = @"中融温馨提醒：贷款人杨飞的企业经营贷贷款的到期还款日为2018/9/29，还款额为16778.09。如您已还款请忽略。请立即登陆中融手机APP，方便又快捷。【中融盛旺】";
    ZRSWRemindModel *remindModel2 = [[ZRSWRemindModel alloc] init];
    remindModel2.name = @"2018/09/28 11:25:27";
    remindModel2.username = @"中融温馨提醒：贷款人杨飞的企业经营贷贷款的到期还款日为2018/9/29，还款额为16778.09。如您已还款请忽略。请立即登陆中融手机APP，方便又快捷。【中融盛旺】";
    ZRSWRemindModel *remindModel3 = [[ZRSWRemindModel alloc] init];
    remindModel3.name = @"2018/09/28 11:25:27";
    remindModel3.username = @"中融温馨提醒：贷款人杨飞的企业经营贷贷款的到期还款日为2018/9/29，还款额为16778.09。如您已还款请忽略。请立即登陆中融手机APP，方便又快捷。【中融盛旺】";
    ZRSWRemindModel *remindModel4 = [[ZRSWRemindModel alloc] init];
    remindModel4.name = @"2018/09/28 11:25:27";
    remindModel4.username = @"中融温馨提醒：贷款人杨飞的企业经营贷贷款的到期还款日为2018/9/29，还款额为16778.09。如您已还款请忽略。请立即登陆中融手机APP，方便又快捷。【中融盛旺】";
    ZRSWRemindModel *remindModel5 = [[ZRSWRemindModel alloc] init];
    remindModel5.name = @"2018/09/28 11:25:27";
    remindModel5.username = @"中融温馨提醒：贷款人杨飞的企业经营贷贷款的到期还款日为2018/9/29，还款额为16778.09。如您已还款请忽略。请立即登陆中融手机APP，方便又快捷。【中融盛旺】";
    [self.dataListSource addObject:remindModel1];
    [self.dataListSource addObject:remindModel2];
    [self.dataListSource addObject:remindModel3];
    [self.dataListSource addObject:remindModel4];
    [self.dataListSource addObject:remindModel5];
    [self.tableView reloadData];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetRemindListRequest]) {
            ZRSWRemindListModel *model = (ZRSWRemindListModel *)resObj;
            if (model.error_code.integerValue == 0) {
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
