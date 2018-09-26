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

+ (NSMutableArray *)getMainTypeTitles;
+ (NSMutableArray *)getMainTypeIDs;

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

+ (NSMutableArray *)getOrderLoanTypeTitles;
+ (NSMutableArray *)getOrderLoanTypeIDs;
+ (NSMutableArray *)getOrderLoanTypeMainIds;

@end


#pragma mark - 详情

@interface ZRSWOrderLoanInfoAttrs : NSObject
//产品属性名称
@property (nonatomic, strong) NSString *attrName;
//产品属性对应的值
@property (nonatomic, strong) NSString *attrVal;

@end
@interface ZRSWOrderLoanInfoCondition : NSObject
//材料id
@property (nonatomic, strong) NSString *conditionID;
//材料标题说明
@property (nonatomic, strong) NSString *title;
//示例图片列表
@property (nonatomic, strong) NSArray *exampleImgUrls;

@end
@interface ZRSWOrderLoanInfoDetailModel : NSObject
//产品id
@property (nonatomic, strong) NSString *loanID;
//贷款大类id
@property (nonatomic, strong) NSString *mianLoanTypeID;
//产品标题
@property (nonatomic, strong) NSString *title;
//产品副标题
@property (nonatomic, strong) NSString *subTitle;
//产品线下办理地址
@property (nonatomic, strong) NSString *offlineAddress;
//贷款条件说明：富文本
@property (nonatomic, strong) NSString *loanConditions;
//贷款需要准备的材料说明：富文本
@property (nonatomic, strong) NSString *materialDetails;
//放款流程图片URL
@property (nonatomic, strong) NSString *loanFlowWechatUri;
//产品属性
@property (nonatomic, strong) NSArray <ZRSWOrderLoanInfoAttrs *>*loanTypeAttrs;
//贷款需要的材料列表
@property (nonatomic, strong) NSArray <ZRSWOrderLoanInfoCondition *>*loanCondition;

- (NSInteger)warpCount;
- (CGFloat)attrsTop;
- (CGFloat)attrsLeft;
- (CGFloat)attrsItemMargin;
- (CGFloat)attrsItemHeight;
- (CGFloat)attrsCellHeight;


@end
@interface ZRSWOrderLoanInfoModel :BaseModel

@property (nonatomic, strong) ZRSWOrderLoanInfoDetailModel *data;

@end
