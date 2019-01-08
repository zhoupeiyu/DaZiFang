//
//  ZRSWHomeNewsHeaderView.m
//  ZRSW
//
//  Created by King on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWHomeNewsHeaderView.h"

@interface ZRSWHomeNewsHeaderView ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *lineView;

@end
@implementation ZRSWHomeNewsHeaderView
- (instancetype)init{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.leftImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowButton];
    [self addSubview:self.nextBtn];
    self.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
    WS(weakSelf);
    [self addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
        [weakSelf getMore:weakSelf.nextBtn];
    }];

}

- (void)showLineView {
    [self addSubview:self.lineView];
    _lineView.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
}
- (void)layoutSubviews{
    self.leftImageView.frame = CGRectMake(kUI_WidthS(15),kUI_HeightS(10), kUI_WidthS(3), kUI_HeightS(15));
    self.titleLabel.frame = CGRectMake(self.leftImageView.right + kUI_WidthS(10),kUI_HeightS(10), kUI_WidthS(128), kUI_HeightS(16));
    self.arrowButton.frame = CGRectMake(self.right - kUI_WidthS(21),kUI_HeightS(12), kUI_WidthS(6), kUI_HeightS(11));
    self.nextBtn.frame = CGRectMake(self.right - kUI_WidthS(64),0, kUI_WidthS(64), kUI_HeightS(35));
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc]init];
        _leftImageView.image = [UIImage imageNamed:@"currency_title_instructions"];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorFromRGB:0xFF21344F];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}


- (UIButton *)arrowButton{
    if (!_arrowButton) {
        _arrowButton = [[UIButton alloc] init];
        [_arrowButton setImage:[UIImage imageNamed:@"home_information_arrow"] forState:UIControlStateNormal];
    }
    return _arrowButton;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn addTarget:self action:@selector(getMore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currency_line_720"]];
        _lineView.hidden = YES;
    }
    return _lineView;
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)getMore:(UIButton *)btn {
    if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(getMoreClick:title:)]) {
            [self.delegate getMoreClick:btn.tag title:self.titleLabel.text];
    }
}
@end
