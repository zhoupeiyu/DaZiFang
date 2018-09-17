//
//  ZRSWLoginCustomView.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoginCustomView.h"

@interface ZRSWLoginCustomView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *placeHoled;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isNeedCountDownButton;
@property (nonatomic, assign) BOOL isNeedBottomLine;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) JKCountDownButton *countDownButton;

@end
@implementation ZRSWLoginCustomView

+ (instancetype)getLoginInputViewWithTitle:(NSString *)title placeHoled:(NSAttributedString *)placeHoled keyboardType:(UIKeyboardType)keyboardType isNeedCountDownButton:(BOOL)isNeedCountDownButton isNeedBottomLine:(BOOL)isNeedBottomLine{
    ZRSWLoginCustomView *view = [[ZRSWLoginCustomView alloc] init];
    view.title = title;
    view.placeHoled = placeHoled;
    view.keyboardType = keyboardType;
    view.isNeedCountDownButton = isNeedCountDownButton;
    view.isNeedBottomLine = isNeedBottomLine;
    return view;
}
+ (CGFloat)loginInputViewHeight {
    return 80;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI {
    [self addSubview:self.titleLbl];
    [self addSubview:self.inputTextField];
    [self addSubview:self.lineView];
    [self addSubview:self.countDownButton];
    [self setupLayOut];
}

- (void)setupLayOut {
    [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(18);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
    [self.countDownButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_top).mas_offset(-7);
        make.right.mas_equalTo(-15);
    }];
    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLbl.mas_left);
        make.centerY.mas_equalTo(self.countDownButton.mas_centerY);
        if (self.isNeedCountDownButton) {
            make.right.mas_equalTo(self.countDownButton.mas_left).offset(-5);
        }
        else {
            make.right.mas_equalTo(-15);
        }
    }];
}
#pragma mark - Event

- (NSString *)getInputViewText {
    return self.inputTextField.text;
}
+ (UIColor *)placeHoledColor {
    return [UIColor colorFromRGB:0x1D1D26];
}
///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler {
    [self.countDownButton countDownButtonHandler:touchedCountDownButtonHandler];
}
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging {
    [self.countDownButton countDownChanging:countDownChanging];
}
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished {
    [self.countDownButton countDownFinished:countDownFinished];
}
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second {
    [self.countDownButton startCountDownWithSecond:second];
}
///停止倒计时
- (void)stopCountDown {
    [self.countDownButton stopCountDown];
}

- (void)setPlaceHoled:(NSAttributedString *)placeHoled {
    _placeHoled = placeHoled;
    self.inputTextField.attributedPlaceholder = placeHoled;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.inputTextField.keyboardType = keyboardType;
    
}

- (void)setIsNeedCountDownButton:(BOOL)isNeedCountDownButton {
    _isNeedCountDownButton = isNeedCountDownButton;
    self.countDownButton.hidden = !isNeedCountDownButton;
}

- (void)setIsNeedBottomLine:(BOOL)isNeedBottomLine {
    _isNeedBottomLine = isNeedBottomLine;
    self.lineView.hidden = !isNeedBottomLine;
}
#pragma mark - lazy

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor colorFromRGB:0x999999];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    }
    return _titleLbl;
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textAlignment = NSTextAlignmentLeft;
        _inputTextField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];
        _inputTextField.textColor = [ZRSWLoginCustomView placeHoledColor];
        _inputTextField.clearsOnBeginEditing = YES;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _inputTextField;
}
- (JKCountDownButton *)countDownButton {
    if (!_countDownButton) {
        _countDownButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownButton setTitleColor:[UIColor colorFromRGB:0x1D1D26] forState:UIControlStateNormal];
        [_countDownButton setTitleColor:[UIColor colorFromRGB:0x1D1D26] forState:UIControlStateHighlighted];
        [_countDownButton setBackgroundImage:[UIImage imageNamed:@"verification_code_button"] forState:UIControlStateNormal];
        [_countDownButton setBackgroundImage:[UIImage imageNamed:@"verification_code_button"] forState:UIControlStateNormal];
        [_countDownButton setBackgroundImage:[UIImage imageNamed:@"verification_code_button"] forState:UIControlStateNormal];
        _countDownButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
    }
    return _countDownButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorFromRGB:0xEDEDED];
    }
    return _lineView;
}
@end
