//
//  ZRSWShareModel.h
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRSWShareModel : NSObject
//标题
@property (nonatomic, strong) NSString *title;
//内容
@property (nonatomic, strong) NSString *content;
//缩略图
@property (nonatomic, strong) UIImage *thumbImage;
//缩略图 URL
@property (nonatomic, strong) NSString *thumImageUrlStr;

@property (nonatomic, strong) NSString *sourceUrlStr;

//微博图片
@property (nonatomic, strong) UIImage *weiboImage;

@end
