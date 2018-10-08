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
    [attr addAttribute:NSForegroundColorAttributeName value:[LoansCellStates getBlackColor] range:NSRangeMake(0, title.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[LoansCellStates getStartRedColor] range:NSRangeMake(0, 1)];
    self.titleLbl.attributedText = attr;
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

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[ZRSWLoansFlow contentImage]];
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
@property (nonatomic, strong) NSMutableArray <UILabel *> *lblArray;

@end
@implementation ZRSWLoansProductAttributeCell

+ (ZRSWLoansProductAttributeCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWLoansProductAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansProductAttributeCell class])];
    if (!cell) {
        cell = [[ZRSWLoansProductAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansProductAttributeCell class])];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupConfig];
    }
    return self;
}
- (void)setupConfig {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lblArray = [[NSMutableArray alloc] init];
}

- (void)setupLayout {
    NSInteger count = [self.infoDetailModel warpCount];
    CGFloat width = (SCREEN_WIDTH - count * [self.infoDetailModel attrsLeft]) * 0.5;
    CGFloat height = [self.infoDetailModel attrsItemHeight];
    CGFloat margin = [self.infoDetailModel attrsItemMargin];
    CGFloat top = [self.infoDetailModel attrsTop];
    CGFloat left = [self.infoDetailModel attrsLeft];
    [self.lblArray mas_distributeSudokuViewsWithFixedItemWidth:width fixedItemHeight:height fixedLineSpacing:margin fixedInteritemSpacing:-50 warpCount:count topSpacing:top bottomSpacing:top leadSpacing:left tailSpacing:0];
}
- (void)setInfoDetailModel:(ZRSWOrderLoanInfoDetailModel *)infoDetailModel {
    if (!infoDetailModel) return;
    _infoDetailModel = infoDetailModel;
    if (self.lblArray.count > 0) {
        [self.lblArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.lblArray removeAllObjects];
    }
    for (ZRSWOrderLoanInfoAttrs *model in infoDetailModel.loanTypeAttrs) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.attrName,model.attrVal]];
        [att addAttribute:NSForegroundColorAttributeName value:[self titleColor] range:NSMakeRange(0, model.attrName.length + 1)];
        [att addAttribute:NSForegroundColorAttributeName value:[self dataColor] range:NSMakeRange(model.attrName.length + 1, model.attrVal.length)];
        UILabel *lbl = [self getlbl];
        lbl.attributedText = att;
        [self.contentView addSubview:lbl];
        [self.lblArray addObject:lbl];
    }
    [self setupLayout];
}

#pragma mark - lazy

- (UIColor *)titleColor {
    return [LoansCellStates getBlackColor];
}
- (UIColor *)dataColor {
    return [LoansCellStates getContentColor];
}

- (UILabel *)getlbl {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [LoansCellStates getContentFont];
    return lbl;
}

@end

@interface ZRSWLoansConditionCell ()
@property (nonatomic, strong) UILabel *contentLbl;
@end
@implementation ZRSWLoansConditionCell

+ (ZRSWLoansConditionCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWLoansConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWLoansConditionCell class])];
    if (!cell) {
        cell = [[ZRSWLoansConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWLoansConditionCell class])];
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (void)setupUI {
    [self.contentView addSubview:self.contentLbl];
    
}
- (void)setMaterialDetailsModel:(ZRSWOrderLoanInfoDetailModel *)materialDetailsModel {
    _materialDetailsModel = materialDetailsModel;
    NSMutableAttributedString * htmlString = [[NSMutableAttributedString alloc] initWithData:[materialDetailsModel.materialDetails dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.contentLbl.attributedText = htmlString;
    [self.contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    [self.contentLbl sizeToFit];
}

- (void)setLoanConditionsModel:(ZRSWOrderLoanInfoDetailModel *)loanConditionsModel {
    _loanConditionsModel = loanConditionsModel;
    NSMutableAttributedString * htmlString = [[NSMutableAttributedString alloc] initWithData:[loanConditionsModel.loanConditions dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.contentLbl.attributedText = htmlString;
    [self.contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(0);
    }];
    [self.contentLbl sizeToFit];
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] init];
        _contentLbl.textAlignment = NSTextAlignmentLeft;
        _contentLbl.font = [UIFont systemFontOfSize:14];
        _contentLbl.textColor = [LoansCellStates getContentColor];
        _contentLbl.numberOfLines = 0;
    }
    return _contentLbl;
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
































































