//
//  UIButton+Help.h
//  Tuotuo
//
//  Created by Apple on 14-1-14.
//  Copyright (c) 2014年 Gaialine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Help)


- (void)buttonWithNormalImageName:(NSString *)normalImageName
                         highlightedImageName:(NSString *)highlightedImageName
                                   edgeInsets:(UIEdgeInsets)edgeInsets
                               layerImageName:(NSString *)layerImageName
                                    titleName:(NSString *)titleName
                                    titleFont:(float)titleFont
                                       target:(id)target
                                       action:(SEL)sel;

- (void)buttonWithSelectedImageName:(NSString*)selectedImageName
                          disabledImageName:(NSString*)disabledImageName
                                 edgeInsets:(UIEdgeInsets)edgeInsets;

- (void)buttonWithNormalTitleColor:(UIColor *)normalColor
                     highlightedTitleColor:(UIColor *)highlightedColor;



+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                       target:(id)target
                       action:(SEL)action;

+(UIButton *)buttonWithImage:(UIImage *)image target:(id)target
                      action:(SEL)action frame:(CGRect)frame;

+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action andFrmae:(CGRect)frmae;

+ (UIButton*)buttonWithImage:(UIImage *)image slectedImage:(UIImage*)seletedImage target:(id)target action:(SEL)action frame:(CGRect)frame;


+ (UIButton *)buttonWithtarget:(id)target
                        action:(SEL)action frame:(CGRect)frame;

- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
+ (UIButton *)genButtonWithArrow:(NSString *)arrowName bgImage:(NSString *)bgImageName;



@end
