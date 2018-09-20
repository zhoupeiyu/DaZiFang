//
//  ZRSWActionSheetView.h
//  ZRSW
//
//  Created by King on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSWActionSheetButton.h"
@protocol PlatformButtonClickDelegate <NSObject>
- (void) customActionSheetButtonClick:(ZRSWActionSheetButton *)btn;
@end


@interface ZRSWActionSheetView : UIView
-(instancetype)initAtionSheetView;
@property (nonatomic, weak) id<PlatformButtonClickDelegate> delegate;

@end
