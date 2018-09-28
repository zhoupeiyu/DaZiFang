//
//  ZRSWSettingController.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWSettingController.h"
#import "ZRSWFeedBackController.h"
@interface ZRSWSettingController ()

@end

@implementation ZRSWSettingController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.navigationItem.title = @"设置";
}

- (void)setUpTableView{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
//    UITableViewCellSeparatorStyleSingleLineEtched
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"my_phone"];
        cell.textLabel.text = @"版本号";
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kUI_WidthS(36), kUI_HeightS(20))];
        versionLabel.text = [[UIApplication sharedApplication] appVersion];;
        cell.accessoryView = versionLabel;
    }else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"my_order"];
        cell.textLabel.text = @"用户协议";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_information_arrow"]];
    }else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"my_order"];
        cell.textLabel.text = @"意见反馈";
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_information_arrow"]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kUI_HeightS(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        LLog(@"用户协议");
    }else if (indexPath.row == 2) {
        LLog(@"意见反馈");
        ZRSWFeedBackController *feedBackVC = [[ZRSWFeedBackController alloc] init];
        feedBackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
}

@end
