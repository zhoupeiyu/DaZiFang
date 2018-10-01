//
//  ZRSWAchieveFilterTableView.m
//  ZRSW
//
//  Created by King on 2018/9/30.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWAchieveFilterTableView.h"

@interface ZRSWAchieveFilterTableView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableViewCell *cell;
@end

@implementation ZRSWAchieveFilterTableView
static NSString *reuseId = @"cellId";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseId];
    self.rowHeight = 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview];
    if (self.ZRSWAchieveFilterViewClickBlk) {
        self.ZRSWAchieveFilterViewClickBlk(self.dataArray[indexPath.row]);
    }
}


@end
