//
//  BaseTableViewController.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
}
- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}
- (void)setupUI {
    [self.view addSubview:self.tableView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)showPlaceholedView {
    [self.tableView reloadEmptyDataSet];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ![BaseNetWorkService isReachable] ? @"无网络" : @"无数据";
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:21];
    UIColor *textColor = [UIColor colorFromRGB:0x474455];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = ![BaseNetWorkService isReachable] ? @"当前网络连接失败，\n快去重新连接一下试试吧！" : @"当前没有相应数据，快去看看别的吧！";
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
    UIColor *textColor = [UIColor colorWithHex:0x666666 alpha:0.7];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedString;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ![BaseNetWorkService isReachable] ? [UIImage imageNamed:@"currency_no_network"] : [UIImage imageNamed:@"currency_no_data"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return ![BaseNetWorkService isReachable] ? [[NSAttributedString alloc] initWithString:@"重试" attributes:@{
                                                                                                           NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                                                           NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                                                                           }] : [[NSAttributedString alloc] initWithString:@""];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-28, -100, -25, -100);
    UIImage *image = [UIImage imageNamed:@"currency_no_network_button"];
    return ![BaseNetWorkService isReachable] ? [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets] : nil;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - kNavigationBarH;
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self refreshData];
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self refreshData];
}
- (void)enableRefreshHeader:(BOOL)enabled {
    if (nil == self.tableView.mj_header) {
        LXRefreshDIYHeader *header = [LXRefreshDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        self.tableView.mj_header = header;
    }
    self.tableView.mj_header.hidden = !enabled;
}
- (void)enableLoadMore:(BOOL)enabled {
    if (enabled) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多数据啦~" forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer = footer;
    }
    else {
        self.tableView.mj_footer = nil;
    }
}
- (void)endHeadRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)endFootRefreshing {
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}
- (void)refreshData {
    LLog(@"刷新");
}
- (void)loadMoreData {
    LLog(@"加载更多");
}
- (void)hiddenHeader:(BOOL)isHidden {
    self.tableView.mj_header.hidden = isHidden;
}
- (void)hiddenFooter:(BOOL)isHidden {
    self.tableView.mj_footer.hidden = isHidden;
}
#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [BaseTheme baseViewColor];
        _tableView.contentInset = UIEdgeInsetsZero;
    }
    return _tableView;
}
@end
