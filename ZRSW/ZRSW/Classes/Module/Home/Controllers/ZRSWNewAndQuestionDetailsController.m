//
//  ZRSWNewAndQuestionDetailsController.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWNewAndQuestionDetailsController.h"
#import "ZRSWActionSheetView.h"
#import "ZRSWShareView.h"
#import "UserService.h"
@interface ZRSWNewAndQuestionDetailsController ()<UIWebViewDelegate,PlatformButtonClickDelegate,ShareHandlerDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) NewDetailContensModel *detailContensModel;
@property (nonatomic, strong) CommentQuestionDetailContentModel *questionDetailContentModel;
@end

@implementation ZRSWNewAndQuestionDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"currency_top_share"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(shareButtonClck:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightButton setTintColor:[UIColor colorFromRGB:0xFFB9B9B9]];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton addTarget:self action:@selector(shareButtonClck:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBarRightButton:rightButton leftButton:leftButton];
    if (self.type == DetailsTypePopularInformation) {
        self.navigationItem.title = @"资讯详情";
    }else if (self.type == DetailsTypeSystemNotification){
        self.navigationItem.title = @"公告详情";
    }else if (self.type == DetailsTypeCommentQuestion){
        self.navigationItem.title = @"问题详情";
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.type == DetailsTypePopularInformation || self.type == DetailsTypeSystemNotification) {
         [self requsetNewDetail];
    }else if (self.type == DetailsTypeCommentQuestion){
        [self requsetCommentQuestionDetail];
    }
}


- (void)requsetNewDetail{
    [[[UserService alloc] init] getNewDetail:self.detailModel.id delegate:self];
}


- (void)requsetCommentQuestionDetail{
    [[[UserService alloc] init] getCommentQuestionDetail:self.questionModel.id delegate:self];
}


- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KGetNewsDetailRequest]) {
            NewDetailContenModel *model = (NewDetailContenModel *)resObj;
            if (model.error_code.integerValue == 0) {
                NewDetailContensModel *detailContensModel = model.data;
                self.detailContensModel = detailContensModel;
                id json = [detailContensModel yy_modelToJSONObject];
                LLog(@"%@",json);
                
            }else{
                LLog(@"请求失败:%@",model.error_msg);
            }
        }else if ([reqType isEqualToString:KGetCommentQuestionDetailRequest]) {
            CommentQuestionDetail *commentQuestionDetail = (CommentQuestionDetail *)resObj;
            if (commentQuestionDetail.error_code.integerValue == 0) {
                CommentQuestionDetailContentModel *questionDetailContentModel = commentQuestionDetail.data;
                self.questionDetailContentModel = questionDetailContentModel;
            }else{
                LLog(@"请求失败:%@",commentQuestionDetail.error_msg);
            }
        }
    }else{
        LLog(@"请求失败");
    }
}





- (void)shareButtonClck:(UIButton *)button{
    LLog(@"第三方分享");
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
//    //显示分享面板
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//
//    }];
    [ZRSWShareView shareContent:nil shareSourceType:ShareSourceWap delegate:self];
}


- (void)shareHandlerSuccess:(id)data {
    LLog(@"分享成功#%@",data);
}

- (void)shareHandlerFailed:(NSError *)error {
    LLog(@"分享失败%@",error);
}


-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavigationBarH)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        [_webView sizeToFit];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
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
