//
//  ZRSWBannerDetailsController.m
//  ZRSW
//
//  Created by King on 2018/9/25.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBannerDetailsController.h"
@interface ZRSWBannerDetailsController ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;
@end

@implementation ZRSWBannerDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = self.bannerModel.title;
    NSURL *url = [NSURL URLWithString:self.bannerModel.href];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView sizeToFit];
}


- (void)goBack{
    if ([self.webView canGoBack]){   // webView本身回退
        [self.webView goBack];
    }else{   // 原生回退
        [self.navigationController popViewControllerAnimated:YES];
    }
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
