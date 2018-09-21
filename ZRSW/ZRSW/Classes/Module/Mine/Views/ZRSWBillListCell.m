//
//  ZRSWBillListCell.m
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBillListCell.h"
@interface ZRSWBillListCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *loanProductLabel;
@property (nonatomic, strong) UILabel *loanTypeLabel;
@property (nonatomic, strong) UILabel *loanDateLabel;
@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *mortgagePaymentLabel;
@property (nonatomic, strong) UILabel *paymentsLabel;
@property (nonatomic, strong) UILabel *lenderLabel;
@property (nonatomic, strong) UILabel *lenderNameLabel;
@property (nonatomic, strong) UILabel *paymentDueDateLabel;
@property (nonatomic, strong) UILabel *paymentDateLabel;
@property (nonatomic, strong) UILabel *paymentStatusLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end
@implementation ZRSWBillListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)setUpUI{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.loanProductLabel];
    [self.backView addSubview:self.loanTypeLabel];
    [self.backView addSubview:self.loanDateLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.mortgagePaymentLabel];
    [self.backView addSubview:self.paymentsLabel];
    [self.backView addSubview:self.lenderLabel];
    [self.backView addSubview:self.lenderNameLabel];
    [self.backView addSubview:self.paymentDueDateLabel];
    [self.backView addSubview:self.paymentDateLabel];
    [self.backView addSubview:self.paymentStatusLabel];
    [self.backView addSubview:self.statusLabel];
}

- (void)layoutSubviews{
    self.backView.frame = CGRectMake(kUI_WidthS(10) ,kUI_HeightS(10),SCREEN_WIDTH - kUI_WidthS(20), kUI_HeightS(150));
    self.iconView.frame = CGRectMake(kUI_WidthS(10),kUI_HeightS(18), kUI_WidthS(5), kUI_HeightS(5));
    self.loanProductLabel.frame = CGRectMake(self.iconView.right + kUI_WidthS(5) ,kUI_HeightS(15) ,kUI_WidthS(88), kUI_HeightS(16));
    self.loanTypeLabel.frame = CGRectMake(self.loanProductLabel.right,self.loanProductLabel.top, kUI_WidthS(84), kUI_HeightS(16));
    self.loanDateLabel.frame = CGRectMake(self.loanTypeLabel.right,self.loanProductLabel.top, kUI_WidthS(120), kUI_HeightS(16));
    self.lineView.frame = CGRectMake(kUI_WidthS(10),self.loanProductLabel.bottom + kUI_HeightS(10), SCREEN_WIDTH - kUI_WidthS(20), kUI_HeightS(1));
    self.mortgagePaymentLabel.frame = CGRectMake(self.loanProductLabel.left,self.lineView.bottom + kUI_HeightS(15), kUI_WidthS(60), kUI_HeightS(14));
    self.paymentsLabel.frame = CGRectMake(self.mortgagePaymentLabel.right,self.mortgagePaymentLabel.top,  kUI_WidthS(120), kUI_HeightS(14));
    self.lenderLabel.frame = CGRectMake(self.paymentsLabel.right,self.mortgagePaymentLabel.top, kUI_WidthS(60), kUI_HeightS(14));
    self.lenderNameLabel.frame = CGRectMake(self.lenderLabel.right,self.mortgagePaymentLabel.top, kUI_WidthS(100), kUI_HeightS(14));
    self.paymentDueDateLabel.frame = CGRectMake(self.loanProductLabel.left,self.mortgagePaymentLabel.bottom + kUI_HeightS(15), kUI_WidthS(88), kUI_HeightS(14));
    self.paymentDateLabel.frame = CGRectMake(self.paymentDueDateLabel.right,self.paymentDueDateLabel.top, kUI_WidthS(120), kUI_HeightS(14));
    self.paymentStatusLabel.frame = CGRectMake(self.loanProductLabel.left,self.paymentDueDateLabel.bottom + kUI_HeightS(15), kUI_WidthS(80), kUI_HeightS(14));
    self.statusLabel.frame = CGRectMake(self.paymentStatusLabel.right,self.paymentStatusLabel.top, kUI_WidthS(120), kUI_HeightS(14));
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor colorFromRGB:0xFFFFFFFF];
    }
    return _backView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_title_instructions"]];
    }
    return _iconView;
}
- (UILabel *)loanProductLabel{
    if (!_loanProductLabel) {
        _loanProductLabel = [[UILabel alloc] init];
        _loanProductLabel.text = @"贷款产品：";
        _loanProductLabel.textColor = [UIColor colorFromRGB:0x474455];
        _loanProductLabel.textAlignment = NSTextAlignmentLeft;
        _loanProductLabel.font = [UIFont systemFontOfSize:16];
    }
    return _loanProductLabel;
}

- (UILabel *)loanTypeLabel{
    if (!_loanTypeLabel) {
        _loanTypeLabel = [[UILabel alloc] init];
        _loanTypeLabel.text = @"企业经营贷";
        _loanTypeLabel.textColor = [UIColor colorFromRGB:0x474455];
        _loanTypeLabel.textAlignment = NSTextAlignmentLeft;
        _loanTypeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _loanTypeLabel;
}

- (UILabel *)loanDateLabel{
    if (!_loanDateLabel) {
        _loanDateLabel = [[UILabel alloc] init];
        _loanDateLabel.text = @"（10/24期）";
        _loanDateLabel.textColor = [UIColor colorFromRGB:0xff5153];
        _loanDateLabel.textAlignment = NSTextAlignmentLeft;
        _loanDateLabel.font = [UIFont systemFontOfSize:16];
    }
    return _loanDateLabel;
}

- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"currency_line_720"]];
    }
    return _lineView;
}

- (UILabel *)mortgagePaymentLabel{
    if (!_mortgagePaymentLabel) {
        _mortgagePaymentLabel = [[UILabel alloc] init];
        _mortgagePaymentLabel.text = @"还款额：";
        _mortgagePaymentLabel.textColor = [UIColor colorFromRGB:0x999999];
        _mortgagePaymentLabel.textAlignment = NSTextAlignmentLeft;
        _mortgagePaymentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mortgagePaymentLabel;
}

- (UILabel *)paymentsLabel{
    if (!_paymentsLabel) {
        _paymentsLabel = [[UILabel alloc] init];
        _paymentsLabel.text = @"¥16778.09";
        _paymentsLabel.textColor = [UIColor colorFromRGB:0x4771F2];
        _paymentsLabel.textAlignment = NSTextAlignmentLeft;
        _paymentsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _paymentsLabel;
}


- (UILabel *)lenderLabel{
    if (!_lenderLabel) {
        _lenderLabel = [[UILabel alloc] init];
        _lenderLabel.text = @"贷款人：";
        _lenderLabel.textColor = [UIColor colorFromRGB:0x999999];
        _lenderLabel.textAlignment = NSTextAlignmentLeft;
        _lenderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _lenderLabel;
}

- (UILabel *)lenderNameLabel{
    if (!_lenderNameLabel) {
        _lenderNameLabel = [[UILabel alloc] init];
        _lenderNameLabel.text = @"杨飞";
        _lenderNameLabel.textColor = [UIColor colorFromRGB:0x999999];
        _lenderNameLabel.textAlignment = NSTextAlignmentLeft;
        _lenderNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _lenderNameLabel;
}

- (UILabel *)paymentDueDateLabel{
    if (!_paymentDueDateLabel) {
        _paymentDueDateLabel = [[UILabel alloc] init];
        _paymentDueDateLabel.text = @"到期还款日：";
        _paymentDueDateLabel.textColor = [UIColor colorFromRGB:0x999999];
        _paymentDueDateLabel.textAlignment = NSTextAlignmentLeft;
        _paymentDueDateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _paymentDueDateLabel;
}

- (UILabel *)paymentDateLabel{
    if (!_paymentDateLabel) {
        _paymentDateLabel = [[UILabel alloc] init];
        _paymentDateLabel.text = @"2018/08/29";
        _paymentDateLabel.textColor = [UIColor colorFromRGB:0x474455];
        _paymentDateLabel.textAlignment = NSTextAlignmentLeft;
        _paymentDateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _paymentDateLabel;
}

- (UILabel *)paymentStatusLabel{
    if (!_paymentStatusLabel) {
        _paymentStatusLabel = [[UILabel alloc] init];
        _paymentStatusLabel.text = @"还款状态：";
        _paymentStatusLabel.textColor = [UIColor colorFromRGB:0x999999];
        _paymentStatusLabel.textAlignment = NSTextAlignmentLeft;
        _paymentStatusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _paymentStatusLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"已逾期";
        _statusLabel.textColor = [UIColor colorFromRGB:0xFF5153];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = [UIFont systemFontOfSize:14];
    }
    return _statusLabel;
}

- (void)setBillModel:(ZRSWBillModel *)billModel{
    _billModel = billModel;
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
