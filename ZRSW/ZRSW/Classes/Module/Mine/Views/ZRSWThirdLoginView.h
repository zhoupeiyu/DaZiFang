//
//  ZRSWThirdLoginView.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ThirdLoginTypeWeChat,
    ThirdLoginTypeQQ,
    ThirdLoginTypeSina,
} ThirdLoginType;

@protocol ZRSWThirdLoginViewDelegate <NSObject>

- (void)loginSuccessWithType:(ThirdLoginType)loginType userInfoResponse:(UMSocialUserInfoResponse *)response;

- (void)loginFailedWithType:(ThirdLoginType)loginType error:(NSError *)error;


@end
@interface ZRSWThirdLoginView : UIView

@property (nonatomic, weak) id <ZRSWThirdLoginViewDelegate> delegate;

- (void)updateAvailable;

+ (CGFloat)thirdLoginViewHeight;

@end
