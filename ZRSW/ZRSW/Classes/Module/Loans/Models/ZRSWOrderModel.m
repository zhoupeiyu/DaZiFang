//
//  ZRSWOrderModel.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/25.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWOrderModel.h"

#define KOrderMainTypeListNameKey               @"KOrderMainTypeListNameKey"
#define KOrderMainTypeListIDKey                 @"KOrderMainTypeListIDKey"

#define KOrderLoanTypeListNameKey               @"KOrderLoanTypeListNameKey"
#define KOrderLoanTypeListIDKey                 @"KOrderLoanTypeListIDKey"
#define KOrderLoanTypeListMainIDKey             @"KOrderLoanTypeListMainIDKey"


@implementation ZRSWOrderMainTypeDetaolModel

@end
@implementation ZRSWOrderMainTypeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderMainTypeDetaolModel class],
             };
}

- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    for (ZRSWOrderMainTypeDetaolModel *cityModel in data) {
        if (cityModel.title.length > 0 && cityModel.mainTypeID.length > 0) {
            [titles addObject:cityModel.title];
            [ids addObject:cityModel.mainTypeID];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:titles forKey:KOrderMainTypeListNameKey];
    [[NSUserDefaults standardUserDefaults] setValue:ids forKey:KOrderMainTypeListIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)getMainTypeTitles {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderMainTypeListNameKey];
}
+ (NSArray *)getMainTypeIDs {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderMainTypeListIDKey];
}

@end

@implementation ZRSWOrderLoanTypDetailModel

@end
@implementation ZRSWOrderLoanTypeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [ZRSWOrderLoanTypDetailModel class],
             };
}

- (void)setData:(NSArray *)data {
    _data = data;
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    NSMutableArray *mainIds = [[NSMutableArray alloc] init];
    
    for (ZRSWOrderLoanTypDetailModel *cityModel in data) {
        if (cityModel.title.length > 0 && cityModel.loanID.length > 0) {
            [titles addObject:cityModel.title];
            [ids addObject:cityModel.loanID];
            [mainIds addObject:cityModel.mianLoanTypeID];
        }
    }
    [[NSUserDefaults standardUserDefaults] setValue:titles forKey:KOrderLoanTypeListNameKey];
    [[NSUserDefaults standardUserDefaults] setValue:ids forKey:KOrderLoanTypeListIDKey];
    [[NSUserDefaults standardUserDefaults] setValue:mainIds forKey:KOrderLoanTypeListMainIDKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)getOrderLoanTypeTitles {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListNameKey];
}
+ (NSMutableArray *)getOrderLoanTypeIDs {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListIDKey];
}
+ (NSMutableArray *)getOrderLoanTypeMainIds {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KOrderLoanTypeListMainIDKey];
}
@end
