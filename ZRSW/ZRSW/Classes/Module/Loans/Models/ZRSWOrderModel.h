//
//  ZRSWOrderModel.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/25.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRSWOrderMainTypeDetaolModel : NSObject

//贷款大类id
@property (nonatomic, strong) NSString *mainTypeID;
//贷款大类主标题
@property (nonatomic, strong) NSString *title;
//贷款大类副标题
@property (nonatomic, strong) NSString *subTitle;
// 贷款大类背景图URL
@property (nonatomic, strong) NSString *bgImgUrl;
// 贷款大类小icon
@property (nonatomic, strong) NSString *thumbImgUrl;

@end
@interface ZRSWOrderMainTypeListModel : BaseModel

@property (nonatomic, strong) NSArray *data;

@end

@interface ZRSWOrderLoanTypDetailModel : NSObject
// 产品id
@property (nonatomic, strong) NSString *loanID;
//贷款大类id
@property (nonatomic, strong) NSString *mianLoanTypeID;
//产品标题
@property (nonatomic, strong) NSString *title;
// 产品副标题
@property (nonatomic, strong) NSString *subTitle;

@end
@interface ZRSWOrderLoanTypeListModel : BaseModel
@property (nonatomic, strong) NSArray *data;
@end
