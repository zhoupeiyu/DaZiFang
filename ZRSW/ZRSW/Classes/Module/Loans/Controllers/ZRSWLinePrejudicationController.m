//
//  ZRSWLinePrejudicationController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationController.h"

#define KFootBtnHeight      60
#define KFootViewHeight     40
#define KHeaderViewHeight   54

@interface ZRSWLinePrejudicationController ()

@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *headerTitles;

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
    self.tableView.backgroundColor = [UIColor clearColor];
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
- (void)goBack {
    [self endFootRefreshing];
    [self endHeadRefreshing];
    [super goBack];
}
#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        return 230;
    }
    else if (indexPath.section == 4) {
        return 120;
    }
    else {
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return KFootViewHeight;
    }
    else {
        return 0.00001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    else {
        return KHeaderViewHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return self.footView;
    }
    else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    else {
        NSString *title = self.headerTitles[section - 1];
        return [self getHeaderView:title tag:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - action
- (void)exampleAction:(UIButton *)btn {
    [TipViewManager showToastMessage:[NSString stringWithFormat:@"%zd",btn.tag]];
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
- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor clearColor];
        _footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFootViewHeight);
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"材料审核需7个工作日，如有疑问，请拨打客服热线:010-67228038";
        lbl.textColor = [UIColor colorFromRGB:0x999999];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.numberOfLines = 0;
        [lbl sizeToFit];
        [_footView addSubview:lbl];
        [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(_footView.mas_centerY).offset(8);
            make.right.mas_equalTo(-15);
        }];
    }
    return _footView;
}
- (NSMutableArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = [[NSMutableArray alloc] init];
        [_headerTitles addObjectsFromArray:@[@"上传户口本图片",@"上传身份证图片",@"上传房产证图片",@"备注"]];
    }
    return _headerTitles;
}
- (UIView *)getHeaderView:(NSString *)title tag:(NSInteger)tag {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KHeaderViewHeight);
    
    UIView *bottomBGView = [[UIView alloc] init];
    bottomBGView.backgroundColor = [UIColor whiteColor];
    bottomBGView.frame = CGRectMake(0, KHeaderViewHeight - 44, SCREEN_WIDTH, 44);
    [bgView addSubview:bottomBGView];
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor colorFromRGB:0xFF5274];
    redView.layer.cornerRadius = 1.5;
    redView.layer.masksToBounds = YES;
    [bottomBGView addSubview:redView];
    [redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bottomBGView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, 11));
    }];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = title;
    lbl.textColor = [UIColor colorFromRGB:0x666666];
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.textAlignment = NSTextAlignmentLeft;
    [lbl sizeToFit];
    [bottomBGView addSubview:lbl];
    [lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(redView.mas_right).offset(3);
        make.centerY.mas_equalTo(bottomBGView.mas_centerY);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"pretrial_examples_button"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"pretrial_examples_button"] forState:UIControlStateNormal];
    [btn setTitle:@"示例" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromRGB:0xffffff] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0xffffff alpha:0.6] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.tag = tag;
    [btn addTarget:self action:@selector(exampleAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:btn];
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(bottomBGView);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorFromRGB:0xF4F5F6];
    [bottomBGView addSubview:lineView];
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomBGView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    return bgView;
}
@end
