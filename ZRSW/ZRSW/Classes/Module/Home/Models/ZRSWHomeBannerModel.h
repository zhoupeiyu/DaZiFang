//
//  ZRSWHomeBannerModel.h
//  ZRSW
//
//  Created by King on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseModel.h"
@interface HomeBannerModelDetails : NSObject
//banner id
@property (nonatomic, strong) NSString *id;
//标题
@property (nonatomic, strong) NSString *title;
//banner图片URL
@property (nonatomic, strong) NSString *imgUrl;
// banner点击跳转地址，为空时点击不跳转
@property (nonatomic, strong) NSString *href;
@end

@interface ZRSWHomeBannerModel : BaseModel
@property (nonatomic, strong) NSArray *data;

@end
