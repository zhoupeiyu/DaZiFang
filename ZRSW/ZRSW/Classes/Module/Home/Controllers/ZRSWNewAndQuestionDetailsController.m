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


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *roundupLabel;
@property (nonatomic, strong) UILabel *sourceNameLabel;
@property (nonatomic, strong) UIImageView *readerIcon;
@property (nonatomic, strong) UILabel *readersLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *lineImge;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imgeView;
@end

@implementation ZRSWNewAndQuestionDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
    if (self.type == DetailsTypePopularInformation || self.type == DetailsTypeSystemNotification) {
        [self requsetNewDetail];
    }else if (self.type == DetailsTypeCommentQuestion){
        [self requsetCommentQuestionDetail];
    }
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
//    if (self.type == DetailsTypePopularInformation) {
//        self.navigationItem.title = @"资讯详情";
//    }else if (self.type == DetailsTypeSystemNotification){
//        self.navigationItem.title = @"公告详情";
//    }else if (self.type == DetailsTypeCommentQuestion){
//        self.navigationItem.title = @"问题详情";
//    }

}




#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //OC调用JS方法
    //options:nil 不能修改否则h5识别不了
    if (self.detailContensModel || self.questionDetailContentModel) {
        id detailsJsonString = nil;
        NSString *detailsDicJsonString = nil;
        if (self.type == DetailsTypeSystemNotification) {
            detailsJsonString = [self.detailContensModel yy_modelToJSONObject];
            detailsDicJsonString = @{@"htmlType":@"system",@"contentData":detailsJsonString}.yy_modelToJSONString;
        }else if (self.type == DetailsTypePopularInformation) {
            detailsJsonString = [self.detailContensModel yy_modelToJSONObject];
            detailsDicJsonString = @{@"htmlType":@"news",@"contentData":detailsJsonString}.yy_modelToJSONString;
        }else if (self.type == DetailsTypeCommentQuestion){
            detailsJsonString = [self.questionDetailContentModel yy_modelToJSONObject];
            detailsDicJsonString = @{@"htmlType":@"faqInfo",@"contentData":detailsJsonString}.yy_modelToJSONString;
        }

        [context evaluateScript:[NSString stringWithFormat:@"vm.getAppData('%@')",detailsDicJsonString]];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}



- (void)requsetNewDetail{
    [TipViewManager showLoading];
    [[[UserService alloc] init] getNewDetail:self.detailModel.id delegate:self];
}


- (void)requsetCommentQuestionDetail{
     [TipViewManager showLoading];
    [[[UserService alloc] init] getCommentQuestionDetail:self.questionModel.id delegate:self];
}


- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType{
    [TipViewManager dismissLoading];
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
                   [TipViewManager showToastMessage:model.error_msg];
            }
        }else if ([reqType isEqualToString:KGetCommentQuestionDetailRequest]) {
            CommentQuestionDetail *commentQuestionDetail = (CommentQuestionDetail *)resObj;
            if (commentQuestionDetail.error_code.integerValue == 0) {
                CommentQuestionDetailContentModel *questionDetailContentModel = commentQuestionDetail.data;
                self.questionDetailContentModel = questionDetailContentModel;
                NSURLRequest *resquest = [NSURLRequest requestWithURL:self.url];
                [self.webView loadRequest:resquest];
            }else{
                LLog(@"请求失败:%@",commentQuestionDetail.error_msg);
                [TipViewManager showToastMessage:commentQuestionDetail.error_msg];
            }
        }
    }else{
        LLog(@"请求失败");
    }
}


- (void)shareButtonClck:(UIButton *)button{
    LLog(@"第三方分享");
    ZRSWShareModel *model = [[ZRSWShareModel alloc] init];
    if (self.type == DetailsTypeSystemNotification){
        model.title = self.detailContensModel.title;
        model.sourceUrlStr = [NSString stringWithFormat:@"http://zhongrong.ijiaoban.cn/wechat/share/articlesDetail?articlesId=%@&articlesNum=1",self.detailContensModel.id];
        NSString *content = [NSString stringWithFormat:@"%@",self.detailContensModel.content];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            content = [content stringByRemovingPercentEncoding];
        }else{
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        model.content = [content filterHTML:content];
    }else if (self.type == DetailsTypePopularInformation) {
        model.title = self.detailContensModel.title;
        model.sourceUrlStr = [NSString stringWithFormat:@"http://zhongrong.ijiaoban.cn/wechat/share/articlesDetail?articlesId=%@&articlesNum=2",self.detailContensModel.id];
        NSString *content = [NSString stringWithFormat:@"%@",self.detailContensModel.content];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            content = [content stringByRemovingPercentEncoding];
        }else{
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        model.content = [content filterHTML:content];
    }else if (self.type == DetailsTypeCommentQuestion){
        model.title = self.questionDetailContentModel.title;
        model.sourceUrlStr = [NSString stringWithFormat:@"http://zhongrong.ijiaoban.cn/wechat/share/articlesDetail?articlesId=%@&articlesNum=3",self.questionDetailContentModel.id];
        NSString *content = [NSString stringWithFormat:@"%@",self.questionDetailContentModel.faqBody];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            content = [content stringByRemovingPercentEncoding];
        }else{
            content = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        model.content = [content filterHTML:content];
    }
    if (self.image) {
        model.thumbImage = self.image;
    }else{
        model.thumbImage = [UIImage imageNamed:@"icon_80.png"];
    }
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
        _webView.backgroundColor = [UIColor clearColor];
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
