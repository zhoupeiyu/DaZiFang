//
//  ZRSWLoansController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoansController.h"
#import "ZRSWNeedLoansController.h"
#import "SDCycleScrollView.h"
#import "ZRSWHomeNewsHeaderView.h"
#import "ZRSWHomeNewsCell.h"
#import "UserService.h"
#import "ZRSWNewAndQuestionDetailsController.h"
#import "ZRSWLoansTopCell.h"
#import "OrderService.h"
#import "ZRSWLinePrejudicationController.h"
#import "ZRSWProductListController.h"

@interface ZRSWLoansController ()<SDCycleScrollViewDelegate,ZRSWHomeNewsHeaderViewDelegate>
// ** 轮播图 **/
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// ** banner 列表 **/
@property (nonatomic, strong) NSMutableArray *bannerArray;
// ** 贷款产品 **/
@property (nonatomic, strong) NSMutableArray *loanProductArray;
// ** 热门资讯 **/
@property (nonatomic, strong) NSMutableArray *hotInfoArray;
// ** banner 图片数组 **/
@property (nonatomic, strong) NSMutableArray *pictureArray;
// ** 贷款大类 **/
@property (nonatomic, strong) ZRSWOrderMainTypeListModel *mainTypeListModel;
// ** 热门产品 **/
@property (nonatomic, strong) ZRSWHomeNewsHeaderView *hotProductHeader;
// ** 热门资讯 **/
@property (nonatomic, strong) ZRSWHomeNewsHeaderView *hotInfoHeader;
// ** banner 高度 **/
@property (nonatomic, assign) CGFloat bannerHeight;
// ** 快捷入口 高度 **/
@property (nonatomic, assign) CGFloat fasterEntranceHeight;
// ** header 高度 **/
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
// ** 城市ID **/
@property (nonatomic, strong) NSString *selectedCityID;
@end

@implementation ZRSWLoansController

#pragma mark - View Life Cycle

- (void)dealloc {
    
}
- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
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
    self.title = @"贷款产品";
}

- (void)initilizeData {
    self.bannerHeight = kUI_HeightS(178);
    self.fasterEntranceHeight = kUI_HeightS(98);
    self.sectionHeaderHeight = kUI_HeightS(35);
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLocationKey];
    if ([dic.allKeys containsObject:@"name"] && [dic.allKeys containsObject:@"id"]) {
        NSString *name = dic[@"name"];
        NSString *ID = dic[@"id"];
        self.selectedCityID = ID;
    }
    
    [self requsetPopularInformationList];
    [self requestMainType];
    [self requsetHotProduct];
}
- (void)initilizeUI {
    
}
- (void)layoutAllSubViews {
    
}

#pragma mark - Public Method

- (void)requsetPopularInformationList{
    [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil pageSize:5 delegate:self];
}

- (void)requestMainType {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [[[OrderService alloc] init] getOrderMainTypeList:self.selectedCityID delegate:self];
    }
}

- (void)requsetHotProduct {
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
//
        [[[OrderService alloc] init] getHotProductList:self.selectedCityID delegate:self];
    }
}
#pragma mark - Private Method

#pragma mark - System Method

#pragma mark - Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
    if (section == 1 || section == 0) {
        numberOfRowsInSection = 1;
    }
    else if (section == 2) {
        numberOfRowsInSection = self.loanProductArray.count;
    }
    else if (section == 3) {
        numberOfRowsInSection = self.hotInfoArray.count;
    }
    return numberOfRowsInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return nil;
    }
    else {
        ZRSWHomeNewsHeaderView *headerView = [[ZRSWHomeNewsHeaderView alloc] init];
        headerView.nextBtn.tag = section;
        if (section == 2) {
            return self.hotProductHeader;
        }
        else if (section == 3) {
            return self.hotInfoHeader;
        }
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0.0f;
    }
    else  {
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.0f;
    }
    else {
        return self.sectionHeaderHeight;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = 0.0;
    if (indexPath.section == 0) {
        heightForRowAtIndexPath = self.bannerHeight;
    }
    else if (indexPath.section == 1) {
        heightForRowAtIndexPath = self.fasterEntranceHeight;
    }
    else if (indexPath.section == 2) {
        ZRSWOrderLoanInfoDetailModel *detailModel = self.loanProductArray[indexPath.row];
        heightForRowAtIndexPath = [detailModel attrsCellHeight];
    }
    else if (indexPath.section == 3) {
        heightForRowAtIndexPath = kUI_HeightS(120);
    }
    return heightForRowAtIndexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bannerHeaderView"];
        [cell.contentView addSubview:self.cycleScrollView];
        return cell;
    }
    else if (indexPath.section == 1) {
        ZRSWLoansFasterEnterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansFasterEnterCell class])];
        if (!cell) {
            cell = [[ZRSWLoansFasterEnterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansFasterEnterCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateOrderMainTypeDetaolModel:self.mainTypeListModel];
        [cell setImageBtnClick:^(ZRSWOrderMainTypeDetaolModel *model) {
            ZRSWProductListController *vc = [[ZRSWProductListController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.mainTypeID = model.mainTypeID;
            vc.title = model.title;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    else if (indexPath.section == 2) {
        ZRSWLoansProductAttributeCell *cell = [ZRSWLoansProductAttributeCell getCellWithTableView:tableView];
        ZRSWOrderLoanInfoDetailModel *detailModel = self.loanProductArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.changedColor = [UIColor colorFromRGB:0x4771f2];
        [cell setInfoDetailModel:detailModel];
        return cell;
    }
    else if (indexPath.section == 3) {
        ZRSWHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeNewsCell"];
        if (!cell) {
            cell = [[ZRSWHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeNewsCell"];
        }
        if (self.hotInfoArray.count > 0) {
            NewDetailModel *model = self.hotInfoArray[indexPath.row];
            cell.detailModel = model;
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        ZRSWOrderLoanInfoDetailModel *detailModel = self.loanProductArray[indexPath.row];
        ZRSWNeedLoansController *vc = [[ZRSWNeedLoansController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.loanId = detailModel.loanID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 3) {
        ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
        detailsVC.type = DetailsTypePopularInformation;
        detailsVC.hidesBottomBarWhenPushed = YES;
        NewDetailModel *detailModel = self.hotInfoArray[indexPath.row];
        detailsVC.detailModel = detailModel;
        detailModel.readers = [NSString stringWithFormat:@"%ld",([detailModel.readers integerValue]+1)];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}
#pragma mark - Setter

#pragma mark - Getter
- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
    }
    return _bannerArray;
}

- (NSMutableArray *)loanProductArray {
    if (!_loanProductArray) {
        _loanProductArray = [[NSMutableArray alloc] init];
    }
    return _loanProductArray;
}

- (NSMutableArray *)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc] init];
        [_pictureArray addObjectsFromArray:@[@"http://www.zhongrongsw.com/static-content/banner/2018/11/05/FILE000000000573023.png",@"http://www.zhongrongsw.com/static-content/banner/2018/11/05/FILE000000000574614.png",@"http://www.zhongrongsw.com/static-content/banner/2018/11/05/FILE000000000575579.png"]];
    }
    return _pictureArray;
}
- (NSMutableArray *)hotInfoArray {
    if (!_hotInfoArray) {
        _hotInfoArray = [[NSMutableArray alloc] init];
    }
    return _hotInfoArray;
}
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"home_advertisement_bg"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_advertise_instructions_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_advertise_instructions_default"];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [_cycleScrollView adjustWhenControllerViewWillAppera];
        _cycleScrollView.imageURLStringsGroup = self.pictureArray;
    }
    return _cycleScrollView;
}
- (ZRSWHomeNewsHeaderView *)hotInfoHeader {
    if (!_hotInfoHeader) {
        _hotInfoHeader = [[ZRSWHomeNewsHeaderView alloc] init];
        [_hotInfoHeader setTitle:@"热门资讯"];
        _hotInfoHeader.delegate = self;
    }
    return _hotInfoHeader;
}
- (ZRSWHomeNewsHeaderView *)hotProductHeader {
    if (!_hotProductHeader) {
        _hotProductHeader = [[ZRSWHomeNewsHeaderView alloc] init];
        [_hotProductHeader setTitle:@"热门贷款产品"];
        _hotProductHeader.delegate = self;
        [_hotProductHeader showLineView];
    }
    return _hotProductHeader;
}

#pragma mark - Network CallBack

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetNewsListPopInfoRequest]) {
            NewListModel *model = (NewListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.hotInfoArray.count > 0) {
                    [self.hotInfoArray removeAllObjects];
                }
                [self.hotInfoArray addObjectsFromArray:model.data];
                [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }
        else if ([reqType isEqualToString:KGetOrderMainTypeListRequest]) {
            ZRSWOrderMainTypeListModel *listModel = (ZRSWOrderMainTypeListModel *)resObj;
            if (listModel.error_code.integerValue == 0) {
                self.mainTypeListModel = listModel;
                self.fasterEntranceHeight = listModel.getListHeigt;
                [self.tableView reloadData];
            }
            else {
                [TipViewManager showToastMessage:listModel.error_msg];
            }
        }
        else if ([reqType isEqualToString:KGetOrderHotProductListRequest]) {
            ZRSWOrderLoanHotProductModel *infoModel = (ZRSWOrderLoanHotProductModel *)resObj;
            if (infoModel.error_code.integerValue == 0) {
                [self.loanProductArray removeAllObjects];
                for (ZRSWOrderLoanInfoDetailModel *model in infoModel.data) {
                    model.isNeedTittle = YES;
                }
                [self.loanProductArray addObjectsFromArray:infoModel.data];
                [self.tableView reloadData];
            }
        }
    }
}

@end
