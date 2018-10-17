//
//  ZRSWMessageCountModel.h
//  ZRSW
//
//  Created by King on 2018/10/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"
@interface CountModel : NSObject

@property (nonatomic, assign) int msg_count;

@end
@interface ZRSWMessageCountModel : BaseModel
@property (nonatomic, strong)  CountModel *data;
@end
