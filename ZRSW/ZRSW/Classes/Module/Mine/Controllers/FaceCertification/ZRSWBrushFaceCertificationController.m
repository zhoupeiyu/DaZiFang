//
//  ZRSWBrushFaceCertificationController.m
//  ZRSW
//
//  Created by King on 2018/10/18.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWBrushFaceCertificationController.h"

@interface ZRSWBrushFaceCertificationController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *certificeBtn;
@property (nonatomic, assign) BOOL isCertificed;


@end

@implementation ZRSWBrushFaceCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.certificeBtn];
    [self setupLayOut];
}

- (void)setupConfig {
    [super setupConfig];
    [self setLeftBackBarButton];
    self.isCertificed = NO;
    self.title = @"刷脸认证";
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.height.mas_equalTo(16);
    }];
    if (self.isCertificed) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
            make.left.mas_equalTo(112);
            make.right.mas_equalTo(-112);
            make.height.mas_equalTo(kUI_HeightS(150));
        }];
        [self.certificeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(50);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];
    }else{
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
            make.left.mas_equalTo(42);
            make.right.mas_equalTo(-42);
            make.height.mas_equalTo(kUI_HeightS(371));
        }];
        [self.certificeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageView.mas_bottom).offset(40);
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(44);
        }];

    }

}


#pragma mark - event
- (void)certificeBtnClick {
    LLog(@"开始认证");
}


#pragma mark - lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        if (self.isCertificed) {
            _titleLabel.text = @"已认证";
            _titleLabel.textColor = [UIColor colorFromRGB:0x4771F2];
        }else{
            _titleLabel.text = @"请将正对手机去，确保光线充足";
            _titleLabel.textColor = [UIColor colorFromRGB:0x999999];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        if (self.isCertificed) {
            _imageView.image = [UIImage imageNamed:@"face_icon_certified"];
        }else{
            _imageView.image = [UIImage imageNamed:@"face_icon_uncertified"];
        }
    }
    return _imageView;
}

- (UIButton *)certificeBtn {
    if (!_certificeBtn) {
        if (self.isCertificed) {
             _certificeBtn = [ZRSWViewFactoryTool getBlueBtn:@"重新认证" target:self action:@selector(certificeBtnClick)];
        }else{
             _certificeBtn = [ZRSWViewFactoryTool getBlueBtn:@"开始认证" target:self action:@selector(certificeBtnClick)];
        }
    }
    return _certificeBtn;
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
