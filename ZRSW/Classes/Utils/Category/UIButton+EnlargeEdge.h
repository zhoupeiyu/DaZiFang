//
//  UIButton+EnlargeEdge.h
//  LXVolunteer
//
//  Created by IsLand on 16/6/3.
//  Copyright © 2016年 lexue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end