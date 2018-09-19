//
//  ZRSWNewAndQuestionDetailsController.m
//  ZRSW
//
//  Created by King on 2018/9/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWNewAndQuestionDetailsController.h"

@interface ZRSWNewAndQuestionDetailsController ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;
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


- (void)shareButtonClck:(UIButton *)button{
    LLog(@"第三方分享");
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