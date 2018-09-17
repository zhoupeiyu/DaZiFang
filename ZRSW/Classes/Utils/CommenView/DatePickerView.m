//
//  DatePickerView.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/14.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "DatePickerView.h"

#define kDatePickerViewButtonBarHeight 44.f
#define kDatePickerViewButtonWidth 40.f
#define kDatePickerViewButtonHeight 30.f
#define kDatePickerViewButtonHMargin 10.f
#define kDatePickerViewButtonVMargin 5.f

@interface DatePickerView ()

@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIImageView *buttonBarView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation DatePickerView

- (void)dealloc
{
    [self removeGestureRecognizer:self.tapGesture];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (_pickerView) {
        return;
    }
    _pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, 215.f)];
    _pickerView.datePickerMode = UIDatePickerModeDate;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    _maskView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.4;
    [self addSubview:_maskView];
    
    _buttonBarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _buttonBarView.alpha = 1.f;
    _buttonBarView.backgroundColor = [UIColor getBackgroundColor];
    [self addSubview:_buttonBarView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor getFontBlueColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor getFontBlueColor] forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmBtn];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:_tapGesture];
}

- (void)setPickerMode:(UIDatePickerMode)pickerMode {
    _pickerMode = pickerMode;
    self.pickerView.datePickerMode = pickerMode;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickerHeight = 215.f;
    self.maskView.frame = CGRectMake(0.f, 0.f, self.width, self.height - self.pickerHeight - kDatePickerViewButtonBarHeight);
    
    self.pickerView.frame = CGRectMake(0.f, self.height - self.pickerHeight, self.width, self.pickerHeight);
    
    self.buttonBarView.frame = CGRectMake(0.f, self.pickerView.top - kDatePickerViewButtonBarHeight, self.width, kDatePickerViewButtonBarHeight);
    self.cancelBtn.frame = CGRectMake(kDatePickerViewButtonHMargin, self.buttonBarView.top + kDatePickerViewButtonVMargin, kDatePickerViewButtonWidth, kDatePickerViewButtonHeight);
    self.confirmBtn.frame = CGRectMake(self.width - kDatePickerViewButtonHMargin - kDatePickerViewButtonWidth,
                                       self.buttonBarView.top + kDatePickerViewButtonVMargin, kDatePickerViewButtonWidth, kDatePickerViewButtonHeight);
}

- (void)confirmAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelect:)]) {
        NSDate *date = self.pickerView.date;
        [self.delegate datePickerView:self didSelect:date];
    }
    [self removeFromSuperview];
}

- (void)cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerViewDidCanceled:)]) {
        [self.delegate datePickerViewDidCanceled:self];
    }
    [self removeFromSuperview];
}

- (void)setSelectedDate:(NSDate *)date {
    self.pickerView.date = date;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.pickerView.maximumDate = maximumDate;
}
- (void)tapAction {
    [self cancelAction];
}

@end
