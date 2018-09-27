//
//  ZRSWNeedLoansController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWNeedLoansController.h"
#import "ZRSWLoansTopCell.h"
#import "OrderService.h"
#import "ZRSWOrderModel.h"

#define KTitleKey           @"KTitleKey"
#define KContentKey         @"KContentKey"
#define KIDKey              @"KIDKey"
#define KListContentKey     @"KListContentKey"
#define KListIDsKey         @"KListIDsKey"
#define KFootBtnHeight      60

@interface ZRSWNeedLoansController ()<PickerViewDelegate>

@property (nonatomic, strong) OrderService *service;

@property (nonatomic, strong) NSMutableArray *topDataSource;

@property (nonatomic, strong) NSMutableArray *headerTitleSource;
@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) ZRSWOrderLoanInfoModel *infoModel;

@property (nonatomic, assign) BOOL selectedNewCity;
@property (nonatomic, assign) BOOL selectedNewMainType;
@property (nonatomic, assign) BOOL selectedNewLoanID;

@property (nonatomic, strong) NSString *selectedCityID;
@property (nonatomic, strong) NSString *selectedMainTypeID;
@property (nonatomic, strong) NSString *selectedLoanID;

@end

@implementation ZRSWNeedLoansController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

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
    self.title = @"我要贷款";
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
    NSUInteger lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TabBarDidClickNotificationKey];
    [self.tabBarController setSelectedIndex:lastIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshData {
    
}

- (void)showPickViewWithDataSource:(NSArray *)dataSource {
    PickerView *pickView = [[PickerView alloc] initWithData:dataSource];
    pickView.delegate = self;
    pickView.pickerHeight = 190.f;
    pickView.frame = self.view.bounds;
    pickView.tag = self.currentIndexPath.row;
    pickView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 35);
    [self.view addSubview:pickView];
}

- (void)requestMainType {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [self.service getOrderMainTypeList:self.selectedCityID delegate:self];
    }
}
- (void)rquestLoanType {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [self.service getOrderLoanTypeList:self.selectedMainTypeID delegate:self];
    }
}
- (void)requestLoanInfo {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [self.service getLoanDetailInfo:self.selectedLoanID delegate:self];
    }
}

- (void)setInfoModel:(ZRSWOrderLoanInfoModel *)infoModel {
    _infoModel = infoModel;
    [self.tableView reloadData];
}
#pragma mark - delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.selectedLoanID.length > 0 && self.infoModel) {
        return 5;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZRSWLoansTopCell *cell = [ZRSWLoansTopCell getCellWithTableView:tableView];
        NSDictionary *dic = self.topDataSource[indexPath.row];
        cell.titleStr = (NSString *)dic[KTitleKey];
        cell.contentStr = (NSString *)dic[KContentKey];
        cell.isNeedLine = indexPath.row != self.topDataSource.count - 1;
        return cell;
    }
    else if (indexPath.section == 1) {
        ZRSWLoansProductAttributeCell *cell = [ZRSWLoansProductAttributeCell getCellWithTableView:tableView];
        cell.infoDetailModel = self.infoModel.data;
        return cell;
    }
    else if (indexPath.section == 2) {
        ZRSWLoansConditionCell *cell = [ZRSWLoansConditionCell getCellWithTableView:tableView];
        cell.loanConditionsModel = self.infoModel.data;
        return cell;
    }
    else if (indexPath.section == 3) {
        ZRSWLoansConditionCell *cell = [ZRSWLoansConditionCell getCellWithTableView:tableView];
        cell.materialDetailsModel = self.infoModel.data;
        return cell;
    }
    else if (indexPath.section == 4) {
        ZRSWLoansFlow *cell = [ZRSWLoansFlow getCellWithTableView:tableView];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%zd ----- %zd",indexPath.row,indexPath.section];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [ZRSWLoansTopCell cellHeigh];
    }
    else if (indexPath.section == 1) {
        return [self.infoModel.data attrsCellHeight];
    }
    else if (indexPath.section == 2) {
        return [self.infoModel.data loanConditionsCellHeight];
    }
    else if (indexPath.section == 3) {
        return [self.infoModel.data materialDetailsCellHeight];

    }
    else if (indexPath.section == 4) {
        return [ZRSWLoansFlow cellHeigh];
    }
    else {
        return 100;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    else {
        return 35;
    }
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
        ZRSWLoansTopHeaderView *headerView = [[ZRSWLoansTopHeaderView alloc] init];
        headerView.headerTitle = self.headerTitleSource[section - 1];
        return headerView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndexPath = indexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSDictionary *dic = self.topDataSource[indexPath.row];
            NSArray *arr = dic[KListContentKey];
            [self showPickViewWithDataSource:arr];
        }
        else {
            if (indexPath.row == 1) {
                LLog(@"---->%d",self.selectedNewCity);
                if (self.selectedNewCity) {
                    [self requestMainType];
                }
                else {
                    NSDictionary *dic = self.topDataSource[indexPath.row];
                    NSArray *arr = dic[KListContentKey];
                    [self showPickViewWithDataSource:arr];
                }
            }
            else if (indexPath.row == 2) {
                if (self.selectedNewMainType) {
                    [self rquestLoanType];
                }
                else {
                    NSDictionary *dic = self.topDataSource[indexPath.row];
                    NSArray *arr = dic[KListContentKey];
                    [self showPickViewWithDataSource:arr];
                }
            }
        }
    }
}

- (void)pickerView:(PickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableDictionary *dic = self.topDataSource[pickerView.tag];
    NSArray *contentList = dic[KListContentKey];
    NSArray *idList = dic[KListIDsKey];
    NSString *title = contentList[row];
    NSString *ID = idList[row];
    [dic setObject:title forKey:KContentKey];
    [dic setObject:ID forKey:KIDKey];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    if (self.currentIndexPath.row == 0) {
        self.selectedNewCity = ![ID isEqualToString:self.selectedCityID];
        self.selectedCityID = ID;
    }
    else if (self.currentIndexPath.row == 1) {
        self.selectedNewMainType = ![ID isEqualToString:self.selectedMainTypeID];
        self.selectedMainTypeID = ID;
        self.selectedNewCity = NO;
        
    }
    else if (self.currentIndexPath.row == 2) {
        self.selectedNewLoanID = ![ID isEqualToString:self.selectedLoanID];
        self.selectedLoanID = ID;
        self.selectedNewCity = NO;
        self.selectedNewMainType = NO;
        [self requestLoanInfo];
    }
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetOrderMainTypeListRequest]) {
            ZRSWOrderMainTypeListModel *listModel = (ZRSWOrderMainTypeListModel *)resObj;
            if (listModel.error_code.integerValue == 0) {
                if ([ZRSWOrderMainTypeListModel getMainTypeTitles].count == 0 || [ZRSWOrderMainTypeListModel getMainTypeIDs].count == 0) return;
                NSMutableDictionary *dic = self.topDataSource[1];
                dic[KListContentKey] = [ZRSWOrderMainTypeListModel getMainTypeTitles];
                dic[KListIDsKey] = [ZRSWOrderMainTypeListModel getMainTypeIDs];
                NSArray *arr = dic[KListContentKey];
                [self showPickViewWithDataSource:arr];
                
            }
            else {
                [TipViewManager showToastMessage:listModel.error_msg];
            }
        }
        
        else if ([reqType isEqualToString:KGetOrderLoanTypeListRequest]) {
            ZRSWOrderLoanTypeListModel *listModel = (ZRSWOrderLoanTypeListModel *)resObj;
            if (listModel.error_code.integerValue == 0) {
                if ([ZRSWOrderLoanTypeListModel getOrderLoanTypeTitles].count == 0 || [ZRSWOrderLoanTypeListModel getOrderLoanTypeIDs].count == 0) return;
                NSMutableDictionary *dic = self.topDataSource[2];
                dic[KListContentKey] = [ZRSWOrderLoanTypeListModel getOrderLoanTypeTitles];
                dic[KListIDsKey] = [ZRSWOrderLoanTypeListModel getOrderLoanTypeIDs];
                NSArray *arr = dic[KListContentKey];
                [self showPickViewWithDataSource:arr];
                
            }
            else {
                [TipViewManager showToastMessage:listModel.error_msg];
            }
        }
        else if ([reqType isEqualToString:KGetOrderLoanInfoRequest]) {
            ZRSWOrderLoanInfoModel *listModel = (ZRSWOrderLoanInfoModel *)resObj;
            self.infoModel = listModel;
        }
    }
    else {
        [TipViewManager showToastMessage:@"网络错误"];
    }
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
- (NSMutableArray *)topDataSource {
    if (!_topDataSource) {
        _topDataSource = [[NSMutableArray alloc] init];
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@"所在城市" forKey:KTitleKey];
            [dic setObject:@"请选择" forKey:KContentKey];
            [dic setObject:@"" forKey:KIDKey];
            [dic setObject:[CityListModel getCityNames] forKey:KListContentKey];
            [dic setObject:[CityListModel getCityIds] forKey:KListIDsKey];
            [_topDataSource addObject:dic];
        }
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@"贷款大类" forKey:KTitleKey];
            [dic setObject:@"请选择" forKey:KContentKey];
            [dic setObject:@"0" forKey:KIDKey];
            [dic setObject:[NSMutableArray array] forKey:KListContentKey];
            [dic setObject:[NSMutableArray array] forKey:KListIDsKey];
            [_topDataSource addObject:dic];
        }
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@"贷款产品" forKey:KTitleKey];
            [dic setObject:@"请选择" forKey:KContentKey];
            [dic setObject:@"0" forKey:KIDKey];
            [dic setObject:[NSMutableArray array] forKey:KListContentKey];
            [dic setObject:[NSMutableArray array] forKey:KListIDsKey];
            [_topDataSource addObject:dic];
        }
    }
    return _topDataSource;
}

- (NSMutableArray *)headerTitleSource {
    if (!_headerTitleSource) {
        _headerTitleSource = [[NSMutableArray alloc] init];
        [_headerTitleSource addObjectsFromArray:@[@"产品属性",@"进件条件",@"准备材料",@"放款流程"]];
    }
    return _headerTitleSource;
}
- (OrderService *)service {
    if (!_service) {
        _service = [[OrderService alloc] init];
    }
    return _service;
}
@end
