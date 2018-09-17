//
//  UIAlertController+Extension.h
//  LXMath
//
//  Created by 周培玉 on 2018/4/23.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)
/**
 alertController title
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/**
 alertController message
 */
@property (nonatomic, strong, readonly) UILabel *messageLabel;

@end
