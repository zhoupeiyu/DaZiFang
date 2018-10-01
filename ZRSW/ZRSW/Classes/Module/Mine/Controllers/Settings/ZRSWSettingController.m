//
//  ZRSWSettingController.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWSettingController.h"
#import "ZRSWFeedBackController.h"
#import "ZRSWMineListCell.h"
@interface ZRSWSettingController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ZRSWSettingController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    [self setupData];
    [self setUpTableView];
}


- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.navigationItem.title = @"设置";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRSWMineListCell *cell = [ZRSWMineListCell getCllWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWMineModel *mineModel = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        return;
    }else if (indexPath.row == 3) {
        LLog(@"退出登录");
        [UserModel removeUserData];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        BaseViewController *vc = [(BaseViewController *)[NSClassFromString(mineModel.viewControllerName)
                                                         alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)setupData {
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"版本号";
            model.type = MineListTypeSetting;
            model.iconName = @"my_phone";
            model.desInfo = [NSString stringWithFormat:@"V%@",[[UIApplication sharedApplication] appVersion]];
            [self.dataSource addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"用户协议";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_order";
            [self.dataSource addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"意见反馈";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_order";
            model.viewControllerName = NSStringFromClass([ZRSWFeedBackController class]);
               [self.dataSource addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"退出登录";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_phone";
            model.bottomLineHidden = YES;
            [self.dataSource addObject:model];
        }
    [self.tableView reloadData];
}


@end
