//
//  BaseScrollViewController.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseScrollViewController.h"

@interface BaseScrollViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
}

#pragma mark - lazy

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [BaseTheme baseViewColor];
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    }
    return _tapGesture;
}
- (void)addTapGesture {
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)removeTapGesture {
    [self.view removeGestureRecognizer:self.tapGesture];
}
- (void)tapAction {
    [self.view endEditing:YES];
}
@end
