//
//  ZRSWAchieveFilterView.m
//  ZRSW
//
//  Created by King on 2018/9/30.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWAchieveFilterView.h"

@interface ZRSWAchieveFilterView ()
@property (nonatomic, weak) UIImageView *bgView;
@end

@implementation ZRSWAchieveFilterView

- (instancetype)initWithCustomView:(UIView *)customView
{
    if (self = [super init]) {
        self.size = [UIScreen mainScreen].bounds.size;
        [self addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [UIColor clearColor];

        //初始化小灰框
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"popover_background"];
        //设置可以接收用户的点击事件
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        imageView.size = CGSizeMake(customView.width + 10, customView.height + 20);
        customView.x = 5;
        customView.y = 12;
        [imageView addSubview:customView];
        [self addSubview:imageView];
        self.bgView = imageView;
    }
    return self;
}
- (void)showWithView:(UIView *)targetView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //把button的坐标转换到屏幕坐标
    //    __ convertRect:__ toView:__
    CGRect rect = [targetView convertRect:targetView.bounds toView:window];
    self.bgView.centerX = CGRectGetMidX(rect);
    self.bgView.y = CGRectGetMaxY(rect);
    [window addSubview:self];
}

- (void)hide{
    [self hide:nil];
}

- (void)hide:(UIButton *)btn{
    [self removeFromSuperview];
}

@end
