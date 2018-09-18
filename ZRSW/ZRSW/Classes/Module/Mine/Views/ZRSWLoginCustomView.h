//
//  ZRSWLoginCustomView.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRSWLoginCustomView : UIView

+ (instancetype)getLoginInputViewWithTitle:(NSString *)title placeHoled:(NSAttributedString *)placeHoled keyboardType:(UIKeyboardType)keyboardType isNeedCountDownButton:(BOOL)isNeedCountDownButton isNeedBottomLine:(BOOL)isNeedBottomLine;

+ (CGFloat)loginInputViewHeight;


- (NSString *)getInputViewText;

+ (UIColor *)placeHoledColor;

+ (UIFont *)placeHoledNormalFont;

+ (UIFont *)placeHoledSmallFont;
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;

@end

@interface ZRSWUserAgreementView : UIView

+ (instancetype)getUserAgreeViewWithTitle:(NSMutableAttributedString *)title agreeHtmlName:(NSString *)htmlName;

+ (CGFloat)viewHeight;
- (BOOL)checkBtnSelected;

@end
