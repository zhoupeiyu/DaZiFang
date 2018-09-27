//
//  ZRSWLinePrejudicationController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationController.h"

#define KFootBtnHeight      60


@interface ZRSWLinePrejudicationController ()
@property (nonatomic, strong) UIButton *footBtn;

@end

@implementation ZRSWLinePrejudicationController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    
}
- (void)setupUI {
    [super setupUI];
    [self enableRefreshHeader:YES];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, KFootBtnHeight, 0);
    [self.view addSubview:self.footBtn];
    [self setupLayOut];
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"线上预审";
    [self setLeftBackBarButton];
    
    
}
- (void)setupLayOut {
    [super setupLayOut];
    [self.footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(KFootBtnHeight);
    }];
}
#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd ----- %zd",indexPath.row,indexPath.section];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 30;
    }
    else {
        return 0.00001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorFromRGB:0xf7f8fc];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorFromRGB:0xf7f8fc];
        return view;
    }
    else {
//        ZRSWLoansTopHeaderView *headerView = [[ZRSWLoansTopHeaderView alloc] init];
//        headerView.headerTitle = self.headerTitleSource[section - 1];
//        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
    
#pragma mark - lazy

- (UIButton *)footBtn {
    if (!_footBtn) {
        _footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footBtn setBackgroundImage:[UIImage imageNamed:@"currency_bottom_button"] forState:UIControlStateNormal];
        [_footBtn setTitle:@"线上预审" forState:UIControlStateNormal];
        [_footBtn setTitleColor:[UIColor colorFromRGB:0xffffff] forState:UIControlStateNormal];
        [_footBtn setAdjustsImageWhenHighlighted:YES];
        [_footBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
        _footBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _footBtn;
}

@end
