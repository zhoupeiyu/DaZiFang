//
//  NSString+Extension.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)lf_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)getSizeWithFont:(UIFont *)font;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndLineHeight:(CGFloat)lineHeight;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size AndParagraphStyle:(NSParagraphStyle *)paragraphStyle;

+ (NSString *)positiveFormat:(NSString *)text;

-(NSString *)getZZwithString:(NSString *)string;


@end
