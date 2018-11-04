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
#import "ZRSWLoginController.h"
#import "ZRSWMessageCountModel.h"
#import "ZRSWBrushFaceCertificationController.h"

#define KAuthFinishedPresentation       @"您已认证成功，不可再次提交！"
#define KAuthCommitPresentation         @"您已提交审核，不可再次提交！"


@interface ZRSWMineController ()<UITableViewDelegate, UITableViewDataSource,BaseNetWorkServiceDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger unreadCount;



@end

@implementation ZRSWMineController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([UserModel hasLogin]) {
        self.tableView.hidden = NO;
        [self getUserInfo];
    }
    else {
        self.tableView.hidden = YES;
        ZRSWLoginController *loginVC = [ZRSWLoginController getLoginViewController];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        WS(weakSelf);
        [loginVC setCancelBlock:^{
//            NSUInteger lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TabBarDidClickNotificationKey];
            [weakSelf.tabBarController setSelectedIndex:0];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    [super viewWillAppear:animated];
    [self updateUserInfo];
    [self getUnreadMessageCount];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserIcon:) name:ChangeUserInfoSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsgStatus) name:UpdateMsgStatusNotification object:nil];
    
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

- (void)updateMsgStatus{
    self.unreadCount = 0;
    ZRSWMineModel *mineModel = self.dataSource[1][1];
    mineModel.unreadCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
    if ([mineModel.title isEqualToString:@"刷脸认证"]) {
        [TipViewManager showToastMessage:@"     敬请期待     "];
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
    if ([vc isKindOfClass:[ZRSWRealNameAuthController class]]) {
        UserInfoModel *userModel = [UserModel getCurrentModel].data;
        if (userModel.authName.integerValue == 0) {
            [TipViewManager showToastMessage:KAuthCommitPresentation];
            return;
        }
        else if (userModel.authName.integerValue == 1) {
            [TipViewManager showToastMessage:KAuthFinishedPresentation];
            return;
        }
    }
    if ([vc isKindOfClass:[ZRSWEnterpriseAuthController class]]) {
        UserInfoModel *userModel = [UserModel getCurrentModel].data;
        if (userModel.authCompany.integerValue == 0) {
            [TipViewManager showToastMessage:KAuthCommitPresentation];
            return;
        }
        else if (userModel.authCompany.integerValue == 1) {
            [TipViewManager showToastMessage:KAuthFinishedPresentation];
            return;
        }
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetMessageCountRequest]) {
            ZRSWMessageCountModel *model= (ZRSWMessageCountModel *)resObj;
            if ([model.error_code intValue] == 0) {
                ZRSWMineModel *mineModel = self.dataSource[1][1];
                mineModel.unreadCount = model.data.msg_count;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                LLog(@"请求失败:%@",model.error_msg);
                [TipViewManager showToastMessage:model.error_msg];
            }
        }else if ([reqType isEqualToString:KUserLogOutRequest]) {
            [UserModel removeUserData];
            //设置LoginToke
            [[BaseNetWorkService sharedInstance] setLoginToken:nil];
            [self.tableView reloadData];
        }
        else if ([reqType isEqualToString:KGetUserInfoRequest]) {
            UserModel *model = (UserModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [UserModel updateUserModel:model];
                UserInfoModel *suer = model.data;
                //设置LoginToke
                [[BaseNetWorkService sharedInstance] setLoginToken:suer.token];
            }
        }
    }else{
        LLog(@"请求失败");
    }
}
#pragma mark - Action
- (void)settingAction {
    if (![UserModel hasLogin]) {
        ZRSWLoginController *login = [[ZRSWLoginController alloc] init];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    ZRSWSettingController *setting = [[ZRSWSettingController alloc] init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)changeUserIcon:(NSNotification *)noti {
    
}

- (void)getUnreadMessageCount{
     [[[UserService alloc] init] getMessageCount:0 delegate:self];
}

- (void)getUserInfo {
    if ([UserModel hasLogin]) {
        UserInfoModel *model = [UserModel getCurrentModel].data;
        if (model.loginId.length > 0) {
            [[[UserService alloc] init] getUserInfo:model.loginId delegate:self];
        }
    }
    
}
- (void)updateUserInfo {
    UserModel *model = [UserModel getCurrentModel];
    ZRSWMineModel *mineModel = self.dataSource[0][0];
    if (model) {
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
            model.title = @"刷脸认证";
            model.type = MineListTypeCommentList;
            model.iconName = @"my_face";
            model.viewControllerName = NSStringFromClass([ZRSWBrushFaceCertificationController class]);
            [data addObject:model];
        }
        [self.dataSource addObject:data];
    }
    [self.tableView reloadData];
}

@end
