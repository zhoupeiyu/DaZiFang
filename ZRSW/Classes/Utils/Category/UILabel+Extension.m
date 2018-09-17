//
//  UILabel+Extension.m
//  LXMath
//
//  Created by 周培玉 on 2018/1/17.
//  Copyright © 2018年 LXM. All rights reserved.
//

#import "UILabel+Extension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Extension)

- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}
/** 显示当前文字需要几行 @param width 给定一个宽度 @return 返回行数 */
- (NSInteger)needLinesWithWidth:(CGFloat)width{
    //创建一个labe
    UILabel * label = [[UILabel alloc]init];
    //font和当前label保持一致
    label.font = self.font;
    NSString * text = self.text;
    NSInteger sum = 0;
    //总行数受换行符影响,所以这里计算总行数,需要用换行符分隔这段文字,然后计算每段文字的行数,相加即是总行数。
    NSArray * splitText = [text componentsSeparatedByString:@"/n"];
    for (NSString * sText in splitText) {
        label.text = sText;
        //获取这段文字一行需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        //size.width/所需要的width 向上取整就是这段文字占的行数
        NSInteger lines = ceilf(textSize.width/width);
        //当是0的时候,说明这是换行,需要按一行算。
        lines = lines == 0?1:lines;
        sum += lines;
        
    }
    return sum;
}
@end
