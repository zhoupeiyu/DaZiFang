//
//  UIAlertController+Extension.m
//  LXMath
//
//  Created by 周培玉 on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)

- (NSArray *)viewArray:(UIView *)root {
    static NSArray *_subviews = nil;
    _subviews = nil;
    for (UIView *v in root.subviews) {
        if (_subviews) {
            break;
        }
        if ([v isKindOfClass:[UILabel class]]) {
            _subviews = root.subviews;
            return _subviews;
        }
        [self viewArray:v];
    }
    return _subviews;
}

- (UILabel *)titleLabel {
    
    UILabel *targetLbl = nil;
    
    UIView *subView1 = self.view.subviews[0];
    
    UIView *subView2 = subView1.subviews[0];
    
    UIView *subView3 = subView2.subviews[0];
    
    UIView *subView4 = subView3.subviews[0];
    
    UIView *subView5 = subView4.subviews[0];
    
    for (UIView *view in subView5.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            targetLbl = (UILabel *)view;
            return targetLbl;
        }
    }
    return targetLbl;
}

- (UILabel *)messageLabel {
    
    UILabel *targetLbl = nil;
    NSInteger count = 0;
    
    UIView *subView1 = self.view.subviews[0];
    
    UIView *subView2 = subView1.subviews[0];
    
    UIView *subView3 = subView2.subviews[0];
    
    UIView *subView4 = subView3.subviews[0];
    
    UIView *subView5 = subView4.subviews[0];
    
    for (UIView *view in subView5.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (count != 1) {
                count ++;
            }
            else {
                targetLbl = (UILabel *)view;
            }
        }
    }
    return targetLbl;
}
@end
