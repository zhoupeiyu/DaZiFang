//
//  ZRSWRealNameAuthController.m
//  ZRSW
//
//  Created by 周培玉 on 2018/9/20.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "ZRSWRealNameAuthController.h"
#import "ZRSWLoginCustomView.h"
#import "ZRSWIPCardView.h"


@interface ZRSWRealNameAuthController () <LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *ipCardView;
@property (nonatomic, strong) ZRSWIPCardView *userCardView;
@property (nonatomic, strong) ZRSWIPCardView *cardView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *ipCard;

@end

@implementation ZRSWRealNameAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
   
}
- (void)setupUI {
    [super setupUI];
    [self.scrollView addSubview:self.userNameView];
    [self.scrollView addSubview:self.ipCardView];
    [self.scrollView addSubview:self.userCardView];
    [self.scrollView addSubview:self.cardView];
    [self setupLayOut];
}
- (void)setupConfig {
    [super setupConfig];
    self.title = @"实名认证";
    [self setLeftBackBarButton];
    [self setRightBarButtonWithText:@"提交"];
    [self.rightBarButton addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBarButton setAdjustsImageWhenHighlighted:YES];
    [self.rightBarButton setAdjustsImageWhenDisabled:YES];
}

- (void)setupLayOut {
    [super setupLayOut];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.ipCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.userNameView.mas_bottom);
        make.height.mas_equalTo([ZRSWLoginCustomView loginInputViewHeight]);
    }];
    [self.userCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.ipCardView.mas_bottom);
        make.height.mas_equalTo([ZRSWIPCardView viewHeight:IPCardViewTypePerson]);
    }];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.userCardView.mas_bottom);
        make.height.mas_equalTo([ZRSWIPCardView viewHeight:IPCardViewTypePerson]);
    }];
}
#pragma mark - action

- (void)commitBtnAction {
    
}

#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string customView:(ZRSWLoginCustomView *)customView {
    if (customView == self.userNameView) {
        
    }
    else if (customView == self.ipCardView) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 18) {
            return NO;//限制长度
        }
        return YES;
    }
    return YES;
}
- (void)textFieldTextDidChange:(UITextField *)textField customView:(ZRSWLoginCustomView *)customView {
    NSString *text = textField.text;
    if (customView == self.userNameView) {
        self.userName = text;
    }
    else if (customView == self.ipCardView) {
        self.ipCard = text;
    }
}

#pragma mark - lazy

- (ZRSWLoginCustomView *)userNameView {
    if (!_userNameView) {
        _userNameView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"真实姓名" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入真实姓名" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _userNameView.delegate = self;
    }
    return _userNameView;
}
- (ZRSWLoginCustomView *)ipCardView {
    if (!_ipCardView) {
        _ipCardView = [ZRSWLoginCustomView getLoginInputViewWithTitle:@"身份证号" placeHoled:[[NSAttributedString alloc] initWithString:@"请输入身份证号" attributes:@{NSForegroundColorAttributeName : [ZRSWLoginCustomView placeHoledColor]}] keyboardType:UIKeyboardTypeDefault isNeedCountDownButton:NO isNeedBottomLine:YES];
        _ipCardView.delegate = self;
    }
    return _ipCardView;
}
- (ZRSWIPCardView *)userCardView {
    if (!_userCardView) {
        _userCardView = [ZRSWIPCardView getIPCardViewWithType:IPCardViewTypePerson title:@"上传手持身份证照片(需与本人一起拍照)" fristViewContent:@"点击上传\n手持身份证正面照片" secondContent:@"点击上传\n手持身份证反面照片" isNeedBottomLine:YES presentVC:self];
    }
    return _userCardView;
}

- (ZRSWIPCardView *)cardView {
    if (!_cardView) {
        _cardView = [ZRSWIPCardView getIPCardViewWithType:IPCardViewTypePerson title:@"上传手持身份证照片" fristViewContent:@"点击上传\n身份证正面照片" secondContent:@"点击上传\n身份证反面照片" isNeedBottomLine:NO presentVC:self];
    }
    return _cardView;
}
@end