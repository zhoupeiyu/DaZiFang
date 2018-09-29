//
//  ZRSWUserInfoCell.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSWUserInfoListModel.h"

@class ZRSWUserInfoCell;



NS_ASSUME_NONNULL_BEGIN

@interface ZRSWUserInfoCell : UITableViewCell

+ (ZRSWUserInfoCell *)getCellWithTableView:(UITableView *)tableView;

- (void)setUserInfoListModel:(ZRSWUserInfoListModel *)model;

- (void)setHeaderImageUrl:(NSString *)headerImageUrl;

@end

NS_ASSUME_NONNULL_END
