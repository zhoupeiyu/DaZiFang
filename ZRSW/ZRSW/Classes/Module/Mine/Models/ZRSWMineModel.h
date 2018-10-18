//
//  ZRSWMineModel.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

typedef enum : NSUInteger {
    MineListTypeUserInfo,
    MineListTypeCommentList,
    MineListTypeSetting
} MineListType;

#import <Foundation/Foundation.h>

@interface ZRSWMineModel : NSObject
// 图片名字
@property (nonatomic, strong) NSString *iconName;
// 标题
@property (nonatomic, strong) NSString *title;
// 描述
@property (nonatomic, strong) NSString *desInfo;
// 类型
@property (nonatomic, assign) MineListType type;
// 已经登录
@property (nonatomic, assign) BOOL hasLogin;

// 控制器
@property (nonatomic, strong) NSString *viewControllerName;

@property (nonatomic, assign) BOOL bottomLineHidden;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger unreadCount;


@end
