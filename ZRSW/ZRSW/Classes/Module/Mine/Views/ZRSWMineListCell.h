//
//  ZRSWMineListCell.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSWMineModel.h"

@interface ZRSWMineListCell : UITableViewCell

@property (nonatomic, strong) ZRSWMineModel *model;

+ (instancetype)getCllWithTableView:(UITableView *)tableview;

@end
