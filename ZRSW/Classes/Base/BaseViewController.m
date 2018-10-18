//
//  BaseViewController.m
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ZRSWLoginController.h"

@interface BaseViewController ()
@property (nonatomic, assign) BOOL pushToLogin;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginError:) name:UserLoginErrorNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.preferNavigationHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    UIStatusBarStyle style = [[UIApplication sharedApplication] statusBarStyle];
    if (style != [self preferredStatusBarStyle]) {
        [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupConfig {
    self.view.backgroundColor = [BaseTheme baseViewColor];
}

- (void)setupUI {
    
}

- (void)setupLayOut {
    
}
- (void)setStatusBarHidden:(BOOL)aHidden {
    [[UIApplication sharedApplication] setStatusBarHidden:aHidden withAnimation:UIStatusBarAnimationNone];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)userLoginError:(NSNotification *)noti {
    [UserModel removeUserData];
    [TipViewManager dismissLoading];
    
    UIViewController *currntVC = [UIViewController currentViewController];
    
    if (self.pushToLogin || [currntVC isKindOfClass:NSClassFromString(@"PSTExtendedAlertController")]) {
        //防止viewWillAppear里有网络请求，导致登录界面返回后又继续跳登录
        return;
    }
    self.pushToLogin = YES;
    UIViewController *rootVC = [(AppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
    UIViewController *presentedVC = rootVC;
    while (presentedVC.presentedViewController) {
        presentedVC = presentedVC.presentedViewController;
    }
    if ([presentedVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)presentedVC;
        UIViewController *navVC = [nav.viewControllers firstObject];
        if ([navVC isKindOfClass:[ZRSWLoginController class]]) {
            return;
        }
    }
    ZRSWLoginController *loginViewController = [[ZRSWLoginController alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginViewController];
    NSString *alertStr = noti.object[@"error_msg"];
    [TipViewManager showAlertControllerWithTitle:@"请重新登录" message:alertStr preferredStyle:PSTAlertControllerStyleAlert actionTitle:@"确定" handler:^(PSTAlertAction *action) {
        [presentedVC presentViewController:nav animated:YES completion:nil];
    } controller:self completion:nil];
    
}
/**
 *  设置导航默认返回按钮
 */
- (void)setLeftBackBarButton {
    [self setLeftBarButtonWithImage:[UIImage imageNamed:@"currency_top_back"] AndHighLightImage:[UIImage imageNamed:@"currency_top_back"]];
    [_leftBarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  设置导航左侧按钮图片
 *
 *  @param normalImage    正常图片
 *  @param highLightImage 高亮图片
 */
- (void)setLeftBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage {
    
    _leftBarButton = [[UIButton alloc] init];
    _leftBarButton.frame = CGRectMake(0, 0, 40, 40);
    [_leftBarButton setImage:normalImage forState:UIControlStateNormal];
    [_leftBarButton setImage:highLightImage forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    _leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 9);
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        space.width = 9;
    }else{
        space.width = 30;
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftButtonItem, nil];
}

- (void)setLeftBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage AndText:(NSString *)text{
    CGSize textSize = [text getSizeWithFont:[BaseTheme navBarLeftTextFont]];
    CGFloat height = normalImage.size.height > textSize.height ? normalImage.size.height : textSize.height;
    CGFloat width = textSize.width + normalImage.size.width;
    _leftBarButton = [[UIButton alloc] init];
    _leftBarButton.frame = CGRectMake(0, 0, width, height);
    _leftBarButton.titleLabel.font = [BaseTheme navBarLeftTextFont];
    [_leftBarButton setImage:normalImage forState:UIControlStateNormal];
    [_leftBarButton setImage:highLightImage forState:UIControlStateHighlighted];
    [_leftBarButton setTitle:text forState:UIControlStateNormal];
    [_leftBarButton setTitle:text forState:UIControlStateHighlighted];
    [_leftBarButton setTitleColor:[BaseTheme navBarLeftTextColor] forState:UIControlStateNormal];
    [_leftBarButton setTitleColor:[BaseTheme navBarLeftHTextColor] forState:UIControlStateHighlighted];
    [_leftBarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -4;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftButtonItem, nil];
}

/**
 *  设置导航左侧按钮文本
 *
 *  @param text 导航按钮文本
 */
- (void)setLeftBarButtonWithText:(NSString *)text{
    CGSize buttonSize = [text getSizeWithFont:[BaseTheme navBarLeftTextFont]];
    _leftBarButton = [[UIButton alloc] init];
    _leftBarButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    _leftBarButton.titleLabel.font = [BaseTheme navBarLeftTextFont];
    [_leftBarButton setTitle:text forState:UIControlStateNormal];
    [_leftBarButton setTitle:text forState:UIControlStateHighlighted];
    [_leftBarButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_leftBarButton setTitleColor:[BaseTheme navBarLeftTextColor] forState:UIControlStateNormal];
    [_leftBarButton setTitleColor:[BaseTheme navBarLeftHTextColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftBarButton];
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -4;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftButtonItem, nil];
}

/**
 *  设置导航右侧按钮图片
 *
 *  @param normalImage    正常图片
 *  @param highLightImage 高亮图片
 */
- (void)setRightBarButtonWithImage:(UIImage *)normalImage AndHighLightImage:(UIImage *)highLightImage{
    
    _rightBarButton = [[UIButton alloc] init];
    _rightBarButton.frame = CGRectMake(0, 0, 44, 44);
    [_rightBarButton setImage:normalImage forState:UIControlStateNormal];
    [_rightBarButton setImage:highLightImage forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        space.width = -4;
    }else{
        space.width = 14;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space,rightButtonItem, nil];
}

/**
 *  设置导航右侧按钮文本
 *
 *  @param text 导航按钮文本
 */
- (void)setRightBarButtonWithText:(NSString *)text{
    CGSize buttonSize = [text getSizeWithFont:[BaseTheme navBarRightTextFont]];
    _rightBarButton = [[UIButton alloc] init];
    _rightBarButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    _rightBarButton.titleLabel.font = [BaseTheme navBarRightTextFont];
    [_rightBarButton setTitle:text forState:UIControlStateNormal];
    [_rightBarButton setTitle:text forState:UIControlStateHighlighted];
    [_rightBarButton setTitleColor:[BaseTheme navBarRightTextColor] forState:UIControlStateNormal];
    [_rightBarButton setTitleColor:[BaseTheme navBarRightHTextColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
        space.width = 24;
        
    }else {
        space.width = 24;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space,rightButtonItem, nil];
}

- (void)setRightBarRightButton:(UIButton *)rightButton leftButton:(UIButton *)leftButton {
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    rightButton.frame = CGRectMake(leftButton.right , 0, 44.f, 44.f);
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    CGFloat width = 44.0+44.0+15;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width,0, width, 44.f)];
    [customView addSubview:rightButton];
    [customView addSubview:leftButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)requestFinishedWithStatus:(RequestFinishedStatus)status resObj:(id)resObj reqType:(NSString *)reqType {
    
}
@end
