//
//  UIView+MBProgressHUD.h
//  LFMBProgressHUDDemo
//
//  Created by WangZhiWei on 16/5/26.
//  Copyright © 2016年 youku. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface UIView (LFMBProgressHUDAdditions)


/*
 	@method
 	@discussion	显示转菊花
 */
- (void)lf_showHUDAnimated:(BOOL)animated;



/**
 	@method
 	@param 	message 消息内容
 */
- (void)lf_showHUDAnimated:(BOOL)animated message:(NSString *)message;

/**
 	@method
 	@param 	message 	消息内容
 	@param 	time 	延迟时间
 */
- (MBProgressHUD *)lf_showHUDAnimated:(BOOL)animated message:(NSString *)message dalayTime:(NSTimeInterval)time;

/*!
 @method
 @param 	message 	消息内容
 @param 	time 	延迟时间
 */
- (void)lf_showHUDMessage:(NSString *)message imageNamed:(NSString *)image animated:(BOOL)animated dalay:(NSTimeInterval)time;


/*
 	@method
 	@param 	animated
 */
- (void)lf_removeAllHUDAnimated:(BOOL)animated;


@end
