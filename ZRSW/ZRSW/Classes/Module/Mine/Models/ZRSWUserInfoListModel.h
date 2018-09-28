//
//  ZRSWUserInfoListModel.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UserInfoCellTypeHeader,
    UserInfoCellTypeInfo
} UserInfoCellType;

NS_ASSUME_NONNULL_BEGIN

@interface ZRSWUserInfoListModel : NSObject

@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, assign) UserInfoCellType cellType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desTitle;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) NSInteger cellHeight;

@end

NS_ASSUME_NONNULL_END
