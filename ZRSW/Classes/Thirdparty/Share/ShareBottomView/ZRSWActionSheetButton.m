//
//  ZRSWActionSheetButton.m
//  ZRSW
//
//  Created by King on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWActionSheetButton.h"

#define kTitlePrecent 0.4
#define kImageViewWH 64  //55

@implementation ZRSWActionSheetButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor colorFromRGB:0x474455] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark 调整文字的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * kTitlePrecent;
    CGFloat titleX = 2;
    CGFloat titleY = self.frame.size.height * (1 - kTitlePrecent) + 7;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

#pragma mark 调整图片的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = kImageViewWH;
    CGFloat imageH = kImageViewWH;
    CGFloat imageX = (self.frame.size.width - kImageViewWH) * 0.5;
    CGFloat imageY = 2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
