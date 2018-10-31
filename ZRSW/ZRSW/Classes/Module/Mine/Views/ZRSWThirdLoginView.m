//
//  ZRSWThirdLoginView.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWThirdLoginView.h"
#import "ZRSWShareManager.h"
#import <UMSocialSinaHandler.h>
#import <WXApi.h>

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
    
        if (![ZRSWShareManager isImstallWeiBo]) {
            self.wbBtn.hidden = YES;
        }
        else {
            [self.btnArray addObject:self.wbBtn];
        }
    
    if (![ZRSWShareManager isInstallWeChat]) {
        self.wechatBtn.hidden = YES;
    }
    else {
        [self.btnArray addObject:self.wechatBtn];
    }
    
    if (![ZRSWShareManager isInstallQQ]) {
        self.qqBtn.hidden = YES;
    }
    else {
        [self.btnArray addObject:self.qqBtn];
    }
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

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithType:error:)]) {
                [self.delegate loginFailedWithType:ThirdLoginTypeQQ error:error];
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithType:userInfoResponse:)]) {
                [self.delegate loginSuccessWithType:ThirdLoginTypeQQ userInfoResponse:resp];
            }
            LLog(@"------------------------------------------------\n");
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ unionid: %@", resp.unionId);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            LLog(@"------------------------------------------------\n");
        }
    }];
}

- (void)WeiboLoginAction {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithType:error:)]) {
                [self.delegate loginFailedWithType:ThirdLoginTypeSina error:error];
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithType:userInfoResponse:)]) {
                [self.delegate loginSuccessWithType:ThirdLoginTypeSina userInfoResponse:resp];
            }
            LLog(@"------------------------------------------------\n");
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            LLog(@"------------------------------------------------\n");
        }
    }];
}

- (void)WeChatLoginActionid {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            LLog(@"%@",error);
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailedWithType:error:)]) {
                [self.delegate loginFailedWithType:ThirdLoginTypeWeChat error:error];
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessWithType:userInfoResponse:)]) {
                [self.delegate loginSuccessWithType:ThirdLoginTypeWeChat userInfoResponse:resp];
            }
            LLog(@"------------------------------------------------\n");
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            LLog(@"------------------------------------------------\n");
        }
    }];
}


- (void)updateAvailable {
    self.qqBtn.hidden = ![ZRSWShareManager isInstallQQ];
    
    self.wbBtn.hidden = ![ZRSWShareManager isImstallWeiBo];
    
    self.wechatBtn.hidden = ![ZRSWShareManager isInstallWeChat];
    
    [self setNeedsLayout];
}
-(void)onResp:(BaseResp*)resp {
    
}
@end
