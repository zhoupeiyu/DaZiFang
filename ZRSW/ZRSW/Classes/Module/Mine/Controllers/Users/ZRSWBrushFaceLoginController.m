//
//  ZRSWBrushFaceLoginController.m
//  ZRSW
//
//  Created by King on 2018/9/24.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBrushFaceLoginController.h"
@interface ZRSWBrushFaceLoginController ()
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIImageView *headeImageView;
@property (nonatomic, strong) UIButton *faceLoginBtn;
@property (nonatomic, strong) UIButton *toggleLoginModeBtn;

@end

@implementation ZRSWBrushFaceLoginController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.headView];
    [self.headView addSubview:self.iconImageView];
    [self.headView addSubview:self.phoneLabel];
    [self.scrollView addSubview:self.headeImageView];
    [self.scrollView addSubview:self.faceLoginBtn];
    [self.scrollView addSubview:self.toggleLoginModeBtn];
    [self setupLayOut];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.title = @"刷脸登录";
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(111);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(10);
        make.top.mas_equalTo(27);
        make.height.mas_equalTo(16);
    }];

    [self.headeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom).offset(50);
        make.left.mas_equalTo(60);
        make.width.mas_equalTo(SCREEN_WIDTH - 120);
        make.height.mas_equalTo(SCREEN_WIDTH - 120);
    }];

    [self.faceLoginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headeImageView.mas_bottom).offset(60);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 60);
        make.height.mas_equalTo(44);
    }];
    [self.toggleLoginModeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceLoginBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(261);
    }];

}


#pragma mark - event
- (void)toggleLoginModeBtnClick {
    LLog(@"切换登录方式");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)faceLoginBtnClick {
    LLog(@"刷脸登录");
}


#pragma mark - lazy
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor colorFromRGB:0xFFFFFF];
    }
    return _headView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"my_head"];
    }
    return _iconImageView;

}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.text = @"185****1169";
        _phoneLabel.textColor = [UIColor colorFromRGB:0xFF1D1D26];
        _phoneLabel.font = [UIFont systemFontOfSize:16];
    }
    return _phoneLabel;
}

- (UIImageView *)headeImageView{
    if (!_headeImageView) {
        _headeImageView = [[UIImageView alloc] init];
    }
    return _headeImageView;
}

- (UIButton *)faceLoginBtn {
    if (!_faceLoginBtn) {
        _faceLoginBtn = [ZRSWViewFactoryTool getBlueBtn:@"点击进行刷脸登录" target:self action:@selector(faceLoginBtnClick)];
    }
    return _faceLoginBtn;
}

- (UIButton *)toggleLoginModeBtn {
    if (!_toggleLoginModeBtn) {
        _toggleLoginModeBtn = [self getGrayBtn:@"切换登录方式" action:@selector(toggleLoginModeBtnClick)];
    }
    return _toggleLoginModeBtn;
}


- (UIButton *)getGrayBtn:(NSString *)title action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorFromRGB:0x666666] forState:UIControlStateNormal];
    [btn setAdjustsImageWhenHighlighted:YES];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
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
