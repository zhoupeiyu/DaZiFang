//
//  BaseTableViewController.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/11.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, strong) UITableView *tableView;

- (void)showPlaceholedView;
- (void)enableRefreshHeader:(BOOL)enabled refreshSelector:(SEL)selector;
- (void)enableLoadMore:(BOOL)enabled selector:(SEL)selector;
- (void)endHeadRefreshing;
- (void)endFootRefreshing;

@end
