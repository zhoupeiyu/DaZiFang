//
//  ZRSWOnlineCustomerServiceController.m
//  ZRSW
//
//  Created by King on 2018/9/27.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWOnlineCustomerServiceController.h"

@interface ZRSWOnlineCustomerServiceController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation ZRSWOnlineCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loggedInEMClient];
    [self setUpChatController];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"在线客服";
    [self setLeftBackBarButton];
}

- (void)loggedInEMClient{
    EMClient *client = [EMClient sharedClient];
    WS(weakSelf);
    if (client.isLoggedIn != YES) {
        UserModel *userModel = [UserModel getCurrentModel];
        UserInfoModel *userInfoModel = userModel.data;
        [[EMClient sharedClient] loginWithUsername:userInfoModel.huanXinName password:kHuanXinpassword completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                LLog(@"登录成功");
            } else {
                LLog(@"登录失败");
                [TipViewManager showAlertControllerWithTitle:@"温馨提示" message:@"暂时无法与客服沟通" preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"知道了" handler:^(PSTAlertAction *action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } controller:nil completion:nil];

            }
        }];
    } else { //已经成功登录
        LLog(@"已经登录");
    }
}


- (void)setUpChatController{
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"dazifang_kefu" conversationType:EMConversationTypeChat];
    [self addChildViewController:chatController];
    [self.view addSubview:chatController.view];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
