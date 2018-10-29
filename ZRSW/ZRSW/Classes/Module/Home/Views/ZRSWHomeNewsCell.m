//
//  ZRSWHomeNewsCell.m
//  ZRSW
//
//  Created by King on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWHomeNewsCell.h"
@interface ZRSWHomeNewsCell()
@property (nonatomic, strong) UIImageView *topLineImge;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *sourceNameLabel;
@property (nonatomic, strong) UIImageView *readerIcon;
@property (nonatomic, strong) UILabel *readersLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end
@implementation ZRSWHomeNewsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    self.selectedBackgroundView = [ZRSWViewFactoryTool getCellSelectedView:CGRectMake(0, 0, SCREEN_WIDTH, kUI_HeightS(120))];
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setUpUI{
    [self.contentView addSubview:self.topLineImge];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.sourceNameLabel];
    [self.contentView addSubview:self.readerIcon];
    [self.contentView addSubview:self.readersLabel];
    [self.contentView addSubview:self.dateLabel];
}

- (void)layoutSubviews{
    self.topLineImge.frame = CGRectMake((SCREEN_WIDTH - kUI_WidthS(360))/2 ,0, kUI_WidthS(360), kUI_HeightS(1));
    self.iconImageView.frame = CGRectMake(kUI_WidthS(15),kUI_HeightS(15), kUI_WidthS(133), kUI_HeightS(86));
    self.titleLabel.frame = CGRectMake(self.iconImageView.right + kUI_WidthS(15),kUI_HeightS(20), (SCREEN_WIDTH - self.iconImageView.right - kUI_WidthS(30)), kUI_HeightS(15));
    self.contentLabel.frame = CGRectMake(self.titleLabel.left,self.titleLabel.bottom + kUI_HeightS(9), self.titleLabel.width, kUI_HeightS(34));
     self.sourceNameLabel.frame = CGRectMake(self.iconImageView.right + kUI_WidthS(16),self.contentLabel.bottom + kUI_HeightS(12), kUI_WidthS(64), kUI_HeightS(10));
    [self.sourceNameLabel sizeToFit];
    if (self.sourceNameLabel.text.length == 0) {
        self.readerIcon.frame = CGRectMake(self.iconImageView.right+kUI_WidthS(16),self.contentLabel.bottom + kUI_HeightS(12), kUI_WidthS(15), kUI_HeightS(10));
    }else{
        self.readerIcon.frame = CGRectMake(self.sourceNameLabel.right + kUI_WidthS(16),self.contentLabel.bottom + kUI_HeightS(12), kUI_WidthS(15), kUI_HeightS(10));
    }
    self.readersLabel.frame = CGRectMake(self.readerIcon.right + kUI_WidthS(3),self.contentLabel.bottom + kUI_HeightS(13), kUI_WidthS(33), kUI_HeightS(10));
    self.dateLabel.frame = CGRectMake(self.readersLabel.right + kUI_WidthS(8),self.readersLabel.top, kUI_WidthS(150), kUI_HeightS(10));
}

- (UIImageView *)topLineImge{
    if (!_topLineImge) {
        _topLineImge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currency_line_720"]];
    }
    return _topLineImge;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"home_information_bg"];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorFromRGB:0xFF000000];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}


- (UILabel *)sourceNameLabel{
    if (!_sourceNameLabel) {
        _sourceNameLabel = [[UILabel alloc] init];
        _sourceNameLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _sourceNameLabel.textAlignment = NSTextAlignmentLeft;
        _sourceNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sourceNameLabel;
}
- (UIImageView *)readerIcon{
    if (!_readerIcon) {
        _readerIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _readerIcon.image = [UIImage imageNamed:@"currency_watch_number"];
    }
    return _readerIcon;
}


- (UILabel *)readersLabel{
    if (!_readersLabel) {
        _readersLabel = [[UILabel alloc] init];
        _readersLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _readersLabel.textAlignment = NSTextAlignmentLeft;
        _readersLabel.font = [UIFont systemFontOfSize:10];
    }
    return _readersLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:10];
    }
    return _dateLabel;
}

- (void)setDetailModel:(NewDetailModel *)detailModel{
    _detailModel = detailModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",detailModel.imgUrl]] placeholderImage:[UIImage imageNamed:@"home_information_bg"]];
    self.titleLabel.text = detailModel.title;
    self.contentLabel.text = detailModel.roundup;
    self.sourceNameLabel.text = detailModel.sourceName;
    self.readersLabel.text = [NSString stringWithFormat:@"%@",detailModel.readers];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:detailModel.updateTime];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateString = [formatter stringFromDate:date];
    self.dateLabel.text = dateString;
}

- (void)setTopLineHidden:(BOOL)topLineHidden{
    _topLineHidden = topLineHidden;
    self.topLineImge.hidden = topLineHidden;
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
