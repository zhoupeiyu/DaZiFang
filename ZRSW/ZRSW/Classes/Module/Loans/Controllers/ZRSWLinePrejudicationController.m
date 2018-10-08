//
//  ZRSWLinePrejudicationController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationController.h"
#import "ZRSWLinePrejudicationCells.h"
#import "OrderService.h"

#define KHeaderViewKey          @"KHeaderViewKey"
#define KMainViewKey            @"KMainViewKey"
#define KHeaderViewHeightKey    @"KHeaderViewHeightKey"
#define KMainViewHeightKey      @"KMainViewHeightKey"

#define KFootBtnHeight      60
#define KFootViewHeight     40
#define KHeaderViewHeight   54

@interface ZRSWLinePrejudicationController ()
@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) NSMutableArray *mainViews;
@property (nonatomic, strong) LinePrejudicationUserInfoView *userInfoView;
@property (nonatomic, strong) LinePrejudicationRemarksView *remarkView;
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) NSString *loanPersonName;
@property (nonatomic, strong) NSString *loanPersonSex;
@property (nonatomic, strong) NSString *loanPersonAdd;
@property (nonatomic, strong) NSString *loanPersonPhone;
@property (nonatomic, strong) NSString *loanPersonMoney;
@property (nonatomic, strong) NSString *remarkText;
@property (nonatomic, strong) UploadImagesManager *imageManager;
@property (nonatomic, strong) OrderService *service;
@property (nonatomic, strong) NSMutableArray *preImages;
@end

@implementation ZRSWLinePrejudicationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}
- (void)setupUI {
    [super setupUI];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.alwaysBounceVertical = YES;
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"线上预审";
    [self setLeftBackBarButton];
}

- (void)goBack {
    [super goBack];
}

#pragma mark - action

- (void)back {
    NSUInteger lastIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TabBarDidClickNotificationKey];
    [self.tabBarController setSelectedIndex:lastIndex];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)footBtnAction {
    if ([self checkUserInfo]) {
        WS(weakSelf);
        
        
        NSMutableArray *allImages = [[NSMutableArray alloc] init];
        __block NSMutableArray *imageCount = [[NSMutableArray alloc] init];
        __block NSMutableArray *imageAttri = [[NSMutableArray alloc] init];
    
        for (NSInteger index = 0; index < self.mainViews.count; index ++) {
            LinePrejudicationImagesView *imageView = (LinePrejudicationImagesView *)self.mainViews[index];
            NSMutableArray *imageArr = [imageView getResultImages];
            if (imageArr.count > 0) {
                [allImages addObjectsFromArray:imageArr];
                [imageCount addObject:@(imageArr.count)];
            }
            else {
                [imageCount addObject:@(0)];
            }
        }
        if (allImages.count == 0 || [imageCount containsObject:@(0)]) {
            [TipViewManager showToastMessage:@"至少上传一张图片"];
            return;
        }
        [TipViewManager showLoadingWithText:@"图片上传中，请耐心等待..."];
        [self.imageManager uploadImagesWithImagesArray:allImages completeBlock:^(NSMutableArray * _Nullable imageUrls) {
            [TipViewManager dismissLoading];
            [TipViewManager showLoadingWithText:@"数据上传中，请耐心等待..."];
            NSMutableArray *allImageUrls = [imageUrls copy]; // URL 数组
            if (allImages.count != imageUrls.count) {
                [TipViewManager dismissLoading];
                [TipViewManager showToastMessage:@"上传图片失败，请重新上传!"];
                return;
            }
            for (NSInteger count = 0; count < imageCount.count; count ++) { // 遍历存放个数的数组
                ZRSWOrderLoanInfoCondition *loanCondition = (ZRSWOrderLoanInfoCondition *)weakSelf.loanCondition[count];// 获取对象
                NSString *loanConditionName = loanCondition.title; // 获取对象标题
                NSInteger imageNum = ((NSNumber *)imageCount[count]).integerValue;// 个数
                NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];// 需要移除的数组
                NSMutableDictionary *attri = [NSMutableDictionary dictionary]; // URL和标题的字典
                for (NSInteger index = 0; index < imageNum; index ++) {
                    [imageUrlArray addObject:allImageUrls[index]]; // 获取URL数组的个数
                }
                NSString *imageURL = [imageUrlArray componentsJoinedByString:@","];//#为分隔符
                [attri setObject:imageURL forKey:loanConditionName];
                [imageAttri addObject:attri];
                [imageUrlArray removeObjectsInArray:allImageUrls];
            }
            [self.service createOrderLoanId:weakSelf.loanId loanUserName:weakSelf.loanPersonName loanUserSex:weakSelf.loanPersonSex.integerValue loanUserAddress:weakSelf.loanPersonAdd loanUserPhone:weakSelf.loanPersonPhone loanMoney:weakSelf.loanPersonMoney remark:weakSelf.remarkText condition:imageAttri delegate:weakSelf];
        }];
    }
}
- (BOOL)checkUserInfo {
    self.loanPersonName =   [self.userInfoView loanPersonName];
    self.loanPersonSex =    [self.userInfoView loanPersonSex];
    self.loanPersonAdd =    [self.userInfoView loanPersonAdd];
    self.loanPersonPhone =  [self.userInfoView loanPersonPhone];
    self.loanPersonMoney =  [self.userInfoView loanPersonMoney];
    self.remarkText =       [self.remarkView remarkText];
    
    NSString *errorString = @"";
    if (self.loanPersonName.length == 0) {
        errorString = @"请输入实际贷款人姓名";
    }
    else if (self.loanPersonSex.length == 0) {
        errorString = @"请选择性别";
    }
    else if (self.loanPersonAdd.length == 0) {
        errorString = @"请填写贷款人地址";
    }
    else if (self.loanPersonPhone.length == 0) {
        errorString = @"请输入贷款人电话";
    }
    else if (self.loanPersonMoney.length == 0) {
        errorString = @"请输入贷款金额";
    }
    if (errorString.length != 0) {
        [TipViewManager showToastMessage:errorString];
        return NO;
    }
    else {
        return YES;
    }
}
- (void)setLoanCondition:(NSArray<ZRSWOrderLoanInfoCondition *> *)loanCondition {
    _loanCondition = loanCondition;
    [self.headerTitles removeAllObjects];
    [self.contentViews removeAllObjects];
    [self.mainViews removeAllObjects];
    self.contentHeight = 0.0f;
    [self.mainViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        [view removeFromSuperview];
    }];
    {// 添加第一个view数组
        CGFloat headerH = 10;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[self getHeaderView] forKey:KHeaderViewKey];
        [dic setObject:self.userInfoView forKey:KMainViewKey];
        [dic setObject:@(headerH) forKey:KHeaderViewHeightKey];
        [dic setObject:@([LinePrejudicationUserInfoView viewHeight]) forKey:KMainViewHeightKey];
        [self.contentViews addObject:dic];
        self.contentHeight += headerH;
        self.contentHeight += [LinePrejudicationUserInfoView viewHeight];
    }
    {
        // 常见header标题数组
        for (ZRSWOrderLoanInfoCondition *conditionModel in loanCondition) {
            [self.headerTitles addObject:conditionModel.title];
        }
        [_headerTitles addObject:@"备注"];
        // 添加View
        for (NSInteger index = 0; index < self.headerTitles.count; index ++) {
            NSString *title = self.headerTitles[index];
            UIView *headerView = [self getHeaderView:title tag:index needBtn:index != self.headerTitles.count - 1];
            UIView *contentView = index != self.headerTitles.count - 1 ? [self getImagesView] : self.remarkView;
            CGFloat contentHeight = index != self.headerTitles.count - 1 ? [LinePrejudicationImagesView viewHeight] : [LinePrejudicationRemarksView viewHeight];
            CGFloat headerHeight = KHeaderViewHeight;
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:headerView forKey:KHeaderViewKey];
            [dic setObject:contentView forKey:KMainViewKey];
            [dic setObject:@(headerHeight) forKey:KHeaderViewHeightKey];
            [dic setObject:@(contentHeight) forKey:KMainViewHeightKey];
            [self.contentViews addObject:dic];
            if (index != self.headerTitles.count - 1) {
                [self.mainViews addObject:contentView];
            }
            self.contentHeight += headerHeight;
            self.contentHeight += contentHeight;
        }
        
    }
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[self getHeaderView] forKey:KHeaderViewKey];
        [dic setObject:self.footView forKey:KMainViewKey];
        [dic setObject:@(0) forKey:KHeaderViewHeightKey];
        [dic setObject:@(KFootViewHeight) forKey:KMainViewHeightKey];
        [self.contentViews addObject:dic];
        self.contentHeight += KFootViewHeight;
    }
    [self.view addSubview:self.footBtn];
    [self setupLayOut];
}

- (void)setupLayOut {
    [super setupLayOut];
    __block UIView *lastView = nil;
    [self.contentViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        CGFloat headerViewHeight = ((NSNumber *)dic[KHeaderViewHeightKey]).integerValue;
        CGFloat mainViewHeight = ((NSNumber *)dic[KMainViewHeightKey]).integerValue;
        UIView *headerView = (UIView *)dic[KHeaderViewKey];
        UIView *mainView = (UIView *)dic[KMainViewKey];
        if (lastView) {
            [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(headerViewHeight);
                make.width.mas_equalTo(SCREEN_WIDTH);
            }];
            
        }
        else {
            [headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(headerViewHeight);
                make.width.mas_equalTo(SCREEN_WIDTH);
            }];
        }
        [mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerView.mas_bottom);
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(mainViewHeight);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        lastView = mainView;
    }];
    [self.footBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(KFootBtnHeight);
    }];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.contentHeight + KFootBtnHeight);
}
#pragma mark - action
- (void)exampleAction:(UIButton *)btn {
    NSArray *imageURLs = self.loanCondition[btn.tag].exampleImgUrls;
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    ac.configuration.maxSelectCount = 5;
    ac.configuration.maxPreviewCount = 10;
    ac.configuration.navBarColor = [UIColor blackColor];
    ac.sender = self;
    //预览网络图片
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *url in imageURLs) {
        NSDictionary *dic = GetDictForPreviewPhoto(url, ZLPreviewPhotoTypeURLImage);
        [images addObject:dic];
    }
    [ac previewPhotos:images index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
        
    }];
}

- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KCreateOrderRequest]) {
            ZRSWCreateModel *model = (ZRSWCreateModel *)resObj;
            if (model.error_code.integerValue == 0) {
                [TipViewManager showToastMessage:@"资料上传成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
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
        [_footBtn addTarget:self action:@selector(footBtnAction) forControlEvents:UIControlEventTouchUpInside];
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
        [self.scrollView addSubview:_footView];
    }
    return _footView;
}
- (NSMutableArray *)headerTitles {
    if (!_headerTitles) {
        _headerTitles = [[NSMutableArray alloc] init];
        
    }
    return _headerTitles;
}
- (UIView *)getHeaderView:(NSString *)title tag:(NSInteger)tag needBtn:(BOOL)isNeedBtn{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KHeaderViewHeight);
    [self.view addSubview:bgView];
    
    UIView *bottomBGView = [[UIView alloc] init];
    bottomBGView.backgroundColor = [UIColor whiteColor];
    bottomBGView.frame = CGRectMake(0, KHeaderViewHeight - 44, SCREEN_WIDTH, 44);
    [bgView addSubview:bottomBGView];
    
    UIImageView *redView = [[UIImageView alloc] init];
    redView.image = [UIImage imageNamed:@"pretrial_title_instructions"];
    [bottomBGView addSubview:redView];
    [redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(bottomBGView.mas_centerY);
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
    btn.hidden = !isNeedBtn;
    
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

- (UIView *)getHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:headerView];
    return headerView;
}

- (LinePrejudicationImagesView *)getImagesView {
    LinePrejudicationImagesView *imagesView = [[LinePrejudicationImagesView alloc] init];
    imagesView.presentedVC = self;
    [self.scrollView addSubview:imagesView];
    return imagesView;
}
- (LinePrejudicationUserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[LinePrejudicationUserInfoView alloc] init];
        [self.scrollView addSubview:_userInfoView];
    }
    return _userInfoView;
}
- (LinePrejudicationRemarksView *)remarkView {
    if (!_remarkView) {
        _remarkView = [[LinePrejudicationRemarksView alloc] init];
        [self.scrollView addSubview:_remarkView];
    }
    return _remarkView;
}
- (NSMutableArray *)contentViews {
    if (!_contentViews) {
        _contentViews = [[NSMutableArray alloc] init];
    }
    return _contentViews;
}
- (NSMutableArray *)mainViews {
    if (!_mainViews) {
        _mainViews = [[NSMutableArray alloc] init];
    }
    return _mainViews;
}
- (UploadImagesManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [UploadImagesManager sharedInstance];
        _imageManager.imageType = UploadImageTypeJpg;
        _imageManager.name = @"file";
        _imageManager.url = @"api/user/uploadFile";
    }
    return _imageManager;
}
- (OrderService *)service {
    if (!_service) {
        _service = [[OrderService alloc] init];
    }
    return _service;
}
@end
