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
    return [self viewArray:self.view][0];
}

- (UILabel *)messageLabel {
    return [self viewArray:self.view][1];
}
@end
