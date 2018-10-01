//
//  ZRSWLinePrejudicationCells.h
//  ZRSW
//
//  Created by 周培玉 on 2018/10/1.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 用户信息

@class LinePrejudicationUserInfoInputItem;

@protocol LinePrejudicationInputItemDelegate <NSObject>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(LinePrejudicationUserInfoInputItem *)customView;

- (void)textFieldTextDidChange:(UITextField *)textField customView:(LinePrejudicationUserInfoInputItem *)customView;

@end

@protocol LinePrejudicationCheckItemDelegate <NSObject>

- (void)checkViewSelectedNum:(UseInfoSex)sex;

@end

@interface LinePrejudicationUserInfoCheckItem : UIView

@property (nonatomic, weak) id <LinePrejudicationCheckItemDelegate>delegate;
- (void)setTitle:(NSString *)title;
- (void)setDefaultSex:(UseInfoSex)sex;
- (void)setBottomLineHidden:(BOOL)bottomLineHidden;

@end
@interface LinePrejudicationUserInfoInputItem : UIView

@property (nonatomic, weak) id <LinePrejudicationInputItemDelegate> delegate;

- (void)setTitle:(NSString *)title;
- (void)setPlaceHolder:(NSString *)placeHolder;
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
- (void)setBottomLineHidden:(BOOL)bottomLineHidden;


@end
@interface LinePrejudicationUserInfoCell : UITableViewCell

+ (LinePrejudicationUserInfoCell *)getCellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeight;

- (NSString *)loanPersonName;
- (NSString *)loanPersonSex;
- (NSString *)loanPersonAdd;
- (NSString *)loanPersonPhone;
- (NSString *)loanPersonMoney;

@end

#pragma mark - 备注

@interface LinePrejudicationRemarksCell : UITableViewCell

+ (LinePrejudicationRemarksCell *)getCellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

- (NSString *)remarkText;


@end
