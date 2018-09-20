//
//  ZRSWIPCardView.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IPCardViewTypePerson, // 个人认证
    IPCardViewTypeCompany // 企业认证
    
} IPCardViewType;

@interface ZRSWIPCardView : UIView

+ (ZRSWIPCardView *)getIPCardViewWithType:(IPCardViewType)type title:(NSString *)title fristViewContent:(NSString *)fristContent secondContent:(NSString *)secondContent isNeedBottomLine:(BOOL)isNeedBottomLine presentVC:(BaseViewController *)presentVC;

+ (CGFloat)viewHeight:(IPCardViewType)type;

- (NSMutableArray *)getSelectedImages;

@end
