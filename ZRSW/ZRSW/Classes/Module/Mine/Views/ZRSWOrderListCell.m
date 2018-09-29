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
@property (nonatomic, strong) UILabel *orderNumLbl;
@property (nonatomic, strong) UILabel *lineView;
@property (nonatomic, strong) UILabel *orderStatesLbl;
@property (nonatomic, strong) UILabel *orderPersonLbl;
@property (nonatomic, strong) UILabel *oderTypeLbl;
@property (nonatomic, strong) UILabel *orderProductLbl;
@property (nonatomic, strong) UILabel *orderMoneyLbl;

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
    self.contentView.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI {
    
}
@end
