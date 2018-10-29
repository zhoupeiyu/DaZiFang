//
//  ZRSWUserAgreementController.m
//  ZRSW
//
//  Created by King on 2018/10/29.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWUserAgreementController.h"

@interface ZRSWUserAgreementController ()
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation ZRSWUserAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc]initWithString:API_Agree_Html]]];
    // Do any additional setup after loading the view.
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.navigationItem.title = @"用户协议";
    [self.view addSubview:self.webView];
    [self setupLayOut];
}

- (void)setupLayOut {
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView =[UIWebView new];
        [_webView setUserInteractionEnabled:YES];
        _webView.backgroundColor =[UIColor getBackgroundColor];
        [_webView setOpaque:NO];
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
