//
//  ZRSWUserInfoListModel.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "ZRSWUserInfoListModel.h"

@implementation ZRSWUserInfoListModel

- (void)setCellType:(UserInfoCellType)cellType {
    if (cellType == UserInfoCellTypeHeader) {
        self.cellHeight = 70;
    }
    else if (cellType == UserInfoCellTypeInfo) {
        self.cellHeight = 60;
    }
}
@end
