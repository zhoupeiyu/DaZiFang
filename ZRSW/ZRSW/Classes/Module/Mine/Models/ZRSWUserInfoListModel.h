//
//  ZRSWUserInfoListModel.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/28.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UserInfoCellTypeHeader,
    UserInfoCellTypeInfo,
    UserInfoCellTypeInput
} UserInfoCellType;

NS_ASSUME_NONNULL_BEGIN

@class ZRSWUserInfoCell;

@protocol UserInfoCellDelegate <NSObject>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWUserInfoCell *)cell;

- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWUserInfoCell *)cell;

@end

@interface ZRSWUserInfoListModel : NSObject

@property (nonatomic, assign) BOOL bottomLineHidden;
@property (nonatomic, assign) UserInfoCellType cellType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desTitle;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) NSInteger cellHeight;
@property (nonatomic, weak) id <UserInfoCellDelegate> deleget;
@property (nonatomic, strong) NSString *placeHoled;
@property (nonatomic, assign) NSInteger textFieldTag;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSString *headerImageUrl;
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END
