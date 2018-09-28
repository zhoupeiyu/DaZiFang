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
#import "UserService.h"


@interface ZRSWRealNameAuthController () <LoginCustomViewDelegate>
@property (nonatomic, strong) ZRSWLoginCustomView *userNameView;
@property (nonatomic, strong) ZRSWLoginCustomView *ipCardView;
@property (nonatomic, strong) ZRSWIPCardView *userCardView;
@property (nonatomic, strong) ZRSWIPCardView *cardView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *ipCard;
@property (nonatomic, strong) UserService *service;
@property (nonatomic, strong) UploadImagesManager *imageManager;


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
    if (self.userName.length == 0) {
        [TipViewManager showToastMessage:@"请输入姓名！"];
        return;
    }
    if (![MatchManager checkUserIdCard:self.ipCard]) {
        [TipViewManager showToastMessage:@"请输入正确的身份证号码！"];
        return;
    }
    if ([self.userCardView getSelectedImages].count < 2) {
        [TipViewManager showToastMessage:@"请上传手持身份证照片！"];
        return;
    }
    if ([self.cardView getSelectedImages].count < 2) {
        [TipViewManager showToastMessage:@"请上传身份证照片！"];
        return;
    }
    
    WS(weakSelf);
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[self.userCardView getSelectedImages]];
    [arr addObjectsFromArray:[self.cardView getSelectedImages]];
    if ([TipViewManager showNetErrorToast]) {
        [TipViewManager showLoading];
        [self.imageManager uploadImagesWithImagesArray:arr completeBlock:^(NSMutableArray * _Nullable imageUrls) {
            NSString *idCardImg1 = [imageUrls objectAtIndex:2];
            NSString *idCardImg2 = [imageUrls objectAtIndex:3];
            NSString *idCardImg3 = [imageUrls objectAtIndex:0];
            NSString *idCardImg4 = [imageUrls objectAtIndex:1];
            [weakSelf.service userRealNameValidationIdCard:self.userName idCard:self.ipCard idCardImg1:idCardImg1 idCardImg2:idCardImg2 idCardImg3:idCardImg3 idCardImg4:idCardImg4 delegate:self];
        }];
    }
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
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    [TipViewManager dismissLoading];
    if (status == RequestFinishedStatusSuccess) {
        if ([reqType isEqualToString:KUserValidationIdCardRequest]) {
            BaseModel *model = (BaseModel *)resObj;
            if (model.error_code == 0) {
                [TipViewManager showToastMessage:@"认证成功!"];
            }
            else {
                [TipViewManager showToastMessage:model.error_msg];
            }
        }
    }
    else {
        [TipViewManager showNetErrorToast];
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
- (UserService *)service {
    if (!_service) {
        _service = [[UserService alloc] init];
    }
    return _service;
}
- (UploadImagesManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [UploadImagesManager sharedInstance];
        _imageManager.imageType = UploadImageTypeJpg;
        _imageManager.name = @"file";
        _imageManager.url = @"api/user/uploadFile";
    }
    return _imageManager;
}
@end
