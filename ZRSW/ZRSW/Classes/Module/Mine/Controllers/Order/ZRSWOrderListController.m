//
//  ZRSWOrderListController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWOrderListController.h"
#import "ZRSWOnlineCustomerServiceController.h"
#import "ZRSWOrderListDetailController.h"

@interface ZRSWOrderListController ()<TYTabPagerBarDataSource, TYTabPagerBarDelegate, TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *tabLineView;

@end

@implementation ZRSWOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat barHeight = 44;
    _tabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), barHeight);
    _pagerController.view.frame = CGRectMake(0, barHeight, self.view.width, self.view.height - barHeight);
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"我的订单";
    [self setRightBarButtonWithText:@"客服"];
    [self.rightBarButton addTarget:self action:@selector(customerServiceAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setupUI {
    [super setupUI];
    [self.view addSubview:self.tabBar];
    [self.view addSubview:self.pagerController.view];
    [self.tabBar addSubview:self.tabLineView];
    [_tabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
}
- (void)loadData {
    [self.dataSource addObjectsFromArray:@[@"全部",@"审核中",@"已通过",@"已放款",@"已完成"]];
    [self reloadData];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.dataSource.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.dataSource[index];
    return cell;
}
#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _dataSource[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}
#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return self.dataSource.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    ZRSWOrderListDetailController *vc = [[ZRSWOrderListDetailController alloc] init];
//    vc.tabType = index;
    return vc;
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (void)customerServiceAction {
    ZRSWOnlineCustomerServiceController *vc = [[ZRSWOnlineCustomerServiceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (TYTabPagerBar *)tabBar{
    
    if (!_tabBar) {
        _tabBar = [[TYTabPagerBar alloc]init];
        _tabBar.layout.barStyle = TYPagerBarStyleProgressBounceView;
        _tabBar.layout.progressHeight = 3;
        _tabBar.layout.progressRadius = 1.5;
        _tabBar.layout.progressColor = [UIColor getFontBlueColor];
        _tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:15];
        _tabBar.layout.normalTextColor = [UIColor colorFromRGB:<#(NSInteger)#>];
        _tabBar.layout.selectedTextColor = [UIColor getBackgroundBlueColor];
        _tabBar.layout.cellWidth = SCREEN_WIDTH / 6;
        _tabBar.collectionView.scrollEnabled = NO;
        _tabBar.layout.adjustContentCellsCenter = YES;
        _tabBar.dataSource = self;
        _tabBar.delegate = self;
        _tabBar.autoScrollItemToCenter = NO;
        _tabBar.collectionView.backgroundColor = [UIColor whiteColor];
        [_tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    }
    return _tabBar;
}
- (TYPagerController *)pagerController{
    
    if (!_pagerController) {
        _pagerController = [[TYPagerController alloc]init];
        _pagerController.layout.prefetchItemCount = 1;
        //pagerController.layout.autoMemoryCache = NO;
        // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
        _pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        _pagerController.dataSource = self;
        _pagerController.delegate = self;
        _pagerController.scrollView.bounces = NO;
        [self addChildViewController:_pagerController];
    }
    return _pagerController;
}
- (UIView *)tabLineView{
    
    if (!_tabLineView) {
        _tabLineView = [[UIView alloc] init];
        //
        _tabLineView.backgroundColor = [UIColor colorFromRGB:0xe8e8e8];
    }
    return _tabLineView;
}
- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
