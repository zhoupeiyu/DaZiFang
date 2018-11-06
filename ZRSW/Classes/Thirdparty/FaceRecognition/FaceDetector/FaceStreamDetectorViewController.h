//
//  FaceStreamDetectorViewController.h
//  ZRSW
//
//  Created by King on 2018/10/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@protocol FaceDetectorDelegate <NSObject>

-(void)sendFaceImage:(UIImage *)faceImage; //上传图片成功
-(void)sendFaceImageError; //上传图片失败

@end

@interface FaceStreamDetectorViewController : UIViewController

@property (assign,nonatomic) id<FaceDetectorDelegate> faceDelegate;
@property (nonatomic, assign) BOOL isLogin;


@end
