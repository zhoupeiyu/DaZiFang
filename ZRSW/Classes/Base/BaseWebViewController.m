//
//  ZRSWBaseWebViewController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/10/26.
//  Copyright © 2018 周培玉. All rights reserved.
//

#import "BaseWebViewController.h"
#import <NJKWebViewProgressView.h>

@interface BaseWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>

@property (nonatomic, strong) NSString *url;
@property (strong, nonatomic) UIWebView *myWebView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
    [self setupUI];
}

- (void)showWebView:(NSString *)url {
    self.url = url;
    [self refreshLoadView];
}

- (void)setupConfig {
    [self setRightBarButtonWithText:@"取消"];
    [self.rightBarButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupLayOut {
    [self.myWebView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
}

- (void)setupUI {
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.progressView];
    [self setupLayOut];
}

- (void)refreshLoadView {
    if (_url == nil) return;
    if ([TipViewManager showNetErrorToast]) {
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:_url]]];
    }
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[NJKWebViewProgressView alloc] init];
        _progressView.backgroundColor =[UIColor clearColor];
    }
    return _progressView;
}
- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        self.myWebView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}
- (UIWebView *)myWebView {
    if (!_myWebView) {
        _myWebView =[UIWebView new];
        [_myWebView setUserInteractionEnabled:YES];  //是否支持交互
        _myWebView.backgroundColor =[UIColor getBackgroundColor];
        [_myWebView setOpaque:NO];  //透明
        _myWebView.delegate = self;
        
    }
    return _myWebView;
}
- (void)dismissController {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}
@end
