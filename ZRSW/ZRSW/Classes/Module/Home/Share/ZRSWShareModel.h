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
//用户模块
@property (nonatomic, strong) NSString *userContent;
//缩略图
@property (nonatomic, strong) UIImage *thumbImage;
//缩略图 URL
@property (nonatomic, strong) NSString *thumImageUrl;

@property (nonatomic, strong) NSString *destUrlStr;

//视频id
@property (nonatomic, strong) NSNumber *vid;
//直播id
@property (nonatomic, strong) NSNumber *liveVid;
//微博图片
@property (nonatomic, strong) UIImage *weiboImage;

@end
