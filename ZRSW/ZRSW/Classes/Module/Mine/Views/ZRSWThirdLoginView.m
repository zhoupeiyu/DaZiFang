//
//  ZRSWThirdLoginView.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWThirdLoginView.h"

@interface ZRSWThirdLoginView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *bottomSeparator;

@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UIButton *wechatBtn;
@property (nonatomic, strong) UIButton *wbBtn;

@property (nonatomic, strong) NSMutableArray *btnArray;

@end
@implementation ZRSWThirdLoginView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)customInit {
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    
    // QQ Button
    self.wbBtn = [self buttonWithImage:@"share_blog" title:@"微博" selector:@selector(WeiboLoginAction)];
    [self addSubview:self.wbBtn];
    
    self.wechatBtn = [self buttonWithImage:@"sign_other_wechat" title:@"微信" selector:@selector(WeChatLoginActionid)];
    [self addSubview:self.wechatBtn];
    
    self.qqBtn = [self buttonWithImage:@"share_qq" title:@"QQ" selector:@selector(QQLoginAction)];
    [self addSubview:self.qqBtn];
    
    [self refreshButtons];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtons) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)refreshButtons {
    self.btnArray = [NSMutableArray array];
    
    //    if (![[WeiboLoginHandler sharedInstance] shareAvailable]) {
    //        self.wbBtn.hidden = YES;
    //    }
    //    else {
    [self.btnArray addObject:self.wbBtn];
    //    }
    
//    if (![[WeChatHandler sharedInstance] shareAvailable]) {
//        self.wechatBtn.hidden = YES;
//    }
//    else {
        [self.btnArray addObject:self.wechatBtn];
//    }
    
//    if (![[QQLoginHandler sharedInstance] shareAvailable]) {
//        self.qqBtn.hidden = YES;
//    }
//    else {
        [self.btnArray addObject:self.qqBtn];
//    }
    

    
    self.bottomSeparator.hidden = (self.btnArray.count == 0);
    
    [self setNeedsLayout];
}

- (UIButton *)buttonWithImage:(NSString *)imageName title:(NSString *)tilte selector:(SEL)selector {
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [ZRSWThirdLoginView thirdLoginViewHeight];
    CGFloat height = [ZRSWThirdLoginView thirdLoginViewHeight];
    CGFloat top = 0;
    
    if (self.btnArray.count == 0) {
        return;
    }
    
    CGFloat margin = (self.width - width * self.btnArray.count) / (self.btnArray.count + 1);
    CGFloat offset = margin;
    for (UIButton *btn in self.btnArray) {
        btn.frame = CGRectMake(offset, top, width, height);
        offset += margin + width;
    }
}

+ (CGFloat)thirdLoginViewHeight {
    return 50;
}
#pragma mark - Actions
- (void)QQLoginAction {
   
}

- (void)WeiboLoginAction {
    
}

- (void)WeChatLoginActionid {
   
}

- (void)informDelegateFailed {
   
}

- (void)updateAvailable {
    self.qqBtn.hidden = NO;
    
    self.wbBtn.hidden = NO;
    
    self.wechatBtn.hidden = NO;
    
    [self setNeedsLayout];
}

@end
