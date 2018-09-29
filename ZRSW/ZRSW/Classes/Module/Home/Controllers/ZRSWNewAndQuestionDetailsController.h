//
//  ZRSWNewAndQuestionDetailsController.h
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseScrollViewController.h"
#import "EnumType.h"
#import "UserModel.h"
@interface ZRSWNewAndQuestionDetailsController :BaseScrollViewController
@property (nonatomic, assign) DetailsType type;
@property (nonatomic, strong) NewDetailModel *detailModel;
@property (nonatomic, strong) CommentQuestionModel *questionModel;
@end
