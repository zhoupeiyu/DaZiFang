//
//  ZRSWOrderModel.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/25.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWOrderModel.h"

#define KOrderMainTypeListNameKey               @"KOrderMainTypeListNameKey"
#define KOrderMainTypeListIDKey                 @"KOrderMainTypeListIDKey"

#define KOrderLoanTypeListNameKey               @"KOrderLoanTypeListNameKey"
#define KOrderLoanTypeListIDKey                 @"KOrderLoanTypeListIDKey"
#define KOrderLoanTypeListMainIDKey             @"KOrderLoanTypeListMainIDKey"

@implementation ZRSWOrderMainTypeListItemFrame

@end

@implementation ZRSWOrderMainTypeDetaolModel

@end
@implementation ZRSWOrderMainTypeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderMainTypeDetaolModel class],
             };
}

- (CGFloat)itemTopMargin {
    return 28 / 2;
}
- (CGFloat)iconViewHeight {
    return 140 / 2;
}

- (CGFloat)iconViewWidth {
    return 90 / 2;
}
- (CGFloat)itemHorizontalMargin {
    return 70 / 2;
}

- (CGFloat)itemVerticalMargin {
    return 30 / 2;
}

- (CGFloat)itemLeft {
    return (SCREEN_WIDTH - [self iconViewWidth] * [self itemCol] - ([self itemCol] - 1) * [self itemHorizontalMargin]) / 2;
}
- (NSInteger)itemCol {
    return 4;
}

- (CGFloat)getListHeigt {
    NSInteger count = self.data.count - 1;
    NSInteger row = (count > 0 ? count : 0)  / [self itemCol];
    // ** item 顶部底部的高度 **/
    NSInteger listHeight = 2 * [self itemTopMargin];
    // ** item 总高度 **/
    listHeight = listHeight + (row + 1) * [self iconViewHeight];
    // ** item 中间总间距 **/
    listHeight = listHeight + row * [self itemVerticalMargin];
    return listHeight;
}

- (NSMutableArray *)itemFrames {
    if (!_itemFrames) {
        _itemFrames = [[NSMutableArray alloc] init];
    }
    return _itemFrames;
}
- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    [self.itemFrames removeAllObjects];
    for (ZRSWOrderMainTypeDetaolModel *cityModel in data) {
        if (cityModel.title.length > 0 && cityModel.mainTypeID.length > 0) {
            [titles addObject:cityModel.title];
            [ids addObject:cityModel.mainTypeID];
            
            ZRSWOrderMainTypeListItemFrame *frame = [[ZRSWOrderMainTypeListItemFrame alloc] init];
            NSInteger index = [data indexOfObject:cityModel];
            NSInteger row = index / [self itemCol];
            NSInteger col = index % [self itemCol];
            CGFloat item_x = [self itemLeft] + col * ([self iconViewWidth] + [self itemHorizontalMargin]);
            CGFloat item_y = [self itemTopMargin] + row * ([self iconViewHeight] + [self itemVerticalMargin]);
            frame.item_x = item_x;
            frame.item_y = item_y;
            frame.item_width = [self iconViewWidth];
            frame.item_height = [self iconViewHeight];
            [self.itemFrames addObject:frame];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:titles forKey:KOrderMainTypeListNameKey];
    [[NSUserDefaults standardUserDefaults] setValue:ids forKey:KOrderMainTypeListIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)getMainTypeTitles {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderMainTypeListNameKey];
}
+ (NSArray *)getMainTypeIDs {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderMainTypeListIDKey];
}

@end

@implementation ZRSWOrderLoanTypDetailModel

@end
@implementation ZRSWOrderLoanTypeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderLoanTypDetailModel class],
             };
}

- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    NSMutableArray *mainIds = [[NSMutableArray alloc] init];
    
    for (ZRSWOrderLoanTypDetailModel *cityModel in data) {
        if (cityModel.title.length > 0 && cityModel.loanID.length > 0) {
            [titles addObject:cityModel.title];
            [ids addObject:cityModel.loanID];
            [mainIds addObject:cityModel.mianLoanTypeID];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:titles forKey:KOrderLoanTypeListNameKey];
    [[NSUserDefaults standardUserDefaults] setValue:ids forKey:KOrderLoanTypeListIDKey];
    [[NSUserDefaults standardUserDefaults] setValue:mainIds forKey:KOrderLoanTypeListMainIDKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getOrderLoanTypeTitles {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListNameKey];
}
+ (NSMutableArray *)getOrderLoanTypeIDs {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListIDKey];
}
+ (NSMutableArray *)getOrderLoanTypeMainIds {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListMainIDKey];
}
@end

@implementation ZRSWOrderLoanInfoModel


@end

@implementation ZRSWOrderLoanHotProductModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderLoanInfoDetailModel class]
             };
}

@end

@implementation ZRSWOrderLoanInfoDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"loanTypeAttrs" : [ZRSWOrderLoanInfoAttrs class],
             @"loanCondition" : [ZRSWOrderLoanInfoCondition class]
             };
}
- (NSInteger)warpCount {
    return 1;
}
- (CGFloat)attrsTop {
    return 15;
}
- (CGFloat)attrsLeft {
    return 14;
}
- (CGFloat)attrsItemMargin {
    return 10;
}
- (CGFloat)attrsItemHeight {
    return 15;
}

- (CGFloat)titleHeight {
    NSString *title = self.title;
    CGFloat titleH = [title getSizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 2 * [self attrsLeft], CGFLOAT_MAX)].height;
    return titleH;
}
- (CGFloat)attrsCellHeight {
    
    NSInteger count = self.loanTypeAttrs.count;
    NSInteger height = [self attrsItemHeight];
    NSInteger space = [self attrsItemMargin];
    CGFloat max = (((count - 1) / [self warpCount]) + 1) * height +  ((count - 1) / [self warpCount]) * space;
    max = max + [self attrsTop] * 2;
    if (self.isNeedTittle) {
        max = max + [self titleHeight] + [self attrsItemMargin];
    }
    return max;
}

- (CGFloat)loanConditionsCellHeight {
    return [self.loanConditions getSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)].height + 30;
}
- (CGFloat)materialDetailsCellHeight {
    return [self.materialDetails getSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX)].height + 30;
}
@end
@implementation ZRSWOrderLoanInfoCondition


@end
@implementation ZRSWOrderLoanInfoAttrs


@end

@implementation ZRSWOrderListMainLoanTypeModel

@end

@implementation ZRSWOrderListLoanTypeModel

@end

@implementation ZRSWOrderListDetailModel
//审核中 #666666  已通过#4abd22 已放款#4771f2 已拒绝#ff5153 已完成#999999

//订单状态：-1：删除；0：待审核 ；1：初审通过； 2：初审未过；3：已放款（初审通过才能放款）；4：拒绝放款（初审通过的才能拒绝放款）
- (void)setStatus:(NSString *)status {
    _status = status;
    NSInteger s = status.integerValue;
    UIColor *color = [UIColor whiteColor];
    NSString *str = @"";
    switch (s) {
        case -1:  // 删除
            color = [UIColor colorFromHexRGB:@"666666"];
            break;
        case 0: // 待审核
        {
            color = [UIColor colorFromHexRGB:@"666666"];
            str = @"审核中";
        }
            break;
        case 1: // 已通过
        {
            color = [UIColor colorFromHexRGB:@"4abd22"];
            str = @"已通过";
        }
            break;
        case 2: // 初审未过
        {
            color = [UIColor colorFromHexRGB:@"ff5153"];
            str = @"已拒绝";
        }
            break;
        case 3: // 已放款（初审通过才能放款
        {
            color = [UIColor colorFromHexRGB:@"4771f2"];
            str = @"已放款";
        }
            break;
        case 4: // 拒绝放款（初审通过的才能拒绝放款）
        {
            color = [UIColor colorFromHexRGB:@"ff5153"];
            str = @"已拒绝";
        }
            break;
        default:
            break;
    }
    self.orderStatesColor = color;
    self.orderStatesStr = str;
}
@end
@implementation ZRSWOrderListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderListDetailModel class]
             };
}

@end

@implementation ZRSWCreateDetailModel

@end

@implementation ZRSWCreateModel

@end
