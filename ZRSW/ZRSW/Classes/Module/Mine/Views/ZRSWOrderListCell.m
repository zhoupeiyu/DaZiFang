//
//  ZRSWOrderListCell.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/29.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWOrderListCell.h"

@interface ZRSWOrderListCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UILabel *orderNumLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *orderStatesLbl;
@property (nonatomic, strong) UILabel *orderPersonLbl;
@property (nonatomic, strong) UILabel *oderTypeLbl;
@property (nonatomic, strong) UILabel *orderProductLbl;
@property (nonatomic, strong) UILabel *orderMoneyLbl;
@property (nonatomic, strong) ZRSWOrderListDetailModel *orderModel;
@property (nonatomic, strong) UIView *redView;

@end
@implementation ZRSWOrderListCell

+ (ZRSWOrderListCell *)getCellWithTableView:(UITableView *)tableView {
    ZRSWOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRSWOrderListCell class])];
    if (!cell) {
        cell = [[ZRSWOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZRSWOrderListCell class])];
    }
    return cell;
}
+ (CGFloat)cellHeight {
    return 137;
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
    self.contentView.backgroundColor = [UIColor clearColor];
}
- (void)setupUI {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.topBgView];
    [self.bgView addSubview:self.orderNumLbl];
    [self.bgView addSubview:self.redView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.orderStatesLbl];
    [self.bgView addSubview:self.orderPersonLbl];
    [self.bgView addSubview:self.oderTypeLbl];
    [self.bgView addSubview:self.orderProductLbl];
    [self.bgView addSubview:self.orderMoneyLbl];
}
- (void)setListModel:(ZRSWOrderListDetailModel *)model {
    if (model) {
       _orderModel = model;
        self.orderNumLbl.text = [NSString stringWithFormat:@"订单号:%@",model.orderId];
        self.orderNumLbl.text = model.orderId;
        {
            NSString *title = @"订单状态 : ";
            NSString *subTitle = model.orderStatesStr.length > 0 ? model.orderStatesStr : @" ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,subTitle]];
            [str addAttribute:NSForegroundColorAttributeName value:[self grayColor] range:NSRangeMake(0, title.length)];
            [str addAttribute:NSForegroundColorAttributeName value:model.orderStatesColor range:NSRangeMake(title.length, subTitle.length)];
            self.orderStatesLbl.attributedText = str;
            
        }
        {
            NSString *title = @"贷款人 : ";
            NSString *subTitle = model.loanUserName.length > 0 ? model.loanUserName : @" ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,subTitle]];
            [str addAttribute:NSForegroundColorAttributeName value:[self grayColor] range:NSRangeMake(0, title.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[self blackColor] range:NSRangeMake(title.length, subTitle.length)];
            self.orderPersonLbl.attributedText = str;
            
        }
        {
            NSString *title = @"贷款大类 : ";
            NSString *subTitle = model.mainLoanType.title.length > 0 ? model.mainLoanType.title : @" ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,subTitle]];
            [str addAttribute:NSForegroundColorAttributeName value:[self grayColor] range:NSRangeMake(0, title.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[self blackColor] range:NSRangeMake(title.length, subTitle.length)];
            self.oderTypeLbl.attributedText = str;
            
        }
        {
            NSString *title = @"贷款产品 : ";
            NSString *subTitle = model.loanType.title.length > 0 ? model.loanType.title : @" ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,subTitle]];
            [str addAttribute:NSForegroundColorAttributeName value:[self grayColor] range:NSRangeMake(0, title.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[self blackColor] range:NSRangeMake(title.length, subTitle.length)];
            self.orderProductLbl.attributedText = str;
            
        }
        {
            NSString *title = @"贷款金额 : ";
            NSString *subTitle = model.reallyLoanMoney.length > 0 ? model.reallyLoanMoney : @" ";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",title,subTitle]];
            [str addAttribute:NSForegroundColorAttributeName value:[self grayColor] range:NSRangeMake(0, title.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[self blackColor] range:NSRangeMake(title.length, subTitle.length)];
            self.orderMoneyLbl.attributedText = str;
            
        }
        [self setupLayOut];
    }

}
- (void)setupLayOut {
    CGFloat bgViewLeft = 10;
    CGFloat itemLeft = 20;
    CGFloat itemWidth = (SCREEN_WIDTH - 2 * bgViewLeft - 2 * itemLeft) * 0.5;
    CGFloat itemMargin = 10;
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 2 * bgViewLeft);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo([self topViewHeight]);
    }];
    [self.redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    [self.orderNumLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(itemLeft);
        make.centerY.mas_equalTo(self.topBgView.mas_centerY);
        make.right.mas_equalTo(-itemLeft);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.topBgView.mas_bottom);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
    [self.orderStatesLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderNumLbl.mas_left);
        make.top.mas_equalTo(self.topBgView.mas_bottom).mas_offset(14);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.orderPersonLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderStatesLbl.mas_right);
        make.top.mas_equalTo(self.orderStatesLbl.mas_top);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.oderTypeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderStatesLbl.mas_left);
        make.top.mas_equalTo(self.orderStatesLbl.mas_bottom).mas_offset(itemMargin);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.orderProductLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderStatesLbl.mas_right);
        make.top.mas_equalTo(self.orderPersonLbl.mas_bottom).mas_offset(itemMargin);
        make.width.mas_equalTo(itemWidth);
    }];
    [self.orderMoneyLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderStatesLbl.mas_left);
        make.top.mas_equalTo(self.oderTypeLbl.mas_bottom).mas_offset(itemMargin);
        make.right.mas_equalTo(-itemLeft);
    }];
}

#pragma mark - lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0,0);
        _bgView.layer.shadowOpacity = 1;
        _bgView.layer.shadowRadius = 20;
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [UIColor whiteColor];
    }
    return _topBgView;
}
- (UILabel *)orderNumLbl {
    if (!_orderNumLbl) {
        _orderNumLbl = [self getLbl];
        _orderNumLbl.textColor = [self blackColor];
        _orderNumLbl.font = [UIFont systemFontOfSize:16];
    }
    return _orderNumLbl;
}
- (UILabel *)orderStatesLbl {
    if (!_orderStatesLbl) {
        _orderStatesLbl = [self getLbl];
    }
    return _orderStatesLbl;
}
- (UILabel *)orderPersonLbl {
    if (!_orderPersonLbl) {
        _orderPersonLbl = [self getLbl];
    }
    return _orderPersonLbl;
}
- (UILabel *)oderTypeLbl {
    if (!_oderTypeLbl) {
        _oderTypeLbl = [self getLbl];
    }
    return _oderTypeLbl;
}
- (UILabel *)orderProductLbl {
    if (!_orderProductLbl) {
        _orderProductLbl = [self getLbl];
    }
    return _orderProductLbl;
}
- (UILabel *)orderMoneyLbl {
    if (!_orderMoneyLbl) {
        _orderMoneyLbl = [self getLbl];
    }
    return _orderMoneyLbl;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [ZRSWViewFactoryTool getLineView];
    }
    return _lineView;
}
- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 4;
        _redView.layer.masksToBounds = YES;
    }
    return _redView;
}

- (UIColor *)grayColor {
    return [UIColor colorFromRGB:0x999999];
}
- (UIColor *)blackColor {
    return [UIColor colorFromRGB:0x474455];
}
- (CGFloat)topViewHeight {
    return 44;
}
- (UILabel *)getLbl {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = [UIColor colorFromRGB:0x999999];
    return lbl;
}
@end
