//
//  ZRSWBrushFaceLoginController.m
//  ZRSW
//
//  Created by King on 2018/9/24.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBrushFaceLoginController.h"
#import "FaceStreamDetectorViewController.h"
@interface ZRSWBrushFaceLoginController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,FaceDetectorDelegate>
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *headeImageView;
@property (nonatomic, strong) UIButton *faceLoginBtn;
@property (nonatomic, strong) UIButton *toggleLoginModeBtn;

@end

@implementation ZRSWBrushFaceLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TipViewManager showLoading];
    [self.scrollView reloadEmptyDataSet];
    [self setViewHidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.scrollView.emptyDataSetSource = nil;
        [self.scrollView reloadEmptyDataSet];
        [self setViewHidden:NO];
        [TipViewManager dismissLoading];
    });
}

- (void)setViewHidden:(BOOL)hidden{
    self.headView.hidden = hidden;
    self.iconImageView.hidden = hidden;
    self.phoneLabel.hidden = hidden;
    self.headeImageView.hidden = hidden;
    self.faceLoginBtn.hidden = hidden;
    self.toggleLoginModeBtn.hidden = hidden;
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.headView];
    [self.headView addSubview:self.iconImageView];
    [self.headView addSubview:self.phoneLabel];
    [self.scrollView addSubview:self.headeImageView];
    [self.scrollView addSubview:self.faceLoginBtn];
    [self.scrollView addSubview:self.toggleLoginModeBtn];
    self.scrollView.emptyDataSetSource = self;
    self.scrollView.emptyDataSetDelegate = self;
    [self setupLayOut];
}



- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"刷脸登录";
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.height.mas_equalTo(70);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(111);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.mas_equalTo(27);
        make.height.mas_equalTo(16);
    }];

    [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(kUI_HeightS(230));
    }];

    [self.faceLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headeImageView.mas_bottom).offset(60);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(44);
    }];
    [self.toggleLoginModeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceLoginBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(261);
    }];

}


#pragma mark - event
- (void)toggleLoginModeBtnClick {
    LLog(@"切换登录方式");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)faceLoginBtnClick {
    LLog(@"刷脸登录");
//    FaceStreamDetectorViewController *faceVC = [[FaceStreamDetectorViewController alloc]init];
//    faceVC.faceDelegate = self;
//    [self.navigationController pushViewController:faceVC animated:YES];
}

-(void)sendFaceImage:(UIImage *)faceImage{
    self.headeImageView.image = faceImage;
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

}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {

}


#pragma mark - lazy
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
    }
    return _headView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"my_head"];
    }
    return _iconImageView;

}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"185****1169";
        _phoneLabel.textColor = [UIColor colorFromRGB:0xFF1D1D26];
        _phoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _phoneLabel;
}

- (UIImageView *)headeImageView{
    if (!_headeImageView) {
        _headeImageView = [[UIImageView alloc] init];
        _headeImageView.image = [UIImage imageNamed:@"sign_face"];
    }
    return _headeImageView;
}

- (UIButton *)faceLoginBtn {
    if (!_faceLoginBtn) {
        _faceLoginBtn = [ZRSWViewFactoryTool getBlueBtn:@"点击进行刷脸登录" target:self action:@selector(faceLoginBtnClick)];
    }
    return _faceLoginBtn;
}

- (UIButton *)toggleLoginModeBtn {
    if (!_toggleLoginModeBtn) {
        _toggleLoginModeBtn = [self getGrayBtn:@"切换登录方式" action:@selector(toggleLoginModeBtnClick)];
    }
    return _toggleLoginModeBtn;
}


- (UIButton *)getGrayBtn:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorFromRGB:0x666666] forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:YES];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
