//
//  ZRSWLinePrejudicationController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/27.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWLinePrejudicationController.h"
#import "ZRSWLinePrejudicationCells.h"

#define KFootBtnHeight      60
#define KFootViewHeight     40
#define KHeaderViewHeight   54

@interface ZRSWLinePrejudicationController ()

@property (nonatomic, strong) UIButton *footBtn;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray *headerTitles;
@property (nonatomic, strong) LinePrejudicationUserInfoCell *userInfoCell;
@property (nonatomic, strong) LinePrejudicationImagesCell *residenceBookCell;
@property (nonatomic, strong) LinePrejudicationImagesCell *ipCardCell;
@property (nonatomic, strong) LinePrejudicationImagesCell *houseCardCell;
@property (nonatomic, strong) LinePrejudicationRemarksCell *remarkCell;

@property (nonatomic, strong) NSString *loanPersonName;
@property (nonatomic, strong) NSString *loanPersonSex;
@property (nonatomic, strong) NSString *loanPersonAdd;
@property (nonatomic, strong) NSString *loanPersonPhone;
@property (nonatomic, strong) NSString *loanPersonMoney;
@property (nonatomic, strong) NSString *remarkText;
@property (nonatomic, strong) NSMutableArray *residenceBookImages;
@property (nonatomic, strong) NSMutableArray *ipCardImages;
@property (nonatomic, strong) NSMutableArray *houseCardImages;

@end

@implementation ZRSWLinePrejudicationController

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
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
    [super goBack];
}

#pragma mark - action

- (void)footBtnAction {
    if ([self checkUserInfo]) {
        
    }
}
- (BOOL)checkUserInfo {
    self.loanPersonName =   [self.userInfoCell loanPersonName];
    self.loanPersonSex =    [self.userInfoCell loanPersonSex];
    self.loanPersonAdd =    [self.userInfoCell loanPersonAdd];
    self.loanPersonPhone =  [self.userInfoCell loanPersonPhone];
    self.loanPersonMoney =  [self.userInfoCell loanPersonMoney];
    self.remarkText =       [self.remarkCell remarkText];
    self.residenceBookImages = [self.residenceBookCell getResultImages];
    self.ipCardImages = [self.ipCardCell getResultImages];
    self.houseCardImages = [self.houseCardCell getResultImages];
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
    else if (self.residenceBookImages.count == 0) {
        errorString = @"请选择户口本照片";
    }
    else if (self.ipCardImages.count == 0) {
        errorString = @"请选择身份证照片";
    }
    else if (self.houseCardImages.count == 0) {
        errorString = @"请选择房产证照片";
    }
    if (errorString.length != 0) {
        [TipViewManager showToastMessage:errorString];
        return NO;
    }
    else {
        return YES;
    }
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
    
    if (indexPath.section == 0) {
        LinePrejudicationUserInfoCell *userInfoCell = [LinePrejudicationUserInfoCell getCellWithTableView:tableView];
        self.userInfoCell = userInfoCell;
        return userInfoCell;
    }
    else if (indexPath.section == 1) {
        LinePrejudicationImagesCell *cell = [LinePrejudicationImagesCell getImageCell:tableView];
        cell.presentedVC = self;
        self.residenceBookCell = cell;
        return cell;
    }
    else if (indexPath.section == 2) {
        LinePrejudicationImagesCell *cell = [LinePrejudicationImagesCell getImageCell:tableView];
        cell.presentedVC = self;
        self.ipCardCell = cell;
        return cell;
    }
    else if (indexPath.section == 3) {
        LinePrejudicationImagesCell *cell = [LinePrejudicationImagesCell getImageCell:tableView];
        cell.presentedVC = self;
        self.houseCardCell = cell;
        return cell;
    }
    else if (indexPath.section == 4) {
        LinePrejudicationRemarksCell *remarksCell = [LinePrejudicationRemarksCell getCellWithTableView:tableView];
        self.remarkCell = remarksCell;
        return remarksCell;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LinePrejudicationUserInfoCell cellHeight];
    }
    else if (indexPath.section == 4) {
        return [LinePrejudicationRemarksCell cellHeight];
    }
    else {
        return [LinePrejudicationImagesCell cellHeight];
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
        return [self getHeaderView:title tag:section needBtn:section == 4];
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
- (UIView *)getHeaderView:(NSString *)title tag:(NSInteger)tag needBtn:(BOOL)isNeedBtn{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KHeaderViewHeight);
    
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
@end
