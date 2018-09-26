//
//  OrderService.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/13.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseNetWorkService.h"

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

@end
