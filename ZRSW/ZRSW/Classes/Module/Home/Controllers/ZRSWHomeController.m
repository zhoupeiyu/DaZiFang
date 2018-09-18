//
//  ZRSWHomeController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWHomeController.h"
#import "SDCycleScrollView.h"
#import "UserService.h"
#import "UserModel.h"
#import "ZRSWHomeBannerModel.h"
#import "ZRSWHomeNewsCell.h"
#import "ZRSWHomeNewsHeaderView.h"
@interface ZRSWHomeController ()<SDCycleScrollViewDelegate,BaseNetWorkServiceDelegate,ZRSWHomeNewsHeaderViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *hotNewsListSource;
@property (nonatomic, strong) NSMutableArray *systemNewsListSource;
@property (nonatomic, strong) NSMutableArray *faqsListSource;
@property (nonatomic, strong) UIView *loanView;
@property (nonatomic, strong) UILabel *loanAmountLabel;
@property (nonatomic, strong) UIView *systemNotificationView;
@property (nonatomic, strong) UILabel *systemNotificationLabel;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation ZRSWHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.cycleScrollView];
    [self setUpTableView];
    [self requsetBannerList];
    [self requsetCityList];
}

- (void)setupConfig {
    [super setupConfig];
    self.navigationItem.title = @"大资方";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableViewStyle =  UITableViewStyleGrouped;
//    UITableViewStyleGrouped
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorColor = [UIColor colorFromRGB:0xeaeaea];
    self.tableView.tableHeaderView = self.headerView;
    [self enableRefreshHeader:YES refreshSelector:@selector(refreshData)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotNewsListSource.count+2;
    }else{
        return self.faqsListSource.count+1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZRSWHomeNewsHeaderView *headerView = [[ZRSWHomeNewsHeaderView alloc] init];
    headerView.nextBtn.tag = section;
    if (section == 0) {
        [headerView setTitle:@"热门资讯"];
    }else if (section == 1) {
        [headerView setTitle:@"常见问题"];
    }
    headerView.delegate = self;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor colorFromRGB:0xFFF7F8FC];
        return footerView;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZRSWHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeNewsCell"];
        if (!cell) {
            cell = [[ZRSWHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeNewsCell"];
        }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(120);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kUI_HeightS(35);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return kUI_HeightS(10);
    }else{
        return 0.1;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(void)getMoreClick:(NSInteger)type title:(NSString *)title{
    if (type == 0) {
        NSLog(@"热门资讯");
    }else if (type == 1){
        NSLog(@"常见问题");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NetWork
- (void)requsetCityList{
    [[[UserService alloc] init] getCityListDelegate:self];
}

- (void)requsetBannerList{
    NSString *cityId = @"";
    [[[UserService alloc] init] getBannerWithCityID:cityId delegate:self];
}

- (void)requsetPopularInformationList{
    [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil delegate:self];
}

- (void)requsetSystemNotificationList{
    [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:nil delegate:self];
}

- (void)refreshData{
    [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil delegate:self];
    [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:nil delegate:self];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [self endHeadRefreshing];
    [self endFootRefreshing];
    if ([reqType isEqualToString:KCityListRequest]) {
        CityListModel *model = (CityListModel *)resObj;
        if (model.error_code.integerValue == 0) {
            if (self.cityArray.count > 0) {
                [self.cityArray removeAllObjects];
            }
            for (NSUInteger i = 0; i < model.data.count; ++i){
                CityDetailModel *detailModel = model.data[i];
                NSLog(@"%@",detailModel.name);
                [self.cityArray addObject:detailModel.name];
            }
        }
    }else if ([reqType isEqualToString:KBannerRequest]) {
         ZRSWHomeBannerModel *model = (ZRSWHomeBannerModel *)resObj;
        if (model.error_code.integerValue == 0) {
            if (self.pictureArray.count > 0) {
                [self.pictureArray removeAllObjects];
            }
            for (NSUInteger i = 0; i < model.data.count; ++i){
                HomeBannerModelDetails *detailModel = model.data[i];
                NSLog(@"%@",detailModel.imgUrl);
                [self.pictureArray addObject:detailModel.imgUrl];
            }
            self.cycleScrollView.imageURLStringsGroup = self.pictureArray;
        }
    }else if ([reqType isEqualToString:KGetNewsListPopInfoRequest]) {
        NewListModel *model = (NewListModel *)resObj;
        if (model.error_code.integerValue == 0) {
            for (NSUInteger i = 0; i < model.data.count; ++i){
                NewDetailModel *detailModel = model.data[i];
                [self.hotNewsListSource addObject:detailModel];
            }
        }
    }else if ([reqType isEqualToString:KGetNewsListSysNotiRequest]) {
        NewListModel *model = (NewListModel *)resObj;
        if (model.error_code.integerValue == 0) {
            for (NSUInteger i = 0; i < model.data.count; ++i){
                NewDetailModel *detailModel = model.data[i];
                [self.systemNewsListSource addObject:detailModel];
            }
        }
    }else if ([reqType isEqualToString:KGetCommentQuestionListRequest]) {
        CommentQuestionListModel *model = (CommentQuestionListModel *)resObj;
        if (model.error_code.integerValue == 0) {
            for (NSUInteger i = 0; i < model.data.count; ++i){
                CommentQuestionModel *detailModel = model.data[i];
                [self.faqsListSource addObject:detailModel];
            }
        }
    }else{
//            NSLog(@"请求失败:%@",model.error_msg);
        }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return NO;
}




#pragma mark - delegate && datasource
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

}

- (void)loanButtonClck:(UIButton *)button{


}


- (UIView *)headerView{
    if (!_headerView) {
        CGFloat height = kUI_HeightS(175+10+135+10+44+10);
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _headerView.backgroundColor = [UIColor colorFromRGB:0xF7F8FC];
        [_headerView addSubview:self.cycleScrollView];
        [_headerView addSubview:self.loanView];
        [_headerView addSubview:self.systemNotificationView];
    }
    return _headerView;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        CGFloat height = kUI_HeightS(175);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) delegate:self placeholderImage:[UIImage imageNamed:@"home_advertisement_bg"]];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_advertise_instructions_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_advertise_instructions_default"];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [_cycleScrollView adjustWhenControllerViewWillAppera];
    }
    return _cycleScrollView;
}

- (UIView *)loanView{
    if (!_loanView) {
        CGFloat height = kUI_HeightS(135);
        _loanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cycleScrollView.bottom + kUI_HeightS(10), SCREEN_WIDTH, height)];
        _loanView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(126))/2 , kUI_HeightS(15), kUI_WidthS(126), kUI_HeightS(15))];
        titleLabel.text = @"最高可贷款（元）";
        titleLabel.textColor = [UIColor colorFromRGB:0x666666];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [_loanView addSubview:titleLabel];
        _loanAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(205))/2 , titleLabel.bottom + kUI_HeightS(16), kUI_WidthS(205), kUI_HeightS(36))];
        _loanAmountLabel.text = @"10,000,000";
        _loanAmountLabel.textColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:_loanAmountLabel.bounds andColors:@[[UIColor colorFromRGB:0xFFFF5153],[UIColor colorFromRGB:0xFFFF806B]]];;
        _loanAmountLabel.textAlignment = NSTextAlignmentLeft;
        _loanAmountLabel.font = [UIFont systemFontOfSize:36];
        [_loanView addSubview:_loanAmountLabel];
        UIButton *loanButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(226))/2 , _loanAmountLabel.bottom + kUI_HeightS(12), kUI_WidthS(226), kUI_HeightS(29))];
        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x4771F2]] forState:UIControlStateNormal];
        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x2341BF]] forState:UIControlStateHighlighted];
        [loanButton.layer setCornerRadius:5.0];
        [loanButton.layer setMasksToBounds:YES];
        [loanButton setTitle:@"我要贷款" forState:UIControlStateNormal];
        [loanButton setTitle:@"我要贷款" forState:UIControlStateHighlighted];
        [loanButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateNormal];
        [loanButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateHighlighted];
        loanButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [loanButton addTarget:self action:@selector(loanButtonClck:) forControlEvents:UIControlEventTouchUpInside];
        [_loanView addSubview:loanButton];
    }
    return _loanView;
}

- (UIView *)systemNotificationView{
    if (!_systemNotificationView) {
        CGFloat height = kUI_HeightS(44);
        _systemNotificationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.loanView.bottom + kUI_HeightS(10), SCREEN_WIDTH, height)];
        _systemNotificationView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
        UIImageView *leftTitle = [[UIImageView alloc] initWithFrame:CGRectMake(kUI_WidthS(15),kUI_HeightS(13), kUI_WidthS(78), kUI_HeightS(18))];
        leftTitle.image = [UIImage imageNamed:@"home_notice"];
        [_systemNotificationView addSubview:leftTitle];
        _systemNotificationLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(168))/2 ,kUI_HeightS(16), kUI_WidthS(168), kUI_HeightS(12))];
        _systemNotificationLabel.text = @"央行发布房抵贷利率下调0.5";
        _systemNotificationLabel.textColor = [UIColor colorFromRGB:0x333333];
        _systemNotificationLabel.textAlignment = NSTextAlignmentCenter;
        _systemNotificationLabel.font = [UIFont systemFontOfSize:12];
        [_systemNotificationView addSubview:_systemNotificationLabel];

        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(_systemNotificationLabel.right + kUI_WidthS(44) ,kUI_HeightS(15), kUI_WidthS(28), kUI_HeightS(14))];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor colorFromRGB:0x999999] forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreButton addTarget:self action:@selector(loanButtonClck:) forControlEvents:UIControlEventTouchUpInside];
        [_systemNotificationView addSubview:moreButton];
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreButton.right + kUI_WidthS(5) ,kUI_HeightS(15), kUI_WidthS(12), kUI_HeightS(12))];
        moreImageView.image = [UIImage imageNamed:@"home_notice_arrow"];
        [_systemNotificationView addSubview:moreImageView];
    }
    return _systemNotificationView;
}

@end
