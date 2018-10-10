//
//  ZRSWOnlineCustomerServiceController.m
//  ZRSW
//
//  Created by King on 2018/9/27.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWOnlineCustomerServiceController.h"

@interface ZRSWOnlineCustomerServiceController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *nickName;
@end

@implementation ZRSWOnlineCustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self loggedInClient];
    [self setUpChatController];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    self.title = @"在线客服";
    [self setLeftBackBarButton];
}


- (void)loggedInClient{
    WS(weakSelf);
    HDClient *client = [HDClient sharedClient];
    if (client.isLoggedInBefore != YES) {
        UserModel *userModel = [UserModel getCurrentModel];
        UserInfoModel *userInfoModel = userModel.data;
        HDError *error = [client loginWithUsername:userInfoModel.huanXinName password:kHuanXinpassword];
        if (!error) {
            //登录成功
             LLog(@"登录成功");
        } else {
            //登录失败
             LLog(@"登录失败");
            [TipViewManager showAlertControllerWithTitle:@"温馨提示" message:@"暂时无法与客服沟通" preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"知道了" handler:^(PSTAlertAction *action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                                } controller:nil completion:nil];
        }
    }else{
        LLog(@"已经登录");
    }
}

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message{
    //用户可以根据自己的用户体系，根据message设置用户昵称和头像
    id<IMessageModel> model =nil;
    model = [[EaseMessageModel alloc]initWithMessage:message];
    NSString *CurrentName = [[EMClient sharedClient] currentUsername];
    NSString *msgame = model.message.from;
    // 客服和用户的信息都会在这个方法里面解析所以我们可以自定义自己想要的头像和名称
    if ([CurrentName isEqualToString:msgame]){
        model.avatarImage = self.iconImage;
        model.nickname = self.nickName;
    }else{
        if(![message.ext[@"weichat"][@"agent"][@"userNickname"]isEqual:[NSNull null]]){
            //这个是客服那边传过来的信息。需要登录客服管理帐号设置里面把权限打开，才会传给客户端。
            model.nickname = message.ext[@"weichat"][@"agent"][@"userNickname"];
            NSString *ImageURl = [NSString stringWithFormat:@"%@%@",@"http://kefu.easemob.com/ossimages",message.ext[@"weichat"][@"agent"][@"avatar"]];
            model.avatarURLPath = ImageURl;
        }
    }
    return model;
}




- (void)setUpChatController{
    [TipViewManager showLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [self getUserInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
             [TipViewManager dismissLoading];
            EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"dazifang_kefu" conversationType:EMConversationTypeChat];
            chatController.delegate = self;
            chatController.dataSource = self;
            [self addChildViewController:chatController];
            [self.view addSubview:chatController.view];
        });
    });

}

- (void)getUserInfo{
    UserModel *userModel = [UserModel getCurrentModel];
    UserInfoModel *userInfoModel = userModel.data;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:userInfoModel.headImgUrl]];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentUserIocnImage];
    self.iconImage = [UIImage imageWithData:data];
    if (!self.iconImage) {
        self.iconImage = [UIImage imageNamed:@"my_head"];
    }
    self.nickName = userInfoModel.nickName;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[HDClient sharedClient] logout:YES];
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
