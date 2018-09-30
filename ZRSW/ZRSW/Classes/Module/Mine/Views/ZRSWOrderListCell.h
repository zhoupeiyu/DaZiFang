//
//  ZRSWOrderListCell.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/29.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSWOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZRSWOrderListCell : UITableViewCell

+ (ZRSWOrderListCell *)getCellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (void)setListModel:(ZRSWOrderListDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
