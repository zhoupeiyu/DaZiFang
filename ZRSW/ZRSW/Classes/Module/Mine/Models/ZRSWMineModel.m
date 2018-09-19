//
//  ZRSWMineModel.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWMineModel.h"

@implementation ZRSWMineModel

- (void)setType:(MineListType)type {
    _type = type;
    self.cellHeight = type == MineListTypeUserInfo ? 70 : 60;
}
@end
