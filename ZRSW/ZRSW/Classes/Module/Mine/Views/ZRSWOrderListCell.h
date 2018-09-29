//
//  ZRSWOrderListCell.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/29.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZRSWOrderListCell : UITableViewCell

+ (ZRSWOrderListCell *)getCellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
