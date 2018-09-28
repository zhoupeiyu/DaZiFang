//
//  ZRSWUserInfoCell.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWUserInfoCell.h"

#define IconViewHeight              50

@interface ZRSWUserInfoCell ()
@property (nonatomic, assign) UserInfoCellType cellType;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *desLbl;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZRSWUserInfoListModel *model;

@end
@implementation ZRSWUserInfoCell

+ (ZRSWUserInfoCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWUserInfoCell class])];
    if (!cell) {
        cell = [[ZRSWUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWUserInfoCell class])];
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.selectedBackgroundView = [ZRSWViewFactoryTool getCellSelectedView:self.contentView.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI {
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.desLbl];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
}
- (void)setUserInfoListModel:(ZRSWUserInfoListModel *)model {
    self.model = model;
    self.cellType = model.cellType;
    [self setBottomLineHidden:model.bottomLineHidden];
    self.titleLbl.text = model.title;
    self.desLbl.text = model.desTitle;
    self.selectionStyle = model.selectionStyle;
}
- (void)setCellType:(UserInfoCellType)cellType {
    _cellType = cellType;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(82);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(IconViewHeight, IconViewHeight));
    }];
    if (cellType == UserInfoCellTypeHeader) {
        self.iconImageView.hidden = NO;
        self.arrowImageView.hidden = NO;
    }
    else if (cellType == UserInfoCellTypeInfo) {
        self.iconImageView.hidden = YES;
        self.arrowImageView.hidden = YES;
    }
}
- (void)setBottomLineHidden:(BOOL)isHidden {
    self.lineView.hidden = isHidden;
}
#pragma mark - lazy

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorFromRGB:0x474455];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont systemFontOfSize:16];
    }
    return _titleLbl;
}
- (UILabel *)desLbl {
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor colorFromRGB:0x999999];
        _desLbl.textAlignment = NSTextAlignmentLeft;
        _desLbl.font = [UIFont systemFontOfSize:16];
    }
    return _desLbl;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = IconViewHeight * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"my_head"];
    }
    return _iconImageView;
}
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"TableViewArrow_15x15_"];
    }
    return _arrowImageView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorFromRGB:0xEDEDED];
    }
    return _lineView;
}
@end
