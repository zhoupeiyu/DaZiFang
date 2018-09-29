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
#import <JavaScriptCore/JavaScriptCore.h>
/* Unique URL triggered when JavaScript reports page load is complete */
NSString *kCompleteRPCURL = @"webviewprogress:///complete";
@interface ZRSWNewAndQuestionDetailsController ()<UIWebViewDelegate,ShareHandlerDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) NewDetailContensModel *detailContensModel;
@property (nonatomic, strong) CommentQuestionDetailContentModel *questionDetailContentModel;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;
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

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=[[[request URL]relativeString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//个人情况，url里面会加入中文
//    LLog(@"%@",url);
    if ([url hasPrefix:@"file://"] && [url containsString:@"News.html"]){
        //创建JSContext对象
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //OC调用JS方法
        //options:nil 不能修改否则h5识别不了
        if (self.detailContensModel) {
            id detailsJsonString = [self.detailContensModel yy_modelToJSONObject];
            LLog(@"%@",detailsJsonString);
             NSString *detailsDicJsonString = nil;
            if (self.type == DetailsTypePopularInformation || self.type == DetailsTypeSystemNotification) {
               detailsDicJsonString = @{@"htmlType":@"news",@"contentData":detailsJsonString}.yy_modelToJSONString;
            }else if (self.type == DetailsTypeCommentQuestion){
                detailsDicJsonString = @{@"htmlType":@"faqInfo",@"contentData":detailsJsonString}.yy_modelToJSONString;
            }
//            NSString * method = @"vm.getAppData";
//            JSValue * function = [context objectForKeyedSubscript:method];
//            [function callWithArguments:@[detailsDicJsonString]];
            [context evaluateScript:[NSString stringWithFormat:@"vm.getAppData('%@')",detailsDicJsonString]];
        }else {
            [context evaluateScript:[NSString stringWithFormat:@"getAppData('')"]];
        }
        return YES;
    }
    BOOL shouldStart = YES;
    //TODO: Implement TOModalWebViewController Delegate callback

    //if the URL is the load completed notification from JavaScript
//    if ([request.URL.absoluteString isEqualToString:kCompleteRPCURL]){
//        return NO;
//    }
//    //If the URL contrains a fragement jump (eg an anchor tag), check to see if it relates to the current page, or another
//    //If we're merely jumping around the same page, don't perform a new loading bar sequence
//    BOOL isFragmentJump = NO;
//    if (request.URL.fragment){
//        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
//        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
//    }
//
//    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
//    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
//    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward){
//        //Save the URL in the accessor property
//        self.url = [request URL];
//    }
    return shouldStart;
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
                NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:detailContensModel.imgUrl]];
                self.image = [UIImage imageWithData:data]; // 取得图片
                //加载h5
                NSURLRequest *resquest = [NSURLRequest requestWithURL:self.url];
                [self.webView loadRequest:resquest];
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
    ZRSWShareModel *model = [[ZRSWShareModel alloc] init];
    model.sourceUrlStr = self.detailContensModel.sourceUrl;
    if (self.image) {
        model.thumbImage = self.image;
    }else{
        model.thumbImage = [UIImage imageNamed:@"icon_80.png"];
    }
    model.title = self.detailContensModel.title;
    model.content = self.detailContensModel.roundup;

    [ZRSWShareView shareContent:model shareSourceType:ShareSourceWap delegate:self];
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
        _webView.backgroundColor = [UIColor redColor];
        [_webView sizeToFit];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}
- (NSURL *)url{
    if (!_url) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"News" ofType:@"html"];
        if (path) {
            _url = [NSURL fileURLWithPath:path];
        }
    }
    return _url;
}

@end
