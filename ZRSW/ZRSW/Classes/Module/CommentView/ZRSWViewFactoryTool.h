//
//  ZRSWViewFactoryTool.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZRSWViewFactoryTool : NSObject


/**
 生成蓝色背景图按钮

 @param title 标题
 @param target target
 @param action action
 @return 按钮
 */
+ (UIButton *)getBlueBtn:(NSString *)title target:(id)target action:(SEL)action;

@end
