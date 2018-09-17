//
//  UIFont+Utility.m
//  LXVolunteer
//
//  Created by 李涛 on 15/5/20.
//  Copyright (c) 2015年 lexue. All rights reserved.
//

#import "UIFont+Utility.h"

@implementation UIFont (Utility)


+ (UIFont *)kFont13{
    return [UIFont systemFontOfSize:13];
}

+ (UIFont *)kFont14{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)kFont15{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)kFont16{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)smallFont{
    return [UIFont systemFontOfSize:11];
}

+ (UIFont *)bigFont{
    return [UIFont systemFontOfSize:17];
}

+ (UIFont *)cellFont{
	return [UIFont systemFontOfSize:13];
}
@end
