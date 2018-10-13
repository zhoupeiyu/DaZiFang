//
//  ZRSWSelectTheCityCell.m
//  ZRSW
//
//  Created by King on 2018/10/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWSelectTheCityCell.h"

@interface ZRSWSelectTheCityCell()
@property (nonatomic, strong) UIImageView *topLineImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@end
@implementation ZRSWSelectTheCityCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    self.selectedBackgroundView = [ZRSWViewFactoryTool getCellSelectedView:CGRectMake(0, 0, SCREEN_WIDTH, kUI_HeightS(45))];
    self.backgroundColor = [UIColor colorFromRGB:0xF4F7FA];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setUpUI{
//    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.topLineImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews{
    self.bgImageView.frame = CGRectMake(0 ,0,SCREEN_WIDTH, kUI_HeightS(45));
    self.topLineImageView.frame = CGRectMake(kUI_WidthS(15) ,0, SCREEN_WIDTH - kUI_WidthS(40), kUI_HeightS(1));
    self.titleLabel.frame = CGRectMake(kUI_WidthS(15),kUI_HeightS(5), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(35));
}

- (UIImageView *)topLineImageView{
    if (!_topLineImageView) {
        _topLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choice_city_line"]];
    }
    return _topLineImageView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choice_city_list_bg"]];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorFromRGB:0x474455];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (void)setCity:(CityDetailModel *)city{
    _city = city;
    self.titleLabel.text = city.name;
}

- (void)setTopLineHidden:(BOOL)topLineHidden{
    _topLineHidden = topLineHidden;
    self.topLineImageView.hidden = topLineHidden;
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
