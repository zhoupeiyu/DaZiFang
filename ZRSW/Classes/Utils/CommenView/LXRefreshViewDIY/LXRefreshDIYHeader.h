//
//  LXRefreshDIYHeader.h
//  LXCoffee
//
//  Created by HU on 15/8/21.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface LXRefreshDIYHeader : MJRefreshHeader
@property (nonatomic ,strong)NSString *strStateIdle;
@property (nonatomic ,strong)NSString *strStateRefresh;
@property (nonatomic ,strong)NSString *strStatePulling;

@end
