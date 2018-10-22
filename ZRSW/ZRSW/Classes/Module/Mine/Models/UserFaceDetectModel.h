//
//  UserFaceDetectModel.h
//  ZRSW
//
//  Created by King on 2018/10/22.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"

@interface FaceTokenModel : NSObject
@property (nonatomic, strong) NSString *faceToken;
@end
@interface UserFaceDetectModel : BaseModel
@property (nonatomic, strong) FaceTokenModel *data;
@end
