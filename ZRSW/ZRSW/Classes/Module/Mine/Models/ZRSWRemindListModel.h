//
//  ZRSWRemindListModel.h
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZRSWRemindModel : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *sendTime;
@end

@interface ZRSWRemindListModel : BaseModel
@property (nonatomic, strong) NSArray *data;

@end
