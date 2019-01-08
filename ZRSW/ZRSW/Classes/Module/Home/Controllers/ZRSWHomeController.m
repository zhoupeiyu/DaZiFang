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
#import "ZRSWSelectTheCityController.h"
#import "ZRSWLoginController.h"

@interface ZRSWHomeController ()<SDCycleScrollViewDelegate,BaseNetWorkServiceDelegate,ZRSWHomeNewsHeaderViewDelegate,LocationManagerDelegate>
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
@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong)  dispatch_group_t group;
// 签到签退
@property (nonatomic, strong) UIButton *registrationBtn;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) SignType currentSignType;
@end


@implementation ZRSWHomeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkSignStates];
}
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
    [LocationManager sharedInstance].delegate = self;
    [TipViewManager showLoading];
    self.group = dispatch_group_create();
    [self requsetCityList];
    [self requsetBannerList];
    [self requsetSystemNotificationList];
    [self requsetPopularInformationList];
    [self requsetCommentQuestionList];
    [self getLocationCity];
    WS(weakSelf);
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        for (CityDetailModel *city in weakSelf.cityArray ) {
            if ([weakSelf.locationCity isEqualToString:city.name]) {
                weakSelf.locationLabel.text = weakSelf.locationCity;
                NSDictionary *cityDic = nil;
                cityDic = [city yy_modelToJSONObject];
                [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:CurrentLocationKey];
                break;
            }else if ([city.name isEqualToString:@"北京市"]){
                weakSelf.locationLabel.text = @"北京市";
                NSDictionary *cityDic = nil;
                cityDic = [city yy_modelToJSONObject];
                [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:CurrentLocationKey];
            }
        }
        [TipViewManager dismissLoading];
    });
    [self setupRegistration];
}


- (void)setupConfig {
    [super setupConfig];
    self.navigationItem.title = @"中融盛旺";
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.locationView];
    self.navigationItem.leftBarButtonItem = leftBar;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLocationCity:) name:ChangeCityNotification object:nil];

}


#pragma mark - 签到签退按钮

- (void)setupRegistration {
    [self setRightBarButtonWithText:@"签到"];

    [self.rightBarButton addTarget:self action:@selector(updateUserLocation) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateRightItem:(BOOL)registration {
    if (!registration) {
        [self.rightBarButton setTitle:@"签退" forState:UIControlStateNormal];
        [self.rightBarButton setTitle:@"签退" forState:UIControlStateHighlighted];
    }
    else {
        [self.rightBarButton setTitle:@"签到" forState:UIControlStateNormal];
        [self.rightBarButton setTitle:@"签到" forState:UIControlStateHighlighted];

    }
}
- (void)setUpTableView{
    self.tableView.tableHeaderView = self.headerView;
    [self enableRefreshHeader:YES];
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

- (void)checkSignStates {
    UserModel *model = [UserModel getCurrentModel];
    if (model) {
        [[[UserService alloc] init] checkSignStates:model.data.id delegate:self];
    }
    
}
- (void)updateUserLocation {
    if (![UserModel hasLogin]) {
        [ZRSWLoginController showLoginViewController];
        return;
    }
    if (!self.location) {
        [TipViewManager showToastMessage:@"请检查定位！"];
        return;
    }
    SignType signType = SignTypeRegistration;
    if ([self.rightBarButton.currentTitle isEqualToString:@"签退"]) {
        signType = SignTypeSignOut;
        [TipViewManager showLoadingWithText:@"签退中,请稍后..."];
        self.currentSignType = SignTypeSignOut;
    }
    else {
        [TipViewManager showLoadingWithText:@"签到中,请稍后..."];
        signType = SignTypeRegistration;
        self.currentSignType = SignTypeRegistration;
    }
    [[[UserService alloc] init] updateUserLocation:@(self.location.coordinate.longitude).stringValue latitude:@(self.location.coordinate.latitude).stringValue signType:signType delegate:self];
}
- (void)getLocationCity{
    WS(weakSelf);
    if ([CLLocationManager locationServicesEnabled]){
        //system location enabled
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        if (authorizationStatus==kCLAuthorizationStatusAuthorizedWhenInUse||authorizationStatus==kCLAuthorizationStatusAuthorizedAlways){
//            dispatch_group_enter(self.group);
            [[LocationManager sharedInstance] getCityLocationSuccess:^(id result, CLLocation *location) {
//                dispatch_group_leave(self.group);
                if (result) {
                    weakSelf.locationCity = [NSString stringWithFormat:@"%@",result];
                }
                weakSelf.location = location;
            } failure:^(id error) {
//                dispatch_group_leave(self.group);
                LLog(@"定位失败%@",error);
            }];
        }else if (authorizationStatus == kCLAuthorizationStatusNotDetermined){
            LLog(@"对于这个应用程序，用户还没有做出选择");
//            [self getLocationCity];
        }else{
            //定位服务开启
            [TipViewManager showAlertControllerWithTitle:@"请去设置中打开定位服务,允许获取您的位置" message:@"若不允许,你将无法使用显示当前位置以及当前位置签到签退等相关功能." preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"知道了" handler:nil controller:self completion:nil];
        }
    }else{
        [TipViewManager showAlertControllerWithTitle:@"请去设置中打开定位服务,允许获取您的位置" message:@"若不允许,你将无法使用显示当前位置以及当前位置签到签退等相关功能." preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"知道了" handler:nil controller:self completion:nil];
    }
}

- (void)didChangeAuthorizationStatus{
    [self getLocationCity];
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
    [self requsetCityList];
    [self requsetBannerList];
    [self requsetPopularInformationList];
    [self requsetSystemNotificationList];
    [self requsetCommentQuestionList];
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        [self endHeadRefreshing];
    });
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUpdateUserLocationRequest]) {
            [TipViewManager dismissLoading];
            BaseModel *baseModel = (BaseModel *)resObj;
            if (baseModel.error_code.integerValue == 0) {
                if (self.currentSignType == SignTypeRegistration) {
                    [TipViewManager showToastMessage:@"签到成功啦^_^"];
                }
                else {
                    [TipViewManager showToastMessage:@"签退成功啦^_^"];
                }
                [self updateRightItem:self.currentSignType == SignTypeSignOut];
            }
            else {
                [TipViewManager showToastMessage:baseModel.error_msg];
            }
        }else if ([reqType isEqualToString:KCheckUserSignStatesRequest]) {
            SignModel *model = (SignModel *)resObj;
            if (model.error_code.integerValue == 0) {
                BOOL regis = model.data.signIn.boolValue == NO;
                BOOL signOut = model.data.signOut.boolValue == NO;
                [self.rightBarButton setTitle:@"签到" forState:UIControlStateNormal];
                [self.rightBarButton setTitle:@"签到" forState:UIControlStateHighlighted];
                if (regis) {
                    [self.rightBarButton setTitle:@"签到" forState:UIControlStateNormal];
                    [self.rightBarButton setTitle:@"签到" forState:UIControlStateHighlighted];
                }
                if (!regis && signOut) {
                    [self.rightBarButton setTitle:@"签退" forState:UIControlStateNormal];
                    [self.rightBarButton setTitle:@"签退" forState:UIControlStateHighlighted];
                }
            }
        }else{
            dispatch_group_leave(self.group);
            if ([reqType isEqualToString:KCityListRequest]) {
                CityListModel *model = (CityListModel *)resObj;
                if (model.error_code.integerValue == 0) {
                    if (self.cityArray.count > 0) {
                        [self.cityArray removeAllObjects];
                    }
                    for (NSUInteger i = 0; i < model.data.count; ++i){
                        CityDetailModel *detailModel = model.data[i];
                        LLog(@"%@",detailModel.name);
                        [self.cityArray addObject:detailModel];
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
                    [self.hotNewsListSource addObjectsFromArray:model.data];
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
                    [self.systemNewsListSource addObjectsFromArray:model.data];
                    NewDetailModel *model = self.systemNewsListSource.firstObject;
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
                    [self.questionListSource addObjectsFromArray:model.data];
                    [self.tableView reloadData];
                }else{
                    LLog(@"请求失败:%@",model.error_msg);
                }
            }
        }
    }else{
        if ([reqType isEqualToString:KCheckUserSignStatesRequest]){
        }else  if ([reqType isEqualToString:KUpdateUserLocationRequest]){
            [TipViewManager dismissLoading];
        }else{
            dispatch_group_leave(self.group);
        }
        LLog(@"%@请求失败",reqType);
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
- (void)getMoreSystemNotification{
    ZRSWNewsListDetailsController *listDetailsVC = [[ZRSWNewsListDetailsController alloc] init];
    listDetailsVC.type = NewListTypeSystemNotification;
    listDetailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listDetailsVC animated:YES];
    LLog(@"系统公告");
}

#pragma mark - 切换城市
- (void)goToSelectTheCityController{
    LLog(@"切换城市");
    ZRSWSelectTheCityController *selectTheCityVC = [[ZRSWSelectTheCityController alloc] init];
    selectTheCityVC.cityArray = self.cityArray;
    selectTheCityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectTheCityVC animated:YES];
}

- (void)changeLocationCity:(NSNotification *)notification {
     CityDetailModel *city = notification.object;
    self.locationLabel.text = city.name;
    if (city) {
        NSDictionary *cityDic = nil;
        cityDic = [city yy_modelToJSONObject];
        [[NSUserDefaults standardUserDefaults] setObject:cityDic forKey:CurrentLocationKey];
    }
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

-(void)goToMoreSystemNotificationDetailsVC{
    ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
    detailsVC.type = DetailsTypeSystemNotification;
    NewDetailModel *detailModel = self.systemNewsListSource.firstObject;
    detailsVC.detailModel = detailModel;
    detailsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailsVC animated:YES];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LLog(@"详情");
    if (indexPath.section == 0) {
        ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
        detailsVC.type = DetailsTypePopularInformation;
        detailsVC.hidesBottomBarWhenPushed = YES;
        NewDetailModel *detailModel = self.hotNewsListSource[indexPath.row];
        detailsVC.detailModel = detailModel;
        detailModel.readers = [NSString stringWithFormat:@"%ld",([detailModel.readers integerValue]+1)];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else if (indexPath.section == 1) {
        ZRSWNewAndQuestionDetailsController *detailsVC = [[ZRSWNewAndQuestionDetailsController alloc] init];
        detailsVC.type = DetailsTypeCommentQuestion;
        detailsVC.hidesBottomBarWhenPushed = YES;
        CommentQuestionModel *questionModel = self.questionListSource[indexPath.row];
        detailsVC.questionModel = questionModel;
        questionModel.readers = [NSString stringWithFormat:@"%ld",([questionModel.readers integerValue]+1)];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    }];

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

//- (UIView *)loanView{
//    if (!_loanView) {
//        CGFloat height = kUI_HeightS(135);
//        _loanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cycleScrollView.bottom + kUI_HeightS(10), SCREEN_WIDTH, height)];
//        _loanView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(126))/2 , kUI_HeightS(15), kUI_WidthS(126), kUI_HeightS(15))];
//        titleLabel.text = @"最高可贷款（元）";
//        titleLabel.textColor = [UIColor colorFromRGB:0x666666];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font = [UIFont systemFontOfSize:15];
//        [_loanView addSubview:titleLabel];
//        _loanAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(205))/2 , titleLabel.bottom + kUI_HeightS(16), kUI_WidthS(205), kUI_HeightS(36))];
//        _loanAmountLabel.textColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:_loanAmountLabel.bounds andColors:@[[UIColor colorFromRGB:0xFFFF5153],[UIColor colorFromRGB:0xFFFF806B]]];;
//        _loanAmountLabel.textAlignment = NSTextAlignmentLeft;
//        _loanAmountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:36];
//        NSShadow *shadow = [[NSShadow alloc] init];
//        shadow.shadowBlurRadius = 4;
//        shadow.shadowColor = [UIColor colorWithRed:255/255.0 green:88/255.0 blue:87/255.0 alpha:0.3];
//        shadow.shadowOffset = CGSizeMake(0,2);
//        _loanAmountLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"10,000,000"attributes:@{NSShadowAttributeName: shadow}];
//
//        [_loanView addSubview:_loanAmountLabel];
//        UIButton *loanButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(226))/2 , _loanAmountLabel.bottom + kUI_HeightS(12), kUI_WidthS(226), kUI_HeightS(29))];
//        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x4771F2]] forState:UIControlStateNormal];
//        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x2341BF]] forState:UIControlStateHighlighted];
//        [loanButton.layer setCornerRadius:5.0];
//        [loanButton.layer setMasksToBounds:YES];
//        [loanButton setTitle:@"我要贷款" forState:UIControlStateNormal];
//        [loanButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateNormal];
//        [loanButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
//        [loanButton addTarget:self action:@selector(loanButtonClck:) forControlEvents:UIControlEventTouchUpInside];
//        [_loanView addSubview:loanButton];
//    }
//    return _loanView;
//}



- (UIView *)loanView{
    if (!_loanView) {
        CGFloat height = kUI_HeightS(135);
        _loanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cycleScrollView.bottom + kUI_HeightS(10), SCREEN_WIDTH, height)];
        _loanView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
        UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(200))/2 , kUI_HeightS(20), kUI_WidthS(200), kUI_HeightS(18))];
        titleLabel1.text = @"汇集业内热门贷款产品";
        titleLabel1.textColor = [UIColor colorFromRGB:0x474455];
        titleLabel1.textAlignment = NSTextAlignmentCenter;
        titleLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [_loanView addSubview:titleLabel1];
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(200))/2 , titleLabel1.bottom + kUI_HeightS(15), kUI_WidthS(200), kUI_HeightS(18))];
        titleLabel2.text = @"懂您所需，贷您所想！";
        titleLabel2.textColor = [UIColor colorFromRGB:0x474455];
        titleLabel2.textAlignment = NSTextAlignmentCenter;
        titleLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [_loanView addSubview:titleLabel2];
        UIButton *loanButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(226))/2 , titleLabel2.bottom + kUI_HeightS(15), kUI_WidthS(226), kUI_HeightS(29))];
        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x4771F2]] forState:UIControlStateNormal];
        [loanButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x2341BF]] forState:UIControlStateHighlighted];
        [loanButton.layer setCornerRadius:5.0];
        [loanButton.layer setMasksToBounds:YES];
        [loanButton setTitle:@"查看贷款产品" forState:UIControlStateNormal];
        [loanButton setTitleColor:[UIColor colorFromRGB:0xFFFFFF] forState:UIControlStateNormal];
        [loanButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
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
        UIImageView *leftTitle = [[UIImageView alloc] initWithFrame:CGRectMake(kUI_WidthS(15),kUI_HeightS(13), 78, 18)];
        leftTitle.image = [UIImage imageNamed:@"home_notice"];
        [_systemNotificationView addSubview:leftTitle];
        _systemNotificationLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -kUI_WidthS(168))/2 ,0, kUI_WidthS(168), height)];
        _systemNotificationLabel.textColor = [UIColor colorFromRGB:0x333333];
        _systemNotificationLabel.textAlignment = NSTextAlignmentCenter;
        _systemNotificationLabel.font = [UIFont systemFontOfSize:12];
        _systemNotificationLabel.userInteractionEnabled = YES;
        WS(weakSelf);
        [_systemNotificationLabel addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
            [weakSelf goToMoreSystemNotificationDetailsVC];
        }];
        [_systemNotificationView addSubview:_systemNotificationLabel];

        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(_systemNotificationLabel.right + kUI_WidthS(44) ,kUI_HeightS(15), kUI_WidthS(28), kUI_HeightS(14))];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:[UIColor colorFromRGB:0x999999] forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        UIButton *moreClickButton = [[UIButton alloc] initWithFrame:CGRectMake(_systemNotificationLabel.right,0, SCREEN_WIDTH - _systemNotificationLabel.right, kUI_HeightS(44))];
        [moreClickButton addTarget:self action:@selector(getMoreSystemNotification) forControlEvents:UIControlEventTouchUpInside];
        [_systemNotificationView addSubview:moreButton];
        [_systemNotificationView addSubview:moreClickButton];
        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(moreButton.right + kUI_WidthS(5) ,kUI_HeightS(15),12,12)];
        moreImageView.image = [UIImage imageNamed:@"home_notice_arrow"];
        [_systemNotificationView addSubview:moreImageView];
    }
    return _systemNotificationView;
}

- (UIView *)locationView{
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(0,18,120,18)];
        WS(weakSelf);
        [_locationView addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
            [weakSelf goToSelectTheCityController];
        }];
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,15,18)];
        leftImage.image = [UIImage imageNamed:@"currency_top_position"];
        [_locationView addSubview:leftImage];
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImage.right+4 ,1,64,16)];
        _locationLabel.text = @"北京市";
        _locationLabel.textColor = [UIColor colorFromRGB:0xFFFFFFFF];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = [UIFont systemFontOfSize:16];
        [_locationView addSubview:_locationLabel];
        UIButton *triangleButton = [[UIButton alloc] initWithFrame:CGRectMake(_locationLabel.right + 5,7, 8, 5)];
        [triangleButton setImage:[UIImage imageNamed:@"currency_top_triangle"] forState:UIControlStateNormal];
        [triangleButton addTarget:self action:@selector(goToSelectTheCityController) forControlEvents:UIControlEventTouchUpInside];
        [_locationView addSubview:triangleButton];
    }
    return _locationView;
}

@end
