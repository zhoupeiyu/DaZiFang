//
//  LXRefreshDIYHeader.m
//  LXCoffee
//
//  Created by HU on 15/8/21.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "LXRefreshDIYHeader.h"
#import "MMMaterialDesignSpinner.h"
@interface LXRefreshDIYHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic)MMMaterialDesignSpinner *spinnerView;
@end
@implementation LXRefreshDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 70.f;
//    self.backgroundColor = [UIColor colorFromHexRGB:@"f4f4f4"];
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorFromHexRGB:@"999999"];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    MMMaterialDesignSpinner *spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
    self.spinnerView = spinnerView;
    self.spinnerView.transform = CGAffineTransformMakeRotation(220 *M_PI / 180.0);
    self.spinnerView.bounds = CGRectMake(0, 0, 25, 25);
    self.spinnerView.tintColor = [UIColor colorFromHexRGB:@"c0c0c0"];
    self.spinnerView.lineWidth=2;
    self.spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.spinnerView];
    
    _strStateIdle = @"下拉刷新";
    _strStatePulling = @"即将刷新";
    _strStateRefresh = @"加载数据中";
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = CGRectMake(0, 25.f, CGRectGetWidth(self.bounds), 25);
    
    self.spinnerView.center = CGPointMake(self.mj_w * 0.5, - self.spinnerView.mj_h + 50);
    
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.spinnerView stopAnimating];
            self.label.text = _strStateIdle;
            break;
        case MJRefreshStatePulling:
            [self.spinnerView startAnimating];
            self.label.text = _strStatePulling;
            break;
        case MJRefreshStateRefreshing:
            [self.spinnerView startAnimating];
            self.label.text = _strStateRefresh;
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
}

@end
