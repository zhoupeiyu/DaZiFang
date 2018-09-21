//
//  ZRSWBillListModel.h
//  ZRSW
//
//  Created by King on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"

@interface ZRSWBillModel : NSObject
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSString *reg_time;
@property (nonatomic, strong) NSString *last_login_time;
@end

@interface ZRSWBillListModel : BaseModel
@property (nonatomic, strong) NSArray *data;
@end
