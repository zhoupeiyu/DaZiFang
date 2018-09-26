//
//  OrderService.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/13.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "OrderService.h"
#import "ZRSWOrderModel.h"

@implementation OrderService

- (void)getCityListDelegate:(id)delegate {
    [self POST:KCityListInterface reqType:KCityListRequest delegate:delegate parameters:nil ObjcClass:[CityListModel class] NeedCache:NO];
}

- (void)getOrderMainTypeList:(NSString *)cityID delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (cityID.length > 0) {
        [params setObject:cityID forKey:@"cityId"];
    }
    [self POST:KGetOrderMainTypeListInterface reqType:KGetOrderMainTypeListRequest delegate:delegate parameters:params ObjcClass:[ZRSWOrderMainTypeListModel class] NeedCache:NO];

}

- (void)getOrderLoanTypeList:(NSString *)mainTypeId delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (mainTypeId.length > 0) {
        [params setObject:mainTypeId forKey:@"mainTypeId"];
    }
    [self POST:KGetOrderLoanTypeListInterface reqType:KGetOrderLoanTypeListRequest delegate:delegate parameters:params ObjcClass:[ZRSWOrderLoanTypeListModel class] NeedCache:NO];

}
- (void)getLoanDetailInfo:(NSString *)loanId delegate:(id)delegate {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (loanId.length > 0) {
        [params setObject:loanId forKey:@"loanId"];
    }
    [self POST:KGetOrderLoanInfoInterface reqType:KGetOrderLoanInfoRequest delegate:delegate parameters:params ObjcClass:[ZRSWOrderLoanInfoModel class] NeedCache:NO];

}
@end
