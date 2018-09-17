//
//  UIColor+Utility.m
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)


+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
	
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}
+ (UIColor *)colorWithHex:(NSInteger)hexValue {
	
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:1.0];
}
+ (UIColor *)getFontThirteenGrayColor {
    
    return [UIColor colorWithHex:0x131313];
}

+ (UIColor *)getB5Color {
    
    return [UIColor colorWithHex:0xB5B5B5];
}
+ (UIColor *)getFontNineGrayColor {
	
	return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)getSeparatorColor {
    return [UIColor colorFromRGB:0xE8E8E8];
    
}
+ (UIColor *)baseLineColor{
    return [UIColor colorWithHex:0xe8e8e8 alpha:1.0];
}

+ (UIColor *)disablebackColor{
	
#ifdef Zhongkao
	 return [UIColor colorWithHex:0x45B233 alpha:0.4];
#else
	 return [UIColor colorWithHex:0x0099ff alpha:0.4];
#endif
}

+ (UIColor *)coffeeReplayColor{
    
#ifdef Zhongkao
    return [UIColor colorWithHex:0x45B233 alpha:0.1];
#else
    return [UIColor colorWithHex:0x0099ff alpha:0.1];
#endif
}

+ (UIColor *)downloadProgressColor{
    
#ifdef Zhongkao
    return [UIColor colorWithHex:0x45B233 alpha:0.2];
#else
    return [UIColor colorWithHex:0x0099ff alpha:0.2];
#endif
}

+ (UIColor *)getFontEightGrayColor {
	
	return [UIColor colorFromRGB:0x888888];
}
+ (UIColor *)getFontSixGrayColor {
	
	return [UIColor colorFromRGB:0x646464];
}
+ (UIColor *)getFontBlueColor {
	
#ifdef Zhongkao
	return [UIColor colorFromRGB:0x45B233];
#else
	return [UIColor colorFromRGB:0x0099ff];
#endif
}
+ (UIColor *)getFontPressesBlueColor {
#ifdef Zhongkao
    return [UIColor colorFromRGB:0x3ea02e];
#else
    return [UIColor colorFromRGB:0x0081f2];
#endif
}
+ (UIColor *)getFontPressesWhiteColor {
    return [UIColor colorFromRGB:0xeaeaea];
}

+ (UIColor *)getAgreeBlueColor {
#ifdef Zhongkao
    return [UIColor colorFromRGB:0x45B233];
#else
    return [UIColor colorFromRGB:0x1D59B2];
#endif
}

+ (UIColor *)getFontRedPressedColor {
    return [UIColor colorFromRGB:0xe84147];
}
+ (UIColor *)getFontRedColor {
    return [UIColor colorFromRGB:0xf6444b];
}
+ (UIColor *)getFontBlackColor {
	return [UIColor colorFromRGB:0x131313];
}

+ (UIColor *)getFontWhiteColor {
	return [UIColor colorFromRGB:0xffffff];

}

+ (UIColor *)getBackgroundColor {
	return [UIColor colorWithHex:0xf4f4f4];
}

+ (UIColor *)getF8BackgroundColor {
    return [UIColor colorWithHex:0xf8f8f8];
}

+ (UIColor *)getCellSelectedViewColor {
    return [UIColor colorWithHex:0xf9f9f9];
}
+ (UIColor *)getBackgroundBlueColor {
#ifdef Zhongkao
	return [UIColor colorFromRGB:0x45B233];
#else
	return [UIColor colorFromRGB:0x0099ff];
#endif
}

+ (UIColor *)getCoffeePriseColor {
    return [UIColor colorFromRGB:0xf56060];
}

+ (UIColor *)getTopAndBottomSepColor {
	return [UIColor colorFromRGB:0xdfdfdf];
}

+ (UIColor *)getSliderBackColor {
    return [UIColor colorFromRGB:0xCDCDCD];
}

+ (UIColor *)colorFromRGB:(NSInteger)rgbValue {
	return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.f
						   green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.f
							blue:((float)(rgbValue & 0x0000FF)) / 255.f alpha:1.f];
}
+(UIColor *) colorFromHexRGB:(NSString *) inColorString
{
	UIColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode]; // ignore error
	}
	redByte = (unsigned char) (colorCode >> 16);
	greenByte = (unsigned char) (colorCode >> 8);
	blueByte = (unsigned char) (colorCode); // masks off high bits
	result = [UIColor
			  colorWithRed: (float)redByte / 0xff
			  green: (float)greenByte/ 0xff
			  blue: (float)blueByte / 0xff
			  alpha:1.0];
	return result;
}
+ (UIColor *)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+ (UIColor *)getCustomBlueOrGreenColor {
    return [self getFontBlueColor];
}
//中考绿，高考蓝字对于的点击高亮色
+ (UIColor *)getFontPressedColor {
#ifdef Zhongkao
	return [UIColor colorFromRGB:0x41a930];
#else
	return [UIColor colorFromRGB:0x0583d1];
#endif
}
@end
