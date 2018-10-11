//
//  ZRSWMineListCell.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWMineListCell.h"

@interface ZRSWMineListCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *descLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) MineListType cellType;
@property (nonatomic, assign) BOOL bottomLineHidden;

@end
@implementation ZRSWMineListCell

+ (instancetype)getCllWithTableView:(UITableView *)tableview {
    ZRSWMineListCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWMineListCell class])];
    if (!cell) {
        cell = [[ZRSWMineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWMineListCell class])];
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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.descLbl];
    [self.contentView addSubview:self.lineView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(KSeparatorLineHeight);
        make.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setModel:(ZRSWMineModel *)model {
    _model = model;
    self.titleLbl.text = model.title;
    self.descLbl.text = model.desInfo;
    self.cellType = model.type;
    self.bottomLineHidden = model.bottomLineHidden;
    UIImage *image = [UIImage imageNamed:@"my_head"];
    if ([ControllerUtilsManager isHTTPURL:model.iconName]) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconName] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!image) {
                self.iconImageView.image = image;
            }
        }];
        _iconImageView.layer.cornerRadius = image.size.height * 0.5;
        _iconImageView.layer.masksToBounds = YES;
        UIImage *iconImage = _iconImageView.image;
        NSData *data;
        if (UIImagePNGRepresentation(iconImage)){
            data = UIImagePNGRepresentation(iconImage);
        }else{
            data = UIImageJPEGRepresentation(iconImage, 1.0);
        }
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:CurrentUserIocnImage];
        }
    }
    else {
        if (model.iconName.length > 0) {
            _iconImageView.image = [UIImage imageNamed:model.iconName];
        }
        else {
            _iconImageView.image = image;
        }
    }
}
- (void)setCellType:(MineListType)cellType {
    _cellType = cellType;
    if (cellType == MineListTypeUserInfo) {
        self.descLbl.textAlignment = NSTextAlignmentLeft;
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        if (_model.hasLogin) {
            [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(15);
                make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
            }];
            [self.descLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-15);
                make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
            }];
            self.descLbl.hidden = NO;
        }
        else {
            [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
                make.left.mas_equalTo(self.iconImageView.mas_right).offset(15);
            }];
        }
    }
    else {
        [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(45);
        }];
        self.descLbl.hidden = cellType == MineListTypeCommentList;
        self.arrowImageView.hidden = cellType != MineListTypeCommentList;
        if (cellType == MineListTypeSetting) {
            [self.descLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
            }];
            self.descLbl.textAlignment = NSTextAlignmentRight;
        }
        else{
            self.descLbl.textAlignment = NSTextAlignmentLeft;
        }
    }
}
- (void)setBottomLineHidden:(BOOL)bottomLineHidden {
    _bottomLineHidden = bottomLineHidden;
    self.lineView.hidden = bottomLineHidden;
}

#pragma mark - lazy
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageNamed:@"my_head"];
        _iconImageView.image = image;

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
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorFromRGB:0x474455];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont systemFontOfSize:16];
    }
    return _titleLbl;
}

- (UILabel *)descLbl {
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [UIColor colorFromRGB:0x999999];
        _descLbl.textAlignment = NSTextAlignmentLeft;
        _descLbl.font = [UIFont systemFontOfSize:14];
    }
    return _descLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorFromRGB:0xEDEDED];
    }
    return _lineView;
}
@end
