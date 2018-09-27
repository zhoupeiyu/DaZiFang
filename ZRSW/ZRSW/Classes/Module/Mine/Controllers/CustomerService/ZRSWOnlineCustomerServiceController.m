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
    [self setUpChatController];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"在线客服";
    [self setLeftBackBarButton];
}

- (void)setUpChatController{
    EMClient *client = [EMClient sharedClient];
    if (client.isLoggedIn != YES) {
        [[EMClient sharedClient] loginWithUsername:@"MEM18000022"password:@"123456"completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                LLog(@"登录成功");
                EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"abcd400" conversationType:EMConversationTypeChat];
                [self addChildViewController:chatController];
                [self.view addSubview:chatController.view];
            } else {
                LLog(@"登录失败");
            }
        }];
    } else { //已经成功登录
        LLog(@"已经登录");
        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"abcd400" conversationType:EMConversationTypeChat];
        [self addChildViewController:chatController];
        [self.view addSubview:chatController.view];
    }
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
