//
//  UIButton+help.m
//  Tuotuo
//
//  Created by Apple on 14-1-14.
//  Copyright (c) 2014年 Gaialine. All rights reserved.
//

#import "UIButton+Help.h"
#import <objc/runtime.h>

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

@implementation UIButton (Help)



- (void)buttonWithNormalTitleColor:(UIColor *)normalColor
                     highlightedTitleColor:(UIColor *)highlightedColor{
    normalColor = normalColor ? normalColor : [UIColor whiteColor];
    highlightedColor = highlightedColor ? highlightedColor : [UIColor whiteColor];
    
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                       target:(id)target
                       action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
    
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
+ (UIButton *)buttonWithImage:(UIImage *)image target:(id)target
                       action:(SEL)action frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setBackgroundImage:image forState:UIControlStateSelected];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
+ (UIButton *)genButtonWithArrow:(NSString *)arrowName bgImage:(NSString *)bgImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *bgImage = [UIImage imageNamed:bgImageName];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    
    UIImage *image = [UIImage imageNamed:arrowName];
    [button setImage:image forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    return button;
}
+ (UIButton *)buttonWithtarget:(id)target
                       action:(SEL)action frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action andFrmae:(CGRect)frmae;
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:frmae];
    return btn;
}
+ (UIButton*)buttonWithImage:(UIImage *)image slectedImage:(UIImage*)seletedImage target:(id)target action:(SEL)action frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:seletedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:seletedImage forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }
    else
    {
        return self.bounds;
    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}
/*
 - (UIView*)hitTest:(CGPoint) point withEvent:(UIEvent*) event
 {
 CGRect rect = [self enlargedRect];
 if (CGRectEqualToRect(rect, self.bounds))
 {
 return [super hitTest:point withEvent:event];
 }
 return CGRectContainsPoint(rect, point) ? self : nil;
 }*/
@end
