//
//  ZRSWAchieveFilterView.h
//  ZRSW
//
//  Created by King on 2018/9/30.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRSWAchieveFilterView : UIButton
- (instancetype)initWithCustomView:(UIView *)customView;
- (void)showWithView:(UIView *)targetView;
- (void)hide;
@end
