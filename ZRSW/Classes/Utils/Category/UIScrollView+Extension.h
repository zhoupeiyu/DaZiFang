//
//  UIScrollView+Extension.h
//  LXMath
//
//  Created by 周培玉 on 2018/1/17.
//  Copyright © 2018年 LXM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)
- (void)scrollToTop;


- (void)scrollToBottom;


- (void)scrollToLeft;


- (void)scrollToRight;


- (void)scrollToTopAnimated:(BOOL)animated;


- (void)scrollToBottomAnimated:(BOOL)animated;


- (void)scrollToLeftAnimated:(BOOL)animated;


- (void)scrollToRightAnimated:(BOOL)animated;

@end
