//
//  ZRSWUserInfoCell.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWUserInfoCell.h"

#define IconViewHeight              50

@interface ZRSWUserInfoCell ()<UITextFieldDelegate>

@property (nonatomic, assign) UserInfoCellType cellType;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *desLbl;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZRSWUserInfoListModel *model;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *placeHoled;
@property (nonatomic, strong) NSString *headerImageUrl;

@property (nonatomic, weak) id <UserInfoCellDelegate> deleget;


@end
@implementation ZRSWUserInfoCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}
- (void)setupUI {
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.desLbl];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.lineView];
}
- (void)setUserInfoListModel:(ZRSWUserInfoListModel *)model {
    self.model = model;
    self.cellType = model.cellType;
    [self setBottomLineHidden:model.bottomLineHidden];
    self.titleLbl.text = model.title;
    self.desLbl.text = model.desTitle;
    self.selectionStyle = model.selectionStyle;
    self.deleget = model.deleget;
    self.placeHoled = model.placeHoled;
    self.textField.tag = model.textFieldTag;
    if (self.model.image) {
        self.iconImageView.image = model.image;
    }
    else {
        if (model.headerImageUrl.length > 0) {
            self.headerImageUrl = model.headerImageUrl;
        }
    }
    if (model.cellType == UserInfoCellTypeInput) {
        if (model.desTitle.length > 0) {
            self.textField.text = model.desTitle;
        }
    }
    
}
- (void)setHeaderImageUrl:(NSString *)headerImageUrl {
    _headerImageUrl = headerImageUrl;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headerImageUrl] placeholderImage:[UIImage imageNamed:@"my_head"]];
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
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(82);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
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
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
    if (cellType == UserInfoCellTypeHeader) {
        self.iconImageView.hidden = NO;
        self.arrowImageView.hidden = NO;
        self.textField.hidden = YES;
        self.desLbl.hidden = YES;
        _iconImageView.layer.cornerRadius = IconViewHeight * 0.5;
        _iconImageView.layer.masksToBounds = YES;
    }
    else if (cellType == UserInfoCellTypeInfo || cellType == UserInfoCellTypeInput) {
        self.iconImageView.hidden = YES;
        self.arrowImageView.hidden = YES;
        self.textField.hidden = cellType == UserInfoCellTypeInfo;
        self.desLbl.hidden = cellType == UserInfoCellTypeInput;
    }
}

- (void)setPlaceHoled:(NSString *)placeHoled {
    _placeHoled = placeHoled;
    if (placeHoled.length == 0) return;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeHoled];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x999999] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, str.length)];
    self.textField.attributedPlaceholder = str;
}
- (void)setBottomLineHidden:(BOOL)isHidden {
    self.lineView.hidden = isHidden;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.deleget && [self.deleget respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:customView:)]) {
        BOOL isInput = [self.deleget textField:textField shouldChangeCharactersInRange:range replacementString:string customView:self];
        return isInput;
    }
    return YES;
}
- (void)textFieldTextDidChange:(NSNotification *)noti {
    if (noti.object == self.textField) {
        if (self.deleget && [self.deleget respondsToSelector:@selector(textFieldTextDidChange:customView:)]) {
            [self.deleget textFieldTextDidChange:self.textField customView:self];
        }
    }
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
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [UIColor colorFromRGB:0x474455];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
    }
    return _textField;
}
@end
