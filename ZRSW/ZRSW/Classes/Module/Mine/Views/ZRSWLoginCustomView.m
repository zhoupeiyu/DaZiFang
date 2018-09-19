//
//  ZRSWLoginCustomView.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/17.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWLoginCustomView.h"

@interface ZRSWLoginCustomView ()<UITextFieldDelegate>

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
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(18);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(KSeparatorLineHeight);
    }];
    [self.countDownButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.lineView.mas_top).mas_offset(-7);
        make.right.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(105, 30));
    }];
    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLbl.mas_left);
        make.centerY.mas_equalTo(self.countDownButton.mas_centerY);
        if (self.isNeedCountDownButton) {
            make.right.mas_equalTo(self.countDownButton.mas_left).offset(-5);
        }
        else {
            make.right.mas_equalTo(-30);
        }
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:customView:)]) {
        BOOL isInput = [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string customView:self];
        return isInput;
    }
    return YES;
}
#pragma mark - Event

- (NSString *)getInputViewText {
    return self.inputTextField.text;
}
+ (UIColor *)placeHoledColor {
    return [UIColor colorFromRGB:0x474455];
}
+ (UIFont *)placeHoledNormalFont {
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)placeHoledSmallFont {
    return [UIFont systemFontOfSize:13];
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
- (void)countDownButtonAction:(UIButton *)button {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(countDownButtonAction:)]) {
        [self.delegate countDownButtonAction:button];
    }
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
        _inputTextField.font = [ZRSWLoginCustomView placeHoledNormalFont];
        _inputTextField.textColor = [ZRSWLoginCustomView placeHoledColor];
        _inputTextField.clearsOnBeginEditing = YES;
        _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.delegate = self;
    }
    return _inputTextField;
}
- (JKCountDownButton *)countDownButton {
    if (!_countDownButton) {
        _countDownButton = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        [_countDownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_countDownButton setTitleColor:[UIColor colorFromRGB:0x474455] forState:UIControlStateNormal];
        [_countDownButton setTitleColor:[UIColor colorFromRGB:0x474455] forState:UIControlStateHighlighted];
        [_countDownButton setBackgroundImage:[UIImage imageNamed:@"verification_code_button"] forState:UIControlStateNormal];
        [_countDownButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromRGB:0xeeeeee]] forState:UIControlStateHighlighted];
        _countDownButton.masksToBounds = YES;
        _countDownButton.layer.cornerRadius = 15;
        _countDownButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        [_countDownButton addTarget:self action:@selector(countDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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

@interface ZRSWUserAgreementView ()

@property (nonatomic, strong) NSMutableAttributedString *title;
@property (nonatomic, strong) NSString *htmlName;

@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIButton *agreeBtn;

@end
@implementation ZRSWUserAgreementView

+ (instancetype)getUserAgreeViewWithTitle:(NSMutableAttributedString *)title agreeHtmlName:(NSString *)htmlName {
    ZRSWUserAgreementView *agreeView = [[ZRSWUserAgreementView alloc] init];
    agreeView.title = title;
    agreeView.htmlName = htmlName;
    return agreeView;
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

+ (UIImage *)checkNormalImage {
    return [UIImage imageNamed:@"register_unchecked"];
}
+ (UIImage *)checkSelectImage {
    return [UIImage imageNamed:@"register_select"];
}
- (void)setupConfig {
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setupUI{
    [self addSubview:self.checkBtn];
    [self addSubview:self.agreeBtn];
    [self setuplayOut];
}
- (void)setuplayOut {
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(25);
        make.size.mas_equalTo(CGSizeMake([ZRSWUserAgreementView checkNormalImage].size.width + 10, [ZRSWUserAgreementView checkNormalImage].size.width + 10));
    }];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBtn.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}
+ (CGFloat)viewHeight {
    return 30 + [self checkNormalImage].size.height;
}
- (BOOL)checkBtnSelected {
    return self.checkBtn.selected;
}

- (void)setTitle:(NSMutableAttributedString *)title {
    _title = title;
    [self.agreeBtn setAttributedTitle:title forState:UIControlStateNormal];
    [self.agreeBtn setAttributedTitle:title forState:UIControlStateHighlighted];
}
#pragma mark - action

- (void)checkBtnAction:(UIButton *)checkBtn {
    checkBtn.selected = !checkBtn.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAgreementViewChecked:)]) {
        [self.delegate userAgreementViewChecked:checkBtn.selected];
    }
}
- (void)agreeBtnAction {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LoginAgreement" ofType:@"html"];
    NSURL *rurl = [NSURL URLWithString:path];
    
}
#pragma mark - lazy

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[ZRSWUserAgreementView checkNormalImage] forState:UIControlStateNormal];
        [_checkBtn setImage:[ZRSWUserAgreementView checkSelectImage] forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}
- (UIButton *)agreeBtn {
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_agreeBtn addTarget:self action:@selector(agreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}
@end
