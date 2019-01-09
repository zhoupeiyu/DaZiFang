//
//  ZRSWProductListController.m
//  ZRSW
//
//  Created by 周培玉 on 2019/1/8.
//  Copyright © 2019 周培玉. All rights reserved.
//

#import "ZRSWProductListController.h"
#import "ZRSWLoansTopCell.h"
#import "ZRSWNeedLoansController.h"
#import "OrderService.h"

@interface ZRSWProductListController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ZRSWProductListController

#pragma mark - View Life Cycle

- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}
#pragma mark - initialization

- (void)initialization {
    // 初始化配置，包括背景色，标题等
    [self initilizeConfig];
    // 初始化变量的值
    [self initilizeData];
    // 初始化UI
    [self initilizeUI];
    // UI 控件布局
    [self layoutAllSubViews];
}

- (void)initilizeConfig {
    [self setLeftBackBarButton];
}

- (void)initilizeData {
    [self rquestLoanType];
}
- (void)initilizeUI {
    
}
- (void)layoutAllSubViews {
    
}

#pragma mark - Public Method

#pragma mark - Private Method

- (void)rquestLoanType {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [[[OrderService alloc] init] getOrderLoanTypeList:self.mainTypeID delegate:self];
    }
}

#pragma mark - System Method

#pragma mark - Delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWLoansProductAttributeCell *cell = [ZRSWLoansProductAttributeCell getCellWithTableView:tableView];
    ZRSWOrderLoanInfoDetailModel *detailModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.changedColor = [UIColor colorFromRGB:0x4771f2];
    [cell setInfoDetailModel:detailModel];
    [cell showOrHiddenLineView:indexPath.row == self.dataSource.count - 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRSWOrderLoanInfoDetailModel *detailModel = self.dataSource[indexPath.row];
    return [detailModel attrsCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZRSWOrderLoanInfoDetailModel *detailModel = self.dataSource[indexPath.row];
    ZRSWNeedLoansController *vc = [[ZRSWNeedLoansController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.loanId = detailModel.loanID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
#pragma mark - Network CallBack
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if ([reqType isEqualToString:KGetOrderLoanTypeListRequest]) {
        
        ZRSWOrderLoanProductListModel *listModel = (ZRSWOrderLoanProductListModel *)resObj;
        if (listModel.error_code.integerValue == 0) {
            [self.dataSource removeAllObjects];
            for (ZRSWOrderLoanInfoDetailModel *model in listModel.data) {
                if (model.loanTypeAttrs.count > 0) {
                    model.isNeedTittle = YES;
                    [self.dataSource addObject:model];
                }
            }
            [self.tableView reloadData];
        }
        else {
            [TipViewManager showToastMessage:listModel.error_msg];
        }
    }
}


@end
