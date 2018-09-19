//
//  ZRSWMineController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWMineController.h"
#import "ZRSWLoginController.h"
#import "ZRSWMineListCell.h"
#import "ZRSWUserInfoController.h"

@interface ZRSWMineController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZRSWMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
    [self setupUI];
    [self setupData];
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"我的";
    [self setRightBarButtonWithImage:[UIImage imageNamed:@"currency_top_set"] AndHighLightImage:[UIImage imageNamed:@""]];
    [self.rightBarButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self setupLayOut];
}
- (void)setupLayOut {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}
#pragma mark - delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray *)self.dataSource[section]).count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.0001 : 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [BaseTheme baseViewColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWMineListCell *cell = [ZRSWMineListCell getCllWithTableView:tableView];
    cell.model = ((NSMutableArray *)self.dataSource[indexPath.section])[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWMineModel *mineModel = ((NSMutableArray *)self.dataSource[indexPath.section])[indexPath.row];
    return mineModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWMineModel *mineModel = ((NSMutableArray *)self.dataSource[indexPath.section])[indexPath.row];
    BaseViewController *vc = [(BaseViewController *)[NSClassFromString(mineModel.viewControllerName)
                                                     alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Action
- (void)settingAction {
    
}
#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [BaseTheme baseViewColor];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (void)setupData {
    {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
        model.title = @"小明";
        model.desInfo = @"QQ号:429038386";
        model.type = MineListTypeUserInfo;
        model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
        [data addObject:model];
        [self.dataSource addObject:data];
    }
    {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"我的订单";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_order";
            model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"还款提醒";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_remind";
            model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"实名认证";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_identity";
            model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"企业认证";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_enterprise";
            model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"更换手机号";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_phone";
            model.viewControllerName = NSStringFromClass([ZRSWUserInfoController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"登录";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_phone";
            model.viewControllerName = NSStringFromClass([ZRSWLoginController class]);
            [data addObject:model];
        }
        [self.dataSource addObject:data];
    }
    [self.tableView reloadData];
}

@end
