//
//  ZRSWRemindListCell.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRemindListCell.h"
@interface ZRSWRemindListCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end
@implementation ZRSWRemindListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)setUpUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.dateLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.contentLabel];
//    [self.backView addSubview:self.nameLabel];
}

- (void)layoutSubviews{
    self.backView.frame = CGRectMake(kUI_WidthS(10) ,kUI_HeightS(10),  SCREEN_WIDTH - kUI_WidthS(20), kUI_HeightS(145));
    self.dateLabel.frame = CGRectMake(kUI_WidthS(16),kUI_HeightS(15), SCREEN_WIDTH - kUI_WidthS(32), kUI_HeightS(13));
    self.lineView.frame = CGRectMake(kUI_WidthS(10) ,self.dateLabel.bottom + kUI_HeightS(15) , SCREEN_WIDTH - kUI_WidthS(20), kUI_HeightS(1));
    self.contentLabel.frame = CGRectMake(self.dateLabel.left,self.lineView.bottom + kUI_HeightS(15), self.dateLabel.width, kUI_HeightS(88));
//    self.nameLabel.frame = CGRectMake(self.contentLabel.left,self.contentLabel.bottom, self.contentLabel.width, kUI_HeightS(14));
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorFromRGB:0xFFFFFFFF];
    }
    return _backView;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorFromRGB:0x999999];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currency_line_720"]];
    }
    return _lineView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorFromRGB:0xFF444152];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"【中融盛旺】";
        _nameLabel.textColor = [UIColor colorFromRGB:0xFF444152];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (void)setRemindModel:(ZRSWRemindModel *)remindModel{
    _remindModel = remindModel;
    self.dateLabel.text = _remindModel.sendTime;
    self.contentLabel.text = _remindModel.content;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
