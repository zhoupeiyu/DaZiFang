//
//  UIImage+Utility.h
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImageSizeRequestCompleted) (NSURL* imgURL, CGSize size);

@interface UIImage (Utility)

//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//图片改变尺寸
- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)stretchImage;

- (UIImage *)compressImage;

/**
 异步切圆角
 
 @param size 指定目标图片尺寸
 @param fillColor 填充背景颜色
 @param completion 完成返回图片回掉
 */
- (void)connerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;

//截屏
+(instancetype)snapshotCurrentScreen;

//图片模糊效果
- (UIImage *)blur;

//高效添加圆角图片
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

//圆形图片
+ (UIImage *)GetRoundImagewithImage:(UIImage *)image;

//在图片上加居中的文字
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor;

/**
 取图片某一像素点的颜色
 
 @param point 图片上的某一点
 @return 图片上这一点的颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 生成一个纯色的图片
 
 @param color 图片颜色
 @return 返回的纯色图片
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/** 获得灰度图 */
- (UIImage *) convertToGrayImage;


+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)theData;
+ (UIImage *)animatedImageWithAnimatedGIFURL:(NSURL *)theURL;


/** 合并两个图片为一个图片 */
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;

/** 压缩图片 最大字节大小为maxLength */
- (NSData *)compressWithMaxLength:(NSInteger)maxLength;

/** 纠正图片的方向 */
- (UIImage *)fixOrientation;

/** 按给定的方向旋转图片 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/** 垂直翻转 */
- (UIImage *)flipVertical;

/** 水平翻转 */
- (UIImage *)flipHorizontal;

/** 将图片旋转degrees角度 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** 将图片旋转radians弧度 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;


/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;

//带有阴影效果的图片
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;

- (UIImage *)maskImageFromImageAlpha;

#pragma mark -
- (instancetype)imageWithOverlayColor:(UIColor *)overlayColor;

#pragma mark -
- (UIImage *)imageWithGaussianBlur9;
- (UIImage *)croppIngimageToRect:(CGRect)rect;
- (UIImage *) addImageToImage:(UIImage *)img withImage2:(UIImage *)img2 andRect:(CGRect)cropRect forSize:(CGSize)size;
- (UIImage *)blurImageWithFloat:(float)blurFloat;
- (UIImage *)getImage:(UIView *)view;
+ (UIImage*) createImageWithColor: (UIColor*) color;
+ (UIImage*) createXImageWithColor: (UIColor*) color;
- (UIImage *)croppNewImage;

+ (UIImage*)resizeImage:(UIImage *)image toSize:(CGSize)size;

@end
