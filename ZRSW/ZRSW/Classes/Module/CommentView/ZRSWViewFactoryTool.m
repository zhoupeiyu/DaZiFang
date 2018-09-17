//
//  ZRSWViewFactoryTool.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWViewFactoryTool.h"

@implementation ZRSWViewFactoryTool

+ (UIButton *)getBlueBtn:(NSString *)title target:(id)target action:(SEL)action {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0x4771F2]] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:YES];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;

}
@end
