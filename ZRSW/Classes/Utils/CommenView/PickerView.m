//
//  PickerView.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/14.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "PickerView.h"

#define kPickerViewButtonBarHeight 44.f
#define kPickerViewButtonWidth 40.f
#define kPickerViewButtonHeight 30.f
#define kPickerViewButtonHMargin 10.f
#define kPickerViewButtonVMargin 5.f

@interface PickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *dataDictKeys;

@property (nonatomic, assign) NSInteger currentComponent;
@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIImageView *buttonBarView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UILabel *titleLbl;
@end
@implementation PickerView

- (void)dealloc {
    [self removeGestureRecognizer:self.tapGesture];
}

- (instancetype)initWithData:(NSArray *)data {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataList = data;
        [self initViews];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)firstArray andDictionary:(NSDictionary *)dict {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataDictKeys = firstArray;
        _dataDict = dict;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (_pickerView) {
        return;
    }
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    
    _maskView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.4;
    [self addSubview:_maskView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:_tapGesture];
    
    // button bar with 2 buttons
    _buttonBarView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _buttonBarView.alpha = 1.f;
    _buttonBarView.backgroundColor = [UIColor getBackgroundColor];
    [self addSubview:_buttonBarView];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.textColor = [UIColor blackColor];
    _titleLbl.font = [UIFont boldSystemFontOfSize:18];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.text = @"我是标题";
    [self addSubview:_titleLbl];
    
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
    
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.pickerHeight = 255.f;
    self.maskView.frame = CGRectMake(0.f, 0.f, self.width, self.height - self.pickerHeight - kPickerViewButtonBarHeight);
    
    self.pickerView.frame = CGRectMake(0.f, self.height - self.pickerHeight - kiphonexBottom, self.width, self.pickerHeight);
    [self.pickerView setNeedsLayout];
    
    self.buttonBarView.frame = CGRectMake(0.f, self.pickerView.top - kPickerViewButtonBarHeight, self.width, kPickerViewButtonBarHeight);
    self.cancelBtn.frame = CGRectMake(kPickerViewButtonHMargin, self.buttonBarView.top, kPickerViewButtonWidth, self.buttonBarView.height);
    self.confirmBtn.frame = CGRectMake(self.width - kPickerViewButtonHMargin - kPickerViewButtonWidth,
                                       self.buttonBarView.top, kPickerViewButtonWidth, self.buttonBarView.height);
    [self.titleLbl sizeToFit];
    self.titleLbl.top = self.buttonBarView.top;
    self.titleLbl.height = self.buttonBarView.height;
    self.titleLbl.centerX = self.buttonBarView.centerX;
}

- (void)confirmAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.delegate pickerView:self didSelectRow:self.currentRow inComponent:self.currentComponent];
    }
    [self removeFromSuperview];
}

- (void)cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewDidCanceled:)]) {
        [self.delegate pickerViewDidCanceled:self];
    }
    [self removeFromSuperview];
}

- (void)setPreselectedIndex:(NSInteger)preselectedIndex {
    _preselectedIndex = preselectedIndex;
    self.currentRow = preselectedIndex;
    [self.pickerView selectRow:preselectedIndex inComponent:0 animated:NO];
}

- (void)setPreselectedIndexForSecond:(NSInteger)preselectedIndex {
    _preselectedIndexForSecond = preselectedIndex;
    self.currentComponent = preselectedIndex;
    [self.pickerView selectRow:preselectedIndex inComponent:1 animated:NO];
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataDict) {
        return 2;
    }
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.dataDict) {
        if (0 == component) {
            return 100.f;
        }
        return 180.f;
    }
    return 180.f;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataDict) {
        if (0 == component) {
            return self.dataDictKeys.count;
        }
        NSString *key = self.dataDictKeys[self.currentComponent];
        return [self.dataDict[key] count];
    }
    return self.dataList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    for (UIView *subView in pickerView.subviews) {
        if (subView.frame.size.height <= 1) {//获取分割线view
            subView.hidden = NO;
            subView.frame = CGRectMake(0, subView.frame.origin.y, subView.frame.size.width, 1);
            subView.backgroundColor = [UIColor colorFromRGB:0xEDEDED];//设置分割线颜色
        }
    }
    if (self.dataDict) {
        if (0 == component) {
            return self.dataDictKeys[row];
        }
        NSString *key = self.dataDictKeys[self.currentComponent];
        NSArray *array = self.dataDict[key];
        return array[row];
    }
    return self.dataList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.dataDict) {
        if (0 == component) {
            NSInteger oldComponent = self.currentComponent;
            self.currentComponent = row;
            if (self.dataDict) {
                if (row != oldComponent) {
                    [self.pickerView selectRow:0 inComponent:1 animated:YES];
                    [self.pickerView reloadComponent:1];
                }
            }
        }
        else {
            self.currentRow = row;
        }
        return;
    }
    self.currentRow = row;
}

- (void)tapAction {
    [self cancelAction];
}

@end
