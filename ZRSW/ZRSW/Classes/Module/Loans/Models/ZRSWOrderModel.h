//
//  ZRSWOrderModel.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/25.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRSWOrderMainTypeListItemFrame : NSObject
@property (nonatomic, assign) CGFloat item_x;
@property (nonatomic, assign) CGFloat item_y;
@property (nonatomic, assign) CGFloat item_width;
@property (nonatomic, assign) CGFloat item_height;
@end
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

- (CGFloat)iconViewWidth;

// ** 每个item 的位置 **/
@property (nonatomic, strong) NSMutableArray <ZRSWOrderMainTypeListItemFrame *> *itemFrames;

// ** cell 高 **/
- (CGFloat)getListHeigt;

+ (NSMutableArray *)getMainTypeTitles;
+ (NSMutableArray *)getMainTypeIDs;

@end

@class ZRSWOrderLoanInfoAttrs;
@interface ZRSWOrderLoanTypDetailModel : NSObject
// 产品id
@property (nonatomic, strong) NSString *loanID;
//贷款大类id
@property (nonatomic, strong) NSString *mianLoanTypeID;
//产品标题
@property (nonatomic, strong) NSString *title;
// 产品副标题
@property (nonatomic, strong) NSString *subTitle;
// ** 属性 **/
@property (nonatomic, strong) NSArray <ZRSWOrderLoanInfoAttrs *> *loanTypeAttrs;

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

// ** 是否需要标题 **/
@property (nonatomic, assign) BOOL isNeedTittle;

- (NSInteger)warpCount;
- (CGFloat)attrsTop;
- (CGFloat)attrsLeft;
- (CGFloat)attrsItemMargin;
- (CGFloat)attrsItemHeight;
- (CGFloat)attrsCellHeight;
- (CGFloat)titleHeight;

- (CGFloat)loanConditionsCellHeight;
- (CGFloat)materialDetailsCellHeight;

@end
@interface ZRSWOrderLoanInfoModel :BaseModel

@property (nonatomic, strong) ZRSWOrderLoanInfoDetailModel *data;

@end

@interface ZRSWOrderLoanProductListModel : BaseModel
@property (nonatomic, strong) NSArray *data;

@end

@interface ZRSWOrderLoanHotProductModel  : BaseModel

@property (nonatomic, strong) NSArray *data;
@end

@interface ZRSWOrderListMainLoanTypeModel : NSObject
//大类id；
@property (nonatomic, strong) NSString *mainTypeID;
//贷款标题
@property (nonatomic, strong) NSString *title;
//贷款副标题
@property (nonatomic, strong) NSString *subTitle;

@end

@interface ZRSWOrderListLoanTypeModel : NSObject
//产品id
@property (nonatomic, strong) NSString *loanID;
//大类id
@property (nonatomic, strong) NSString *mianLoanTypeID;
//贷款标题
@property (nonatomic, strong) NSString *title;
//贷款副标题
@property (nonatomic, strong) NSString *subTitle;

@end

@interface ZRSWOrderListDetailModel : NSObject
//订单id，唯一标识
@property (nonatomic, strong) NSString *id;
//订单号，展示给用户的唯一标识
@property (nonatomic, strong) NSString *orderId;
// 贷款人姓名
@property (nonatomic, strong) NSString *loanUserName;
// 贷款人性别：1：男；2：女
@property (nonatomic, strong) NSString *loanUserSex;
// 贷款人电话
@property (nonatomic, strong) NSString *loanUserPhone;
//贷款人城市区域
@property (nonatomic, strong) NSString *loanUserAddress;

//实际贷款金额，带单位
@property (nonatomic, strong) NSString *reallyLoanMoney;
//实际还款金额，带单位
@property (nonatomic, strong) NSString *loanMoney;

//订单状态：-1：删除；0：待审核 ；1：初审通过； 2：初审未过；3：已放款（初审通过才能放款）；4：拒绝放款（初审通过的才能拒绝放款）
@property (nonatomic, strong) NSString *status;
//贷款产品
@property (nonatomic, strong) ZRSWOrderListLoanTypeModel *loanType;
//贷款所属大类
@property (nonatomic, strong) ZRSWOrderListMainLoanTypeModel *mainLoanType;


@property (nonatomic, strong) UIColor *orderStatesColor;
@property (nonatomic, strong) NSString *orderStatesStr;
@end
@interface ZRSWOrderListModel  :BaseModel

@property (nonatomic, strong) NSArray *data;

@end


@interface ZRSWCreateDetailModel : NSObject
@property (nonatomic, strong) NSString *orderId;
@end
@interface ZRSWCreateModel : BaseModel
@property (nonatomic, strong) ZRSWCreateDetailModel *data;
@end
