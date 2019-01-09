//
//  ZRSWHomeNewsHeaderView.h
//  ZRSW
//
//  Created by King on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZRSWHomeNewsHeaderViewDelegate <NSObject>
- (void)getMoreClick:(NSInteger)type title:(NSString *)title;
@end
@interface ZRSWHomeNewsHeaderView : UIView
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *arrowButton;
- (void)setTitle:(NSString *)title;
@property (nonatomic,weak) id<ZRSWHomeNewsHeaderViewDelegate>delegate;

- (void)showLineView;

@end
