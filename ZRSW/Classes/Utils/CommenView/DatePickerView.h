//
//  DatePickerView.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/14.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerView;

@protocol DatePickerViewDelegate <NSObject>

@optional

- (void)datePickerView:(DatePickerView *)pickerView didSelect:(NSDate *)date;

- (void)datePickerViewDidCanceled:(DatePickerView *)pickerView;

@end

@interface DatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;
@property (nonatomic, assign) CGFloat pickerHeight; // the height of picker view

@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, assign) UIDatePickerMode pickerMode;

- (void)setSelectedDate:(NSDate *)date;

@end
