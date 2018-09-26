//
//  ZRSWLoansTopCell.h
//  ZRSW
//
//  Created by 周培玉 on 2018/9/21.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRSWOrderModel.h"

@interface LoansCellStates : NSObject

+ (UIColor *)getBlackColor;
+ (UIColor *)getStartRedColor;
+ (UIColor *)getContentColor;
+ (UIFont *)getTitleFont;
+ (UIFont *)getContentFont;

@end
@interface ZRSWLoansTopCell : UITableViewCell

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, assign) BOOL isNeedLine;

+ (ZRSWLoansTopCell *)getCellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeigh;


@end

@interface ZRSWLoansFlow : UITableViewCell
+ (ZRSWLoansFlow *)getCellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeigh;

@end

@interface ZRSWLoansProductAttributeCell : UITableViewCell
+ (ZRSWLoansProductAttributeCell *)getCellWithTableView:(UITableView *)tableView;
+ (CGFloat)cellHeigh;
@property (nonatomic, strong) ZRSWOrderLoanInfoDetailModel *infoDetailModel;

@end

@interface ZRSWLoansTopHeaderView : UIView

@property (nonatomic, strong) NSString *headerTitle;

@end

