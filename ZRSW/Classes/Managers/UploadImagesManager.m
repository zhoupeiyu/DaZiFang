//
//  UploadImagesManager.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "UploadImagesManager.h"
#import "BaseUploadModel.h"

@implementation UploadImages

@end

@interface UploadImagesManager ()

@property (nonatomic, copy) UploadImagesCompleteBlock completeBlock;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *imagesUrls;
@property (nonatomic,strong) NSMutableArray * signArr;
@property (nonatomic, strong) NSMutableArray *uploadImageModelArr;
@property (nonatomic, strong) NSString *mainType;

@end
@implementation UploadImagesManager

SYNTHESIZE_SINGLETON_ARC(UploadImagesManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainType = @"image/jpg";
        _signArr = [[NSMutableArray alloc] init];
        _imagesUrls = [[NSMutableArray alloc] init];
        _uploadImageModelArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)uploadImagesWithImagesArray:(NSArray *)images completeBlock:(UploadImagesCompleteBlock)completeBlock {
    self.images = images;
    self.completeBlock = completeBlock;
    [self startUploadImages];
}

- (void)startUploadImages {
    for (int i = 0; i < _images.count; i ++) {
        [self performSelector:@selector(uploadFileWithImage:) withObject:[NSNumber numberWithInt:i] afterDelay:i*0.3];
    }
}
- (void)uploadFileWithImage:(NSNumber * )index{
    NSInteger i = [index integerValue];
    UIImage *image = self.images[i];
    UploadImages *model = [[UploadImages alloc] init];
    model.image = image;
    model.index = i;
    WS(weakSelf);
    __block NSURLSessionTask *task = [HYBNetworking uploadWithImage:image url:self.url filename:@"" name:self.name mimeType:self.mainType parameters:nil progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
    } success:^(id response) {
        UploadImageModel *model = [UploadImageModel yy_modelWithJSON:response];
        model.task = task;
        [weakSelf.uploadImageModelArr addObject:model];
        if (weakSelf.uploadImageModelArr.count == weakSelf.signArr.count) {
            for (NSInteger index = 0; index < weakSelf.signArr.count; index ++) {
                UploadImages *model = weakSelf.signArr[index];
                for (UploadImageModel *imageModel in weakSelf.uploadImageModelArr) {
                    if (model.task == imageModel.task) {
                        [weakSelf.imagesUrls addObject:imageModel.data.fileUrl];
                        LLog(@"fileUrl:%@",imageModel.data.fileUrl);
                    }
                }
            }
            
            if (weakSelf.completeBlock) {
                weakSelf.completeBlock(weakSelf.imagesUrls);
                [weakSelf.imagesUrls removeAllObjects];
                [weakSelf.signArr removeAllObjects];
                [weakSelf.uploadImageModelArr removeAllObjects];
            }
        }
        
    } fail:^(NSError *error) {
        LLog(@"图片上传失败！");
    }];
    model.task = task;
    [self.signArr addObject:model];
}

- (void)setImageType:(UploadImageType)imageType {
    if (imageType == UploadImageTypePng) {
        self.mainType = @"image/png";
    }
    else if (imageType == UploadImageTypeJpg) {
        self.mainType = @"image/jpg";
    }
    else if (imageType == UploadImageTypeJpeg) {
        self.mainType = @"image/jpeg";
    }
}

@end
