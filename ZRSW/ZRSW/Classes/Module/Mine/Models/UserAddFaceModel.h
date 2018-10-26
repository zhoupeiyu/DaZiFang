//
//  UserAddFaceModel.h
//  ZRSW
//
//  Created by King on 2018/10/22.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"

@interface AddFaceModel : NSObject
@property (nonatomic, strong) NSString *successMsg;
@end
@interface UserAddFaceModel : BaseModel
@property (nonatomic, strong) AddFaceModel *data;
@end
