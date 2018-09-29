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
#import "ZRSWSettingController.h"
#import "ZRSWRealNameAuthController.h"
#import "ZRSWResetPhoneController.h"
#import "ZRSWEnterpriseAuthController.h"
#import "ZRSWBillListController.h"
#import "ZRSWRemindListController.h"
#import "UserService.h"
#import "ZRSWOrderListController.h"


@interface ZRSWMineController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZRSWMineController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateUserInfo];
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:UserLoginSuccessNotification object:nil];
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
    if ([mineModel.title isEqualToString:@"退出登录"]) {
        [UserModel removeUserData];
        [self updateUserInfo];
        return;
    }
    if (![UserModel hasLogin]) {
        ZRSWLoginController *login = [[ZRSWLoginController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    BaseViewController *vc = [(BaseViewController *)[NSClassFromString(mineModel.viewControllerName)
                                                     alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    if ([reqType isEqualToString:KUserLogOutRequest]) {
        [UserModel removeUserData];
        //设置LoginToke
        [[BaseNetWorkService sharedInstance] setLoginToken:nil];
        [self.tableView reloadData];
        
    }
}
#pragma mark - Action
- (void)settingAction {
    ZRSWSettingController *setting = [[ZRSWSettingController alloc] init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)updateUserInfo {
    UserModel *model = [UserModel getCurrentModel];
    ZRSWMineModel *mineModel = self.dataSource[0][0];
    if ([UserModel hasLogin] && model) {
        mineModel.iconName = model.data.headImgUrl.length > 0 ? model.data.headImgUrl : @"";
        mineModel.title = model.data.nickName > 0 ? model.data.nickName : DefaultNickName;
        mineModel.desInfo = model.data.myId.length > 0 ? [NSString stringWithFormat:@"掮客号:%@",model.data.myId] :@"";
        mineModel.hasLogin = YES;
    }
    else {
        mineModel.iconName = @"";
        mineModel.title = @"请登录";
        mineModel.desInfo = @"";
        mineModel.hasLogin = NO;
    }
    [self.tableView reloadData];
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
            model.viewControllerName = NSStringFromClass([ZRSWOrderListController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"还款提醒";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_remind";
            model.viewControllerName = NSStringFromClass([ZRSWBillListController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"实名认证";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_identity";
            model.viewControllerName = NSStringFromClass([ZRSWRealNameAuthController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"企业认证";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_enterprise";
            model.viewControllerName = NSStringFromClass([ZRSWEnterpriseAuthController class]);
            [data addObject:model];
        }
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"更换手机号";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_phone";
            model.viewControllerName = NSStringFromClass([ZRSWResetPhoneController class]);
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
        {
            ZRSWMineModel *model = [[ZRSWMineModel alloc] init];
            model.title = @"退出登录";
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
