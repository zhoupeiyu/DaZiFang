//
//  OrderService.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/13.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseNetWorkService.h"

typedef enum : NSUInteger {
    OrderTypeAll, // 全部
    OrderTypeUnderReview, // 审核中
    OrderTypePass, // 已通过
    OrderTypeCredit,// 已放款
    OrderTypeRefuse // 已拒绝
} OrderType;

@interface OrderService : BaseNetWorkService

/**
 获取城市列表
 
 @param delegate 代理
 */
- (void)getCityListDelegate:(id)delegate;


/**
 查询指定城市下贷款大类列表接口

 @param cityID 城市ID
 */
- (void)getOrderMainTypeList:(NSString *)cityID delegate:(id)delegate;


/**
 贷款产品列表接口

 @param mainTypeId 贷款大类id
 @param delegate 代理
 */
- (void)getOrderLoanTypeList:(NSString *)mainTypeId delegate:(id)delegate;


/**
 贷款详情

 @param loanId 产品类型
 @param delegate 代理
 */
- (void)getLoanDetailInfo:(NSString *)loanId delegate:(id)delegate;



/**
 订单列表

 @param lastId 最后一个ID
 @param orderStatus 订单状态
 @param delegate 代理
 */
- (void)getOrderList:(NSString *)lastId orderStatus:(NSInteger)orderStatus delegate:(id)delegate;


/**
 下单

 @param loanId 贷款产品Id
 @param loanUserName 实际贷款人姓名（长度小于128字符）
 @param loanUserSex 性别：1：男；2：女；
 @param loanUserAddress 实际贷款人所在区域地址（长度小于150字符）
 @param loanUserPhone 实际贷款人电话
 @param loanMoney 贷款金额（ps:接口开发时将此字段存储在loanUserIdCard中，此为旧版新闻）
 @param remark 备注
 @param condition 贷款所需材料：字段名为产品详情接口中返回的贷款材料id(conditionID)，值为用户上传的材料图片URL，多个URL使用英文逗号分隔；如果需要对多种材料进行上传，请分别使用对应的材料id(conditionID) ；ex: CON0001=身份证正面.jpg,身份证反面.jpg&CON002=房产证.jpg
 */
- (void)createOrderLoanId:(NSString *)loanId loanUserName:(NSString *)loanUserName loanUserSex:(NSInteger)loanUserSex loanUserAddress:(NSString *)loanUserAddress loanUserPhone:(NSString *)loanUserPhone loanMoney:(NSString *)loanMoney remark:(NSString *)remark condition:(NSMutableArray *)condition delegate:(id)delegate;

@end
