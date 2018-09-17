//
//  UIColor+Utility.h
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

//16进制色值转换 0xf4f4f4
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(NSInteger)hexValue;

//字体颜色汇总

/** 0x131313 */
+ (UIColor *)getFontThirteenGrayColor;

/** 0x999999 */
+ (UIColor *)getFontNineGrayColor;

/** 0x888888 */
+ (UIColor *)getFontEightGrayColor;

/** 0x646464 */
+ (UIColor *)getFontSixGrayColor;

/** 0xe84147 */
+ (UIColor *)getFontRedPressedColor;

/** 标准蓝 0x0099ff*/
+ (UIColor *)getFontBlueColor;

/** 标准蓝 0x0081f2*/
+ (UIColor *)getFontPressesBlueColor;

+ (UIColor *)getFontPressesWhiteColor;


/** 标准红 */
+ (UIColor *)getFontRedColor;

/** 黑色 */
+ (UIColor *)getFontBlackColor;

/** 白色 */
+ (UIColor *)getFontWhiteColor;

+ (UIColor *)baseLineColor;

 /** 白色 */
+ (UIColor *)getRandomColor;

+ (UIColor *)getB5Color;

/** 背景色 */
+ (UIColor *)getBackgroundColor;//0xf4f4f4

+ (UIColor *)getBackgroundBlueColor;//0x0099ff
+ (UIColor *)disablebackColor;

+ (UIColor *)getCoffeePriseColor;

+ (UIColor *)getF8BackgroundColor;

// 0xf5f5f5
+ (UIColor *)getCellSelectedViewColor;
//dfdfdf
+ (UIColor *)getTopAndBottomSepColor;
+ (UIColor *)getSliderBackColor;
+ (UIColor *)getAgreeBlueColor;
//16进制色值转换 0xf4f4f4

+ (UIColor *)colorFromRGB:(NSInteger)rgbValue;
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;
//二级导航 和 模块分割线
+ (UIColor *)getSeparatorColor;

// 高考蓝色 中考绿色
+ (UIColor *)getCustomBlueOrGreenColor;
+ (UIColor *)getFontPressedColor;

+ (UIColor *)coffeeReplayColor;
+ (UIColor *)downloadProgressColor;

@end
