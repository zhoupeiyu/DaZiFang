//
//  UploadImagesManager.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UploadImageTypePng,
    UploadImageTypeJpg,
    UploadImageTypeJpeg,
} UploadImageType;
typedef void(^UploadImagesCompleteBlock)(NSMutableArray* _Nullable imageUrls);

NS_ASSUME_NONNULL_BEGIN

@interface UploadImages : NSObject

@property (nonatomic,strong) UIImage * image;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@interface UploadImagesManager : NSObject

@property (nonatomic, assign) UploadImageType imageType;
// 这个字段对应后台参数 例如:“file”
@property (nonatomic, strong) NSString *name;
// 这个是上传地址，如果设置基地址，则不需要s传入全地址
@property (nonatomic, strong) NSString *url;

+ (UploadImagesManager *)sharedInstance;

- (void)uploadImagesWithImagesArray:(NSArray *)images completeBlock:(UploadImagesCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
