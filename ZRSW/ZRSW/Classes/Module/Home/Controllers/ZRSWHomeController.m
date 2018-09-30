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
#import "ZRSWHomeQuestionCell.h"
#import "ZRSWHomeNewsHeaderView.h"
#import "ZRSWNewsListDetailsController.h"
#import "ZRSWQuestionListDetailsController.h"
#import "ZRSWLoansController.h"
#import "ZRSWNewAndQuestionDetailsController.h"
#import "ZRSWSettingController.h"
#import "ZRSWNeedLoansController.h"
#import "ZRSWBannerDetailsController.h"
#import "OrderService.h"

@interface ZRSWHomeController ()<SDCycleScrollViewDelegate,BaseNetWorkServiceDelegate,ZRSWHomeNewsHeaderViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *systemNewsListSource;
@property (nonatomic, strong) NSMutableArray *hotNewsListSource;
@property (nonatomic, strong) NSMutableArray *questionListSource;
@property (nonatomic, strong) UIView *loanView;
@property (nonatomic, strong) UILabel *loanAmountLabel;
@property (nonatomic, strong) UIView *systemNotificationView;
@property (nonatomic, strong) UILabel *systemNotificationLabel;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *locationView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong)  dispatch_group_t group;
@end

@implementation ZRSWHomeController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
//    [self.view addSubview:self.cycleScrollView];
    [self setUpTableView];
    self.cityArray = [NSMutableArray arrayWithCapacity:0];
    self.pictureArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerArray = [NSMutableArray arrayWithCapacity:0];
    self.hotNewsListSource = [NSMutableArray arrayWithCapacity:0];
    self.systemNewsListSource = [NSMutableArray arrayWithCapacity:0];
    self.questionListSource = [NSMutableArray arrayWithCapacity:0];
    [TipViewManager showLoading];
    self.group = dispatch_group_create();
        [self requsetCityList];
    [self requsetBannerList];
    [self requsetSystemNotificationList];
    [self requsetPopularInformationList];
    [self requsetCommentQuestionList];
    [self locationCity];
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [TipViewManager dismissLoading];
    });
}


- (void)setupConfig {
    [super setupConfig];
    self.navigationItem.title = @"大资方";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.locationView];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableHeaderView = self.headerView;
    [self enableRefreshHeader:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [TipViewManager showLoading];
//    self.group = dispatch_group_create();
//    [self requsetCityList];
//    [self requsetBannerList];
//    [self requsetSystemNotificationList];
//    [self requsetPopularInformationList];
//    [self requsetCommentQuestionList];
//    [self locationCity];
//    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
//        [TipViewManager dismissLoading];
//    });

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.hotNewsListSource.count;
    }else{
        return self.questionListSource.count;
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
    if (indexPath.section == 0) {
        ZRSWHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeNewsCell"];
        if (!cell) {
            cell = [[ZRSWHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeNewsCell"];
        }
        NewDetailModel *model = self.hotNewsListSource[indexPath.row];
        cell.detailModel = model;
         return cell;
    }else if (indexPath.section == 1){
        ZRSWHomeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRSWHomeQuestionCell"];
        if (!cell) {
            cell = [[ZRSWHomeQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRSWHomeQuestionCell"];
        }
        CommentQuestionModel *model = self.questionListSource[indexPath.row];
        cell.questionModel = model;
         return cell;
    }else{
        return nil;
    }
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


#pragma mark - NetWork
- (void)locationCity{
    WS(weakSelf);
    [[LocationManager sharedInstance] getCityLocationSuccess:^(id result) {
        if (result) {
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"%@",result];
        }
    }];
}

- (void)requsetCityList{
     dispatch_group_enter(self.group);
    [[[OrderService alloc] init] getCityListDelegate:self];
}

- (void)requsetBannerList{
     dispatch_group_enter(self.group);
    NSString *cityId = @"";
    [[[UserService alloc] init] getBannerWithCityID:cityId delegate:self];
}

- (void)requsetPopularInformationList{
     dispatch_group_enter(self.group);
    [[[UserService alloc] init] getNewList:NewListTypePopularInformation lastId:nil pageSize:3 delegate:self];
}

- (void)requsetSystemNotificationList{
     dispatch_group_enter(self.group);
    [[[UserService alloc] init] getNewList:NewListTypeSystemNotification lastId:nil pageSize:1 delegate:self];
}

- (void)requsetCommentQuestionList{
     dispatch_group_enter(self.group);
    [[[UserService alloc] init] getCommentQuestionList:nil pageSize:3 delegate:self];
}

- (void)refreshData{
    self.group = dispatch_group_create();
    [self requsetPopularInformationList];
    [self requsetSystemNotificationList];
    [self requsetCommentQuestionList];
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [self endHeadRefreshing];
    });
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
     dispatch_group_leave(self.group);
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KCityListRequest]) {
            CityListModel *model = (CityListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.cityArray.count > 0) {
                    [self.cityArray removeAllObjects];
                }
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    CityDetailModel *detailModel = model.data[i];
                    LLog(@"%@",detailModel.name);
                    [self.cityArray addObject:detailModel.name];
                }
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }else if ([reqType isEqualToString:KBannerRequest]) {
            BannerListModel *bannerListModel = (BannerListModel *)resObj;
            if (bannerListModel.error_code.integerValue == 0) {
                if (self.pictureArray.count > 0) {
                    [self.pictureArray removeAllObjects];
                     [self.bannerArray removeAllObjects];
                }
                for (NSUInteger i = 0; i < bannerListModel.data.count; ++i){
                    BannerModel *bannerModel = bannerListModel.data[i];
                    LLog(@"%@",bannerModel.imgUrl);
                    [self.pictureArray addObject:[NSString stringWithFormat:@"%@",bannerModel.imgUrl]];
                     [self.bannerArray addObject:bannerModel];

                }
                self.cycleScrollView.imageURLStringsGroup = self.pictureArray;
            }else{
                LLog(@"请求失败:%@",bannerListModel.error_msg);
            }
        }else if ([reqType isEqualToString:KGetNewsListPopInfoRequest]) {
            NewListModel *model = (NewListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.hotNewsListSource.count > 0) {
                    [self.hotNewsListSource removeAllObjects];
                }
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    NewDetailModel *detailModel = model.data[i];
                    [self.hotNewsListSource addObject:detailModel];
                }
                [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }else if ([reqType isEqualToString:KGetNewsListSysNotiRequest]) {
            NewListModel *model = (NewListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.systemNewsListSource.count > 0) {
                    [self.systemNewsListSource removeAllObjects];
                }
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    NewDetailModel *detailModel = model.data[i];
                    [self.systemNewsListSource addObject:detailModel];
                }
                NewDetailModel *model = self.systemNewsListSource.lastObject;
                if (model) {
                    _systemNotificationLabel.text = model.title;
                }
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }else if ([reqType isEqualToString:KGetCommentQuestionListRequest]) {
            CommentQuestionListModel *model = (CommentQuestionListModel *)resObj;
            if (model.error_code.integerValue == 0) {
                if (self.questionListSource.count > 0) {
                    [self.questionListSource removeAllObjects];
                }
                for (NSUInteger i = 0; i < model.data.count; ++i){
                    CommentQuestionModel *detailModel = model.data[i];
                    [self.questionListSource addObject:detailModel];
                }
                 [self.tableView reloadData];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }
    }else{
        LLog(@"请求失败");
    }
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return NO;
}


#pragma mark - delegate && datasource-Banner跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LLog(@"Banner跳转%ld",index);
    ZRSWBannerDetailsController *bannerDetailsVC = [[ZRSWBannerDetailsController alloc] init];
    BannerModel *bannerModel = self.bannerArray[index];
    bannerDetailsVC.bannerModel = bannerModel;
    bannerDetailsVC.hidesBottomBarWhenPushed = YES;
    if (![bannerModel.href isEqualToString:@""] && bannerModel.href != nil ) {
        [self.navigationController pushViewController:bannerDetailsVC animated:YES];
    }
}


#pragma mark - 我要贷款
- (void)loanButtonClck:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TabBarDidClickNotificationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ZRSWNeedLoansController *vc = [[ZRSWNeedLoansController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 公告更多
- (void)moreButtonClck:(UIButton *)button{
    ZRSWNewsListDetailsController *listDetailsVC = [[ZRSWNewsListDetailsController alloc] init];
    listDetailsVC.type = NewListTypeSystemNotification;
    listDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listDetailsVC animated:YES];
    LLog(@"系统公告");
}

#pragma mark - 我要贷款
- (void)triangleButtonClck:(UIButton *)button{
    [self locationCity];
    LLog(@"更多城市");
}


#pragma mark - 热门资讯/常见问题
-(void)getMoreClick:(NSInteger)type title:(NSString *)title{
    if (type == 0) {
        LLog(@"热门资讯");
        ZRSWNewsListDetailsController *listDetailsVC = [[ZRSWNewsListDetailsController alloc] init];
        listDetailsVC.type = NewListTypePopularInformation;
        listDetailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listDetailsVC animated:YES];
    }else if (type == 1){
        LLog(@"常见问题");
        ZRSWQuestionListDetailsController *listDetailsVC = [[ZRSWQuestionListDetailsController alloc] init];
        listDetailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listDetailsVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LLog(@"详情");
    if (indexPath.section == 0) {
        ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
        detailsVC.type = DetailsTypePopularInformation;
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.detailModel = self.hotNewsListSource[indexPath.row];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else if (indexPath.section == 1) {
        ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
        detailsVC.type = DetailsTypeCommentQuestion;
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.questionModel = self.questionListSource[indexPath.row];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
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
        [loanButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateNormal];
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
        _systemNotificationLabel.textColor = [UIColor colorFromRGB:0x333333];
        _systemNotificationLabel.textAlignment = NSTextAlignmentCenter;
        _systemNotificationLabel.font = [UIFont systemFontOfSize:12];
        [_systemNotificationView addSubview:_systemNotificationLabel];

        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(_systemNotificationLabel.right + kUI_WidthS(44) ,kUI_HeightS(15), kUI_WidthS(28), kUI_HeightS(14))];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor colorFromRGB:0x999999] forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        UIButton *moreClickButton = [[UIButton alloc] initWithFrame:CGRectMake(_systemNotificationLabel.right,0, SCREEN_WIDTH - _systemNotificationLabel.right, kUI_HeightS(44))];
        [moreClickButton addTarget:self action:@selector(moreButtonClck:) forControlEvents:UIControlEventTouchUpInside];
        [_systemNotificationView addSubview:moreButton];
        [_systemNotificationView addSubview:moreClickButton];
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreButton.right + kUI_WidthS(5) ,kUI_HeightS(15), kUI_WidthS(12), kUI_HeightS(12))];
        moreImageView.image = [UIImage imageNamed:@"home_notice_arrow"];
        [_systemNotificationView addSubview:moreImageView];
    }
    return _systemNotificationView;
}

- (UIView *)locationView{
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(0,kUI_HeightS(18), kUI_WidthS(120), kUI_HeightS(18))];
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUI_WidthS(15),0, kUI_WidthS(15), kUI_HeightS(18))];
        leftImage.image = [UIImage imageNamed:@"currency_top_position"];
        [_locationView addSubview:leftImage];
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImage.right + kUI_WidthS(4) ,kUI_HeightS(1), kUI_WidthS(64), kUI_HeightS(16))];
        _locationLabel.text = @"北京市";
        _locationLabel.textColor = [UIColor colorFromRGB:0xFFFFFFFF];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = [UIFont systemFontOfSize:16];
        [_locationView addSubview:_locationLabel];
        UIButton *triangleButton = [[UIButton alloc] initWithFrame:CGRectMake(_locationLabel.right + kUI_WidthS(5) ,kUI_HeightS(7), kUI_WidthS(8), kUI_HeightS(5))];
        [triangleButton setImage:[UIImage imageNamed:@"currency_top_triangle"] forState:UIControlStateNormal];
        [triangleButton addTarget:self action:@selector(triangleButtonClck:) forControlEvents:UIControlEventTouchUpInside];
        [_locationView addSubview:triangleButton];
    }
    return _locationView;
}

@end
