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


#define KLogoutViewH     kUI_HeightS(84)
#define KCellH           kUI_HeightS(44)
@interface ZRSWSettingController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *logoutView;

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
    self.tableView.tableFooterView = self.logoutView;
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
    return KCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWMineModel *mineModel = self.dataSource[indexPath.row];
    if (indexPath.row == 0) {
        return;
    }else{
        BaseViewController *vc = [(BaseViewController *)[NSClassFromString(mineModel.viewControllerName)
                                                         alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)logoutAction {
    [UserModel removeUserData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)logoutView {
    if (!_logoutView) {
        _logoutView = [[UIView alloc] init];
        _logoutView.backgroundColor = [UIColor clearColor];
        _logoutView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KLogoutViewH);
        UIButton *_logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(0, KLogoutViewH - KCellH, SCREEN_WIDTH, KCellH);
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor colorWithHex:0xff0000 alpha:0.6] forState:UIControlStateHighlighted];
        [_logoutBtn adjustsImageWhenHighlighted];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0xf9f9f9]] forState:UIControlStateHighlighted];
        [_logoutView addSubview:_logoutBtn];
        [_logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutView;
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
    [self.tableView reloadData];
}


@end
