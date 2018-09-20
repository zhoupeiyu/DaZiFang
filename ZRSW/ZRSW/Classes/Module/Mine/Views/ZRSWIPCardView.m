//
//  ZRSWIPCardView.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWIPCardView.h"

@interface ZRSWIPCardView ()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *fristImageView;
@property (nonatomic, strong) UIButton *secondImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *fristContentLbl;
@property (nonatomic, strong) UILabel *secondContentLbl;

@property (nonatomic, assign) IPCardViewType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *secondContent;
@property (nonatomic, strong) NSString *fristContent;
@property (nonatomic, assign) BOOL isNeedBottomLine;
@property (nonatomic, strong) BaseViewController *presentVC;
@property (nonatomic, assign) BOOL fristImageSelected;
@property (nonatomic, assign) BOOL secondImageSelected;

@end

@implementation ZRSWIPCardView

+ (ZRSWIPCardView *)getIPCardViewWithType:(IPCardViewType)type title:(NSString *)title fristViewContent:(NSString *)fristContent secondContent:(NSString *)secondContent isNeedBottomLine:(BOOL)isNeedBottomLine presentVC:(BaseViewController *)presentVC {
    ZRSWIPCardView *ipCardView  = [[ZRSWIPCardView alloc] init];
    ipCardView.title = title;
    ipCardView.type = type;
    ipCardView.fristContent = fristContent;
    ipCardView.secondContent = secondContent;
    ipCardView.isNeedBottomLine = isNeedBottomLine;
    ipCardView.presentVC = presentVC;
    return ipCardView;
}

+ (CGFloat)viewHeight:(IPCardViewType)type {
    if (type == IPCardViewTypePerson) {
        return 170;
    }
    else {
        return 215;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)setupUI {
    [self addSubview:self.fristImageView];
    [self addSubview:self.secondImageView];
    [self addSubview:self.fristContentLbl];
    [self addSubview:self.secondContentLbl];
    [self addSubview:self.titleLbl];
    [self addSubview:self.lineView];
}
#pragma mark - event

- (void)setType:(IPCardViewType)type {
    _type = type;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 2 * 30, 24));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
    if (type == IPCardViewTypePerson) {
        self.fristContentLbl.hidden = NO;
        self.secondContentLbl.hidden = NO;
        self.secondImageView.hidden = NO;
        CGFloat imageW = 150;
        CGFloat imageH = 110;
        CGFloat imageM = 10;
        CGFloat imageL = (SCREEN_WIDTH - 2 * imageW - imageM) * 0.5;
        [self.fristImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageL);
            make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(imageW, imageH));
        }];
        [self.fristContentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.fristImageView.mas_centerX);
            make.bottom.mas_equalTo(self.fristImageView.mas_bottom).offset(-13);
        }];
        [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.fristImageView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.fristImageView.mas_top);
            make.size.mas_equalTo(CGSizeMake(imageW, imageH));
        }];
        [self.secondContentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.secondImageView.mas_centerX);
            make.bottom.mas_equalTo(self.secondImageView.mas_bottom).offset(-13);
        }];
    }
    else {
        self.fristContentLbl.hidden = YES;
        self.secondContentLbl.hidden = YES;
        self.secondImageView.hidden = YES;
        [self.fristImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(10);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(150, 150));
        }];
    }
    [self setupContent:type];
}

- (void)setupContent:(IPCardViewType)type {
    if (type == IPCardViewTypePerson) {
        [self.fristImageView setImage:[UIImage imageNamed:@"authentication_button_name"] forState:UIControlStateNormal];
        [self.secondImageView setImage:[UIImage imageNamed:@"authentication_button_name"] forState:UIControlStateNormal];
    }
    else {
         [self.fristImageView setImage:[UIImage imageNamed:@"authentication_button_enterprise"] forState:UIControlStateNormal];
    }
}

- (CGFloat)row {
    return 3.5;
}
- (void)setFristContent:(NSString *)fristContent {
    _fristContent = fristContent;
    self.fristContentLbl.text = fristContent;
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:fristContent];
//    self.fristContentLbl.attributedText = attr;
//    [self.fristContentLbl setRowSpace:[self row]];
}

- (void)setSecondContent:(NSString *)secondContent {
    _secondContent = secondContent;
    self.secondContentLbl.text = secondContent;
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:secondContent];
//    self.secondContentLbl.attributedText = attr;
//    [self.secondContentLbl setRowSpace:[self row]];
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}
- (void)setIsNeedBottomLine:(BOOL)isNeedBottomLine {
    _isNeedBottomLine = isNeedBottomLine;
    self.lineView.hidden = !isNeedBottomLine;
}
- (NSMutableArray *)getSelectedImages {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    if (self.fristImageSelected) {
        UIImage *image = self.fristImageView.currentImage;
        [images addObject:image];
    }
    if (self.secondImageSelected) {
        UIImage *image = self.secondImageView.currentImage;
        [images addObject:image];
    }
    return images;
}
#pragma mark - Action

- (void)selectedAction:(UIButton *)btn {
    if (btn.tag == 1) { // 左边点击
        WS(weakSelf);
        [[PhotoManager sharedInstance] showPhotoPickForMaxCount:1 presentedViewController:self.presentVC photoPickType:PhotoPickTypeSystem complete:^(NSMutableArray *selectedImages) {
            UIImage *image = (UIImage *)selectedImages.firstObject;
//            image = [image jk_resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(150, 100) interpolationQuality:kCGInterpolationHigh];
            [weakSelf.fristImageView setImage:image forState:UIControlStateNormal];
            weakSelf.fristImageSelected = YES;
            weakSelf.fristContentLbl.hidden = YES;
        }];
    }
    else { // 右边点击
        WS(weakSelf);
        [[PhotoManager sharedInstance] showPhotoPickForMaxCount:1 presentedViewController:self.presentVC photoPickType:PhotoPickTypeSystem complete:^(NSMutableArray *selectedImages) {
            UIImage *image = (UIImage *)selectedImages.firstObject;
//            image = [image jk_resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(150, 100) interpolationQuality:kCGInterpolationHigh];
            [weakSelf.secondImageView setImage:image forState:UIControlStateNormal];
            weakSelf.secondImageSelected = YES;
            weakSelf.secondContentLbl.hidden = YES;
        }];
    }
}
#pragma mark - lazy

- (UIButton *)fristImageView {
    if (!_fristImageView) {
        _fristImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _fristImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fristImageView.tag = 1;
        [_fristImageView addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fristImageView;
}

- (UIButton *)secondImageView {
    if (!_secondImageView) {
        _secondImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondImageView.contentMode = UIViewContentModeScaleAspectFill;
        _secondImageView.tag = 2;
        [_secondImageView addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondImageView;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor getFontNineGrayColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont systemFontOfSize:14];
    }
    return _titleLbl;
}
- (UILabel *)fristContentLbl {
    if (!_fristContentLbl) {
        _fristContentLbl = [[UILabel alloc] init];
        _fristContentLbl.textColor = [UIColor getFontNineGrayColor];
        _fristContentLbl.textAlignment = NSTextAlignmentCenter;
        _fristContentLbl.font = [UIFont systemFontOfSize:12];
        _fristContentLbl.numberOfLines = 0;
    }
    return _fristContentLbl;
}
- (UILabel *)secondContentLbl {
    if (!_secondContentLbl) {
        _secondContentLbl = [[UILabel alloc] init];
        _secondContentLbl.textColor = [UIColor getFontNineGrayColor];
        _secondContentLbl.textAlignment = NSTextAlignmentCenter;
        _secondContentLbl.font = [UIFont systemFontOfSize:12];
        _secondContentLbl.numberOfLines = 0;
    }
    return _secondContentLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
@end
