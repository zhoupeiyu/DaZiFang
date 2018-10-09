//
//  PickerView.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/14.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerView;

@protocol PickerViewDelegate <NSObject>

@optional

- (void)pickerView:(PickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

- (void)pickerViewDidCanceled:(PickerView *)pickerView;

@end


@interface PickerView : UIView

@property (nonatomic, weak) id<PickerViewDelegate> delegate;
@property (nonatomic, assign) CGFloat pickerHeight; // the height of picker view
@property (nonatomic, assign) NSInteger preselectedIndex;
@property (nonatomic, assign) NSInteger preselectedIndexForSecond;
@property (nonatomic, strong) NSString *title;

- (instancetype)initWithData:(NSArray *)data;
- (instancetype)initWithArray:(NSArray *)firstArray andDictionary:(NSDictionary *)dict;

@end
