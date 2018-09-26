//
//  ZRSWLoansTopCell.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoansTopCell.h"

@implementation LoansCellStates

+ (UIColor *)getBlackColor {
    return [UIColor colorFromRGB:0x474455];
}
+ (UIColor *)getStartRedColor {
    return [UIColor colorFromRGB:0xff0000];
}
+ (UIColor *)getContentColor {
    return [UIColor colorFromRGB:0x999999];
}
+ (UIFont *)getTitleFont {
    return [UIFont systemFontOfSize:16];
}
+ (UIFont *)getContentFont {
    return [UIFont systemFontOfSize:14];;
}
@end

@interface ZRSWLoansTopCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowView;

@end
@implementation ZRSWLoansTopCell

+ (ZRSWLoansTopCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWLoansTopCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansTopCell class])];
    if (!cell) {
        cell = [[ZRSWLoansTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansTopCell class])];
    }
    return cell;
}
+ (CGFloat)cellHeigh {
    return 44;
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
    [self.contentView addSubview:self.typeLbl];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.arrowView];
    [self setupLayout];
}
- (void)setupLayout {
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(KSeparatorLineHeight);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLbl.mas_right).mas_offset(18);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - event
- (void)setIsNeedLine:(BOOL)isNeedLine {
    _isNeedLine = isNeedLine;
    self.lineView.hidden = !isNeedLine;
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    NSString *title = [NSString stringWithFormat:@"*%@",titleStr];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:[LoansCellStates getBlackColor] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSParagraphStyleAttributeName value:[LoansCellStates getStartRedColor] range:NSRangeMake(0, 1)];
    self.titleLbl.text = titleStr;
    [self.titleLbl sizeToFit];
}
- (void)setContentStr:(NSString *)contentStr {
    _contentStr = contentStr;
    self.typeLbl.text = contentStr.length > 0 ? contentStr : @"请选择";
}
#pragma mark - lazy

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [LoansCellStates getTitleFont];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}
- (UILabel *)typeLbl {
    if (!_typeLbl) {
        _typeLbl = [[UILabel alloc] init];
        _typeLbl.text = @"请选择";
        _typeLbl.textAlignment = NSTextAlignmentLeft;
        _typeLbl.textColor = [LoansCellStates getContentColor];
        _typeLbl.font = [LoansCellStates getContentFont];
    }
    return _typeLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [ZRSWViewFactoryTool arrowImageView];
    }
    return _arrowView;
}
@end

#pragma mark - 贷款流程

@interface ZRSWLoansFlow ()

@property (nonatomic, strong) UIImageView *contentImageView;

@end
@implementation ZRSWLoansFlow

+ (ZRSWLoansFlow *)getCellWithTableView:(UITableView *)tableView {
    ZRSWLoansFlow *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansFlow class])];
    if (!cell) {
        cell = [[ZRSWLoansFlow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansFlow class])];
    }
    return cell;
}


+ (CGFloat)cellHeigh {
    return [ZRSWLoansFlow contentImage].size.height + 2 * 15;
}

+ (UIImage *)contentImage {
    return [UIImage imageNamed:@"loan_process"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}
- (void)setupConfig {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setupUI {
    [self.contentView addSubview:self.contentImageView];
    [self setupLayout];
}

- (void)setupLayout {
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.image = [ZRSWLoansFlow contentImage];
        _contentImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _contentImageView;
}
@end

@interface ZRSWLoansProductAttributeCell ()
@property (nonatomic, strong) NSMutableArray *lblArray;

@end
@implementation ZRSWLoansProductAttributeCell

+ (ZRSWLoansProductAttributeCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWLoansProductAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansProductAttributeCell class])];
    if (!cell) {
        cell = [[ZRSWLoansProductAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansProductAttributeCell class])];
    }
    return cell;
}
+ (CGFloat)cellHeigh {
    return 65;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}
- (void)setupConfig {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupUI {
    
}
- (void)setInfoDetailModel:(ZRSWOrderLoanInfoDetailModel *)infoDetailModel {
    _infoDetailModel = infoDetailModel;
    for (ZRSWOrderLoanInfoAttrs *model in infoDetailModel.loanTypeAttrs) {
        
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《中融盛旺用户协议》"];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x999999] range:NSMakeRange(0, 7)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromRGB:0x4771f2] range:NSMakeRange(7, 10)];
}

#pragma mark - lazy

- (UIColor *)titleColor {
    return [UIColor colorFromRGB:0x999999];
}
- (UIColor *)dataColor {
    return [UIColor colorFromRGB:0x474455];
}

- (UILabel *)getlbl {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:14];
    return lbl;
}

@end

















































#pragma mark - headerView

@interface ZRSWLoansTopHeaderView ()

@property (nonatomic, strong) UIImageView *indicatorView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZRSWLoansTopHeaderView

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
    [self addSubview:self.indicatorView];
    [self addSubview:self.titleLbl];
    [self addSubview:self.lineView];
    
    [self setupLayout];
}
- (void)setupLayout {
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.indicatorView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
}
- (void)setHeaderTitle:(NSString *)headerTitle {
    _headerTitle = headerTitle;
    self.titleLbl.text = headerTitle;
}

#pragma mark - lazy

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] init];
        _indicatorView.image = [UIImage imageNamed:@"currency_title_instructions"];
    }
    return _indicatorView;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [LoansCellStates getBlackColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [LoansCellStates getTitleFont];
    }
    return _titleLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
@end
































































