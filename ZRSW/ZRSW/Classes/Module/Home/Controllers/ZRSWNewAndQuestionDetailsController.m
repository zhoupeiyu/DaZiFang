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
//    [self.view addSubview:self.webView];
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
    [self setupUI];

}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.roundupLabel];
    [self.contentView addSubview:self.sourceNameLabel];
    [self.contentView addSubview:self.readerIcon];
    [self.contentView addSubview:self.readersLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.lineImge];
    [self.contentView addSubview:self.imgeView];
}


#pragma mark - WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSString *url=[[[request URL]relativeString]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if ([url hasPrefix:@"file://"] && [url containsString:@"News.html"]){
        //创建JSContext对象
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        //OC调用JS方法
        //options:nil 不能修改否则h5识别不了
        if (self.detailContensModel || self.questionDetailContentModel) {
            id detailsJsonString = nil;
            NSString *detailsDicJsonString = nil;
            if (self.type == DetailsTypePopularInformation || self.type == DetailsTypeSystemNotification) {
                detailsJsonString = [self.detailContensModel yy_modelToJSONObject];
                detailsDicJsonString = @{@"htmlType":@"news",@"contentData":detailsJsonString}.yy_modelToJSONString;
            }else if (self.type == DetailsTypeCommentQuestion){
                detailsJsonString = [self.questionDetailContentModel yy_modelToJSONObject];
                detailsDicJsonString = @{@"htmlType":@"faqInfo",@"contentData":detailsJsonString}.yy_modelToJSONString;
            }
        
            //           NSString * method = @"vm.getAppData";
            //         JSValue * function = [context objectForKeyedSubscript:method];
            //         [function callWithArguments:@[detailsDicJsonString]];
            [context evaluateScript:[NSString stringWithFormat:@"vm.getAppData('%@')",detailsDicJsonString]];
        }
//
//
//        }else {
//            [context evaluateScript:[NSString stringWithFormat:@"getAppData('')"]];
    //        }JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //OC调用JS方法
    //options:nil 不能修改否则h5识别不了
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    if (self.detailContensModel || self.questionDetailContentModel) {
////        id detailsJsonString = [self.detailContensModel yy_modelToJSONObject];
////        id questionJsonString = [self.questionDetailContentModel yy_modelToJSONObject];
//        //
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[BaseNetWorkService netWorkHeader]];
//        if (self.type == DetailsTypePopularInformation || self.type == DetailsTypeSystemNotification) {
//            [dic setObject:@"news" forKey:@"htmlType"];
//            [dic setObject:[NSString stringWithFormat:@"%@%@",API_Host,@"api/index/newsInfo"] forKey:@"url"];
//            [dic setObject:self.detailModel.id forKey:@"newsId"];
//        }else if (self.type == DetailsTypeCommentQuestion){
//            [dic setObject:@"faqInfo" forKey:@"htmlType"];
//            [dic setObject:[NSString stringWithFormat:@"%@%@",API_Host,@"api/index/faqInfo"] forKey:@"url"];
//            [dic setObject:self.questionModel.id forKey:@"faqId"];
//        }
//        NSString *detailsDicJsonString = dic.yy_modelToJSONString;
//        [context evaluateScript:[NSString stringWithFormat:@"vm.getAppData('%@')",detailsDicJsonString]];
//    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
    
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
 //           NSString * method = @"vm.getAppData";
   //         JSValue * function = [context objectForKeyedSubscript:method];
   //         [function callWithArguments:@[detailsDicJsonString]];
           [context evaluateScript:[NSString stringWithFormat:@"vm.getAppData('%@')",detailsDicJsonString]];


        }else {
            [context evaluateScript:[NSString stringWithFormat:@"getAppData('')"]];
        }
        return YES;
    }
    BOOL shouldStart = YES;
    return shouldStart;
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
                 [self setDetailContens];
                //加载h5
//                NSURLRequest *resquest = [NSURLRequest requestWithURL:self.url];
//                [self.webView loadRequest:resquest];
            }else{
                LLog(@"请求失败:%@",model.error_msg);
                   [TipViewManager showToastMessage:model.error_msg];
            }
        }else if ([reqType isEqualToString:KGetCommentQuestionDetailRequest]) {
            CommentQuestionDetail *commentQuestionDetail = (CommentQuestionDetail *)resObj;
            if (commentQuestionDetail.error_code.integerValue == 0) {
                CommentQuestionDetailContentModel *questionDetailContentModel = commentQuestionDetail.data;
                self.questionDetailContentModel = questionDetailContentModel;
                [self setDetailContens];
//                NSURLRequest *resquest = [NSURLRequest requestWithURL:self.url];
//                [self.webView loadRequest:resquest];
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

- (void)setupLayOut {
    [super setupLayOut];
    self.roundupLabel.frame = CGRectMake(kUI_WidthS(15),kUI_HeightS(13), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(64));
    [self.roundupLabel sizeToFit];
    if (self.type == DetailsTypeCommentQuestion){
        [self.sourceNameLabel removeFromSuperview];
        [self.readerIcon removeFromSuperview];
        [self.readersLabel removeFromSuperview];
        [self.contentLabel removeFromSuperview];
        self.sourceNameLabel.frame = CGRectMake(0,0,0,0);
        self.readerIcon.frame = CGRectMake(0,0,0,0);
        self.readersLabel.frame = CGRectMake(0,0,0,0);
        self.dateLabel.frame = CGRectMake(self.readersLabel.right +  kUI_WidthS(30),self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(150), kUI_HeightS(10));
        self.lineImge.frame = CGRectMake((SCREEN_WIDTH - kUI_WidthS(360))/2 ,self.dateLabel.bottom + kUI_HeightS(15), kUI_WidthS(360), kUI_HeightS(1));
        self.contentLabel.frame = CGRectMake(0,0,0,0);
    }else  if (self.type == DetailsTypeSystemNotification){
        [self.sourceNameLabel removeFromSuperview];
        [self.readerIcon removeFromSuperview];
        [self.readersLabel removeFromSuperview];
        self.sourceNameLabel.frame = CGRectMake(0,0,0,0);
        self.readerIcon.frame = CGRectMake(0,0,0,0);
        self.readersLabel.frame = CGRectMake(0,0,0,0);
        self.dateLabel.frame = CGRectMake(self.roundupLabel.left,self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(150), kUI_HeightS(10));
        self.lineImge.frame = CGRectMake((SCREEN_WIDTH - kUI_WidthS(360))/2 ,self.dateLabel.bottom + kUI_HeightS(15), kUI_WidthS(360), kUI_HeightS(1));
        self.contentLabel.frame = CGRectMake(self.roundupLabel.left,self.lineImge.bottom + kUI_HeightS(15), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(114));
        [self.contentLabel sizeToFit];
    }else{
        self.sourceNameLabel.frame = CGRectMake(kUI_WidthS(15),self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(64), kUI_HeightS(10));
        self.readerIcon.frame = CGRectMake(self.sourceNameLabel.right + kUI_WidthS(15),self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(15), kUI_HeightS(10));
        self.readersLabel.frame = CGRectMake(self.readerIcon.right + kUI_WidthS(3),self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(33), kUI_HeightS(10));
        self.dateLabel.frame = CGRectMake(self.readersLabel.right +  kUI_WidthS(30),self.roundupLabel.bottom + kUI_HeightS(9), kUI_WidthS(150), kUI_HeightS(10));
        self.lineImge.frame = CGRectMake((SCREEN_WIDTH - kUI_WidthS(360))/2 ,self.dateLabel.bottom + kUI_HeightS(15), kUI_WidthS(360), kUI_HeightS(1));
        self.contentLabel.frame = CGRectMake(self.roundupLabel.left,self.lineImge.bottom + kUI_HeightS(15), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(114));
        [self.contentLabel sizeToFit];
    }

    if (self.type == DetailsTypeCommentQuestion){
        if (self.questionDetailContentModel.imgUrl == nil ||[self.questionDetailContentModel.imgUrl isEqualToString:@""] ) {
            [self.imgeView removeFromSuperview];
            self.imgeView.frame = CGRectMake(0,0,0,0);
            self.contentView.frame = CGRectMake(0,kUI_HeightS(10), SCREEN_WIDTH, self.contentLabel.bottom + kUI_HeightS(20));
        }else{
            self.imgeView.frame = CGRectMake(self.roundupLabel.left,self.contentLabel.bottom + kUI_HeightS(15), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(150));
             self.contentView.frame = CGRectMake(0,kUI_HeightS(10), SCREEN_WIDTH, self.imgeView.bottom + kUI_HeightS(20));
        }
    }else{
        if (self.detailContensModel.imgUrl == nil ||[self.detailContensModel.imgUrl isEqualToString:@""] ) {
            [self.imgeView removeFromSuperview];
            self.imgeView.frame = CGRectMake(0,0,0,0);
            self.contentView.frame = CGRectMake(0,kUI_HeightS(10), SCREEN_WIDTH, self.contentLabel.bottom + kUI_HeightS(20));

        }else{
            self.imgeView.frame = CGRectMake(self.roundupLabel.left,self.contentLabel.bottom + kUI_HeightS(15), SCREEN_WIDTH - kUI_WidthS(30), kUI_HeightS(150));
            self.contentView.frame = CGRectMake(0,kUI_HeightS(10), SCREEN_WIDTH, self.imgeView.bottom + kUI_HeightS(20));
        }
    }
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.contentView.frame) + kUI_HeightS(20));
}

- (void)setDetailContens{
    if (self.type == DetailsTypePopularInformation) {
        self.roundupLabel.text = self.detailContensModel.roundup;
        self.sourceNameLabel.text = self.detailContensModel.sourceName;
        self.readerIcon.image = [UIImage imageNamed:@"currency_watch_number"];
        self.readersLabel.text = [NSString stringWithFormat:@"%@",self.detailContensModel.readers];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.detailContensModel.updateTime substringToIndex:10];
        NSDate* date = [formatter dateFromString:dateStr];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateString = [formatter stringFromDate:date];
        self.dateLabel.text = dateString;
        self.lineImge.image = [UIImage imageNamed:@"currency_line_720"];
        NSMutableAttributedString * htmlString = [[NSMutableAttributedString alloc] initWithData:[self.detailContensModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        self.contentLabel.attributedText = htmlString;
        [self.imgeView sd_setImageWithURL:[NSURL URLWithString:self.detailContensModel.imgUrl] placeholderImage:nil];
    }else if (self.type == DetailsTypeSystemNotification) {
        self.roundupLabel.text = self.detailContensModel.title;
        self.dateLabel.text = self.detailContensModel.updateTime;
        self.lineImge.image = [UIImage imageNamed:@"currency_line_720"];
        NSMutableAttributedString * htmlString = [[NSMutableAttributedString alloc] initWithData:[self.detailContensModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        self.contentLabel.attributedText = htmlString;
        [self.imgeView sd_setImageWithURL:[NSURL URLWithString:self.detailContensModel.imgUrl] placeholderImage:nil];
    }else if (self.type == DetailsTypeCommentQuestion){
        self.roundupLabel.text = [self.questionDetailContentModel.faqBody getZZwithString:self.questionDetailContentModel.faqBody];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [self.questionDetailContentModel.updateTime substringToIndex:10];
        NSDate* date = [formatter dateFromString:dateStr];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *dateString = [formatter stringFromDate:date];
        self.dateLabel.text = dateString;
        self.lineImge.image = [UIImage imageNamed:@"currency_line_720"];
        [self.imgeView sd_setImageWithURL:[NSURL URLWithString:self.questionDetailContentModel.imgUrl] placeholderImage:nil];
    }
    [self setupLayOut];
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

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
    }
    return _contentView;
}

- (UIImageView *)lineImge{
    if (!_lineImge) {
        _lineImge = [[UIImageView alloc] init];
    }
    return _lineImge;
}


- (UILabel *)roundupLabel{
    if (!_roundupLabel) {
        _roundupLabel = [[UILabel alloc] init];
        _roundupLabel.textColor = [UIColor colorFromRGB:0xFF444152];
        _roundupLabel.textAlignment = NSTextAlignmentLeft;
        _roundupLabel.font = [UIFont systemFontOfSize:16];
        _roundupLabel.numberOfLines = 0;
    }
    return _roundupLabel;
}

- (UILabel *)sourceNameLabel{
    if (!_sourceNameLabel) {
        _sourceNameLabel = [[UILabel alloc] init];
        _sourceNameLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _sourceNameLabel.textAlignment = NSTextAlignmentLeft;
        _sourceNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sourceNameLabel;
}
- (UIImageView *)readerIcon{
    if (!_readerIcon) {
        _readerIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _readerIcon;
}


- (UILabel *)readersLabel{
    if (!_readersLabel) {
        _readersLabel = [[UILabel alloc] init];
        _readersLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _readersLabel.textAlignment = NSTextAlignmentLeft;
        _readersLabel.font = [UIFont systemFontOfSize:10];
    }
    return _readersLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = [UIFont systemFontOfSize:10];
    }
    return _dateLabel;
}


- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorFromRGB:0xFF4F4E5C];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (UIImageView *)imgeView{
    if (!_imgeView) {
        _imgeView = [[UIImageView alloc] init];
    }
    return _imgeView;
}


@end
