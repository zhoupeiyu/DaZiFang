//
//  ZRSWAchieveFilterTableView.h
//  ZRSW
//
//  Created by King on 2018/9/30.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRSWAchieveFilterTableView : UITableView

@property (nonatomic, copy) void (^ZRSWAchieveFilterViewClickBlk)(NSString *);
/** 数据源 */
@property (nonatomic, strong) NSArray<NSString *> *dataArray;

@end
