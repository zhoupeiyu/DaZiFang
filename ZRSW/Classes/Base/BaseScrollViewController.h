//
//  BaseScrollViewController.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseScrollViewController : BaseViewController<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)addTapGesture;

- (void)removeTapGesture;

@end
