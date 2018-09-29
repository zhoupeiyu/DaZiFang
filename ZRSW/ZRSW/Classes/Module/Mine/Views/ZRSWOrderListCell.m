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

@end
@implementation ZRSWOrderListCell
//审核中 #666666  已通过#4abd22 已放款#4771f2 已拒绝#ff5153 已完成#999999
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
    self.contentView.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.topBgView];
    [self.bgView addSubview:self.orderNumLbl];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.orderStatesLbl];
    [self.bgView addSubview:self.orderPersonLbl];
    [self.bgView addSubview:self.oderTypeLbl];
    [self.bgView addSubview:self.orderProductLbl];
    [self.bgView addSubview:self.orderMoneyLbl];
    [self setupLayOut];
    
}
- (void)setupLayOut {
    
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
- (UILabel *)getLbl {
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = [UIColor colorFromRGB:0x999999];
    return lbl;
}
@end
