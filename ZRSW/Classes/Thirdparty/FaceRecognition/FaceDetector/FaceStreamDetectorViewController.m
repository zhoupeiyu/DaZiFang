//
//  FaceStreamDetectorViewController.m
//  ZRSW
//
//  Created by King on 2018/10/19.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#import "FaceStreamDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "PermissionDetector.h"
#import "UIImage+Extensions.h"
#import "UIImage+compress.h"
#import "CaptureManager.h"
#import "CanvasView.h"
#import "CalculatorTools.h"
#import "UIImage+Extensions.h"
#import "IFlyFaceImage.h"
#import "IFlyFaceResultKeys.h"
#import "ZRSWLoginController.h"

@interface FaceStreamDetectorViewController ()<CaptureManagerDelegate,CaptureNowImageDelegate>{
    UIImageView *imgView;//动画图片展示
    AVAudioPlayer *audioPlayer;
    //拍照操作
    AVCaptureStillImageOutput *myStillImageOutput;
    BOOL isStartHeaderRigth;//判断向右转头开始
    BOOL isStartHeaderLeft;//判断向左转头开始
    BOOL isStartMouthOpen;//判断张嘴开始
    BOOL isStartMouthClose;//判断张嘴开始
    BOOL isStartEyeClose;//判断闭眼开始
    BOOL isStartEyeOpen;//判断睁眼开始

    BOOL isFinishHeaderRigth;//判断向右转头完成
    BOOL isFinishHeaderLeft;//判断开始向左转头
    BOOL isFinishMouthOpen;//判断开始张嘴
    BOOL isFinishMouthClose;//判断开始张嘴
    BOOL isFinishEyeClose;//判断开始闭眼
    BOOL isFinishEyeOpen;//判断开始睁眼

    int numberStart;//开始
    int numberHeaderRigth;//向右转头
    int numberHeaderLeft;//向左转头
    int numberMouthOpen;//张嘴
    int numberMouthClose;//闭嘴
    int numberEyeClose;//闭眼
    int numberEyeOpen;//睁眼
    int numberComplete;//完成
}
@property (nonatomic, retain ) UIView         *previewView;
@property (nonatomic, strong) UIImageView *textBg;
@property (nonatomic, strong ) UILabel        *textLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, retain ) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain ) CaptureManager             *captureManager;

@property (nonatomic, strong ) CanvasView                 *viewCanvas;
@property (nonatomic, strong ) UITapGestureRecognizer     *tapGesture;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation FaceStreamDetectorViewController
@synthesize captureManager;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [BaseTheme baseViewColor];
    //创建界面
    [self makeUI];
    //创建摄像页面
    [self makeCamera];
    //创建数据
    [self makeNumber];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brushFaceLoginResult:) name:BrushFaceLoginResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brushFaceCertificationResult:) name:BrushFaceCertificationResultNotification object:nil];
}

- (void)brushFaceLoginResult:(NSNotification *)result{
    NSDictionary *resultDic = result.object;
    NSString *resultStr = [resultDic valueForKey:@"result"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([resultStr isEqualToString:@"Successful"]) {
            for (BaseViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ZRSWLoginController class]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [(ZRSWLoginController *)vc dismissViewControllerAnimated:NO completion:nil];
                }
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}

- (void)brushFaceCertificationResult:(NSNotification *)result{
    NSDictionary *resultDic = result.object;
    NSString *resultStr = [resultDic valueForKey:@"result"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([resultStr isEqualToString:@"Successful"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    });

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    //停止摄像
    [self.previewLayer.session stopRunning];
    [self.captureManager removeObserver];
}

-(void)makeNumber{
    isStartHeaderRigth = NO;
    isStartHeaderLeft = NO;
    isStartMouthOpen = NO;
    isStartMouthClose = NO;
    isStartEyeClose = NO;
    isStartEyeOpen = NO;

    isFinishHeaderRigth = NO;
    isFinishHeaderLeft = NO;
    isFinishMouthOpen = NO;
    isFinishMouthClose = NO;
    isFinishEyeClose = NO;
    isFinishEyeOpen = NO;

    numberStart = 0;
    numberHeaderRigth = 0;
    numberHeaderLeft = 0;
    numberMouthClose = 0;
    numberMouthOpen= 0;
    numberEyeClose = 0;
    numberEyeOpen = 0;
    numberComplete = 0;
}

#pragma mark --- 创建UI界面
-(void)makeUI{
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 412)];
    [self.view addSubview:self.previewView];
    self.textBg = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2, self.previewView.bottom+20, 150, 32)];
    self.textBg.image = [UIImage imageNamed:@"face_certification_tips_frame"];
    [self.view addSubview:self.textBg];
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2, self.previewView.bottom+21, 150, 30)];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.layer.cornerRadius = 15;
    self.textLabel.text = @"请正对屏幕";
    self.textLabel.textColor = [UIColor colorFromRGB:0x666666];
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.textLabel];
    //提示框
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2, self.textBg.bottom+25, 150, 150)];
    imgView.image = [UIImage imageNamed:@"face_icon_certification_default"];
    [self.view addSubview:imgView];

    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, ScreenHeight - 80, 60, 30)];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorFromRGB:0x4771F2] forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
}


-(void)cancelButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 播放操作提示声音
- (void)playVoiceWithWithName:(NSString *)name{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //  获取音频文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    // 转换成本地url对象(注意本地路径使用下面方法)
    NSURL *url = [NSURL fileURLWithPath:path];
    // 1.创建音频播放对象
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // 设置代理对象
    //    _audioPlayer.delegate = self;
    // 2.添加到播放列队中
    [audioPlayer prepareToPlay];
    // 3.播放
    [audioPlayer play];
    audioPlayer.volume = 1;
}


#pragma mark --- 创建相机
-(void)makeCamera{
    //adjust the UI for iOS 7
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (IOS7_OR_LATER ){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    self.previewView.backgroundColor=[UIColor clearColor];

    //初始化 CaptureSessionManager
    self.captureManager=[[CaptureManager alloc] init];
    self.captureManager.capturedelegate=self;
    self.previewLayer=self.captureManager.previewLayer;
    
    self.captureManager.previewLayer.frame= self.previewView.frame;
    self.captureManager.previewLayer.position=self.previewView.center;
    self.captureManager.previewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:self.captureManager.previewLayer];
    
    self.viewCanvas = [[CanvasView alloc] initWithFrame:self.captureManager.previewLayer.frame] ;
    [self.previewView addSubview:self.viewCanvas] ;
    self.viewCanvas.center=self.captureManager.previewLayer.position;
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    NSString *str = [NSString stringWithFormat:@"{{%f, %f}, {220, 240}}",(ScreenWidth-220)/2,(ScreenWidth-240)/2+15];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:str forKey:@"RECT_KEY"];
    [dic setObject:@"1" forKey:@"RECT_ORI"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:dic];
    self.viewCanvas.arrFixed = arr;
    self.viewCanvas.hidden = NO;
    
    //建立 AVCaptureStillImageOutput
    myStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [myStillImageOutput setOutputSettings:myOutputSettings];
    [self.captureManager.session addOutput:myStillImageOutput];
    //开始摄像
    [self.captureManager setup];
    [self.captureManager addObserver];
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf playVoiceWithWithName:@"isOpposite"];
        weakSelf.captureManager.nowImageDelegate=self;
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    [self.captureManager observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


-(void)returnNowShowImage:(UIImage *)image{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (numberStart > 80) {
            if (isFinishHeaderRigth != YES) {
                if (!isStartHeaderRigth) {
                    [weakSelf playVoiceWithWithName:@"headerRigth"];
                    weakSelf.textLabel.text = @"请向右转头";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_header_right_" count:2];
                    isStartHeaderRigth = YES;
                }
                if ([imgView isAnimating]) {
                    numberHeaderRigth ++;
                    LLog(@"====向右转头%d",numberHeaderRigth);
                    if (numberHeaderRigth == 35) {
                        LLog(@"====向右转头图片");
                        [weakSelf.faceDelegate sendFaceImage:image];
                    }
                }else{
                    isFinishHeaderRigth = YES;
                    imgView.animationImages = nil;
                }
            }
            if (isFinishHeaderRigth == YES && isFinishHeaderLeft != YES) {
                if (!isStartHeaderLeft) {
                    [weakSelf playVoiceWithWithName:@"headerLeft"];
                    weakSelf.textLabel.text = @"请向左转头";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_header_left_" count:2];
                    isStartHeaderLeft = YES;
                }
                if ([imgView isAnimating]) {
                    numberHeaderLeft ++;
                    LLog(@"====向左转头%d",numberHeaderRigth);
                    if (numberHeaderLeft == 35) {
                        LLog(@"====向左转头图片");
                        [weakSelf.faceDelegate sendFaceImage:image];
                    }
                }else{
                    isFinishHeaderLeft = YES;
                    imgView.animationImages = nil;
                }
            }
            if (isFinishHeaderLeft == YES && isFinishMouthOpen != YES) {
                if (!isStartMouthOpen) {
                    [weakSelf playVoiceWithWithName:@"mouthOpen"];
                    weakSelf.textLabel.text = @"请张嘴";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_mouth_open_" count:2];
                    isStartMouthOpen = YES;
                }
                if ([imgView isAnimating]) {
                    numberMouthOpen ++;
                    LLog(@"====张嘴%d",numberMouthOpen);
                    if (numberMouthOpen == 35) {
                        LLog(@"====张嘴图片");
                        [weakSelf.faceDelegate sendFaceImage:image];
                    }
                }else{
                    isFinishMouthOpen = YES;
                    imgView.animationImages = nil;
                }
            }
            if (isFinishMouthOpen == YES && isFinishMouthClose != YES) {
                if (!isStartMouthClose) {
                    [weakSelf playVoiceWithWithName:@"mouthClose"];
                    weakSelf.textLabel.text = @"请闭嘴";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_mouth_close_" count:2];
                    isStartMouthClose = YES;
                }
                if ([imgView isAnimating]) {
                    numberMouthClose ++;
                    LLog(@"====闭嘴%d",numberMouthClose);
                    if (numberMouthClose == 35) {
                        LLog(@"====闭嘴图片");
                        [weakSelf.faceDelegate sendFaceImage:image];
                    }
                }else{
                    isFinishMouthClose = YES;
                    imgView.animationImages = nil;
                }
            }

            if (isFinishMouthClose == YES && isFinishEyeOpen != YES) {
                if (!isStartEyeOpen) {
                    [weakSelf playVoiceWithWithName:@"eyeOpen"];
                    weakSelf.textLabel.text = @"请睁眼";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_eye_open_" count:2];
                    isStartEyeOpen = YES;
                }
                if ([imgView isAnimating]) {
                    numberEyeOpen ++;
                    LLog(@"====睁眼%d",numberEyeClose);
                    if (numberEyeOpen == 20) {
                        LLog(@"====睁眼图片");
                    }
                }else{
                    isFinishEyeOpen = YES;
                    imgView.animationImages = nil;
                }
            }
            if (isFinishEyeOpen == YES && isFinishEyeClose != YES) {
                if (!isStartEyeClose) {
                    [weakSelf playVoiceWithWithName:@"eyeClose"];
                    weakSelf.textLabel.text = @"请闭眼";
                    [weakSelf tomAnimationWithName:@"face_icon_certification_eye_close_" count:2];
                    isStartEyeClose = YES;
                }
                if ([imgView isAnimating]) {
                    numberEyeClose ++;
                    LLog(@"====闭眼%d",numberEyeClose);
                    if (numberEyeClose == 35) {
                        LLog(@"====闭眼图片");
                        [weakSelf.faceDelegate sendFaceImage:image];
                    }
                }else{
                    isFinishEyeClose = YES;
                    imgView.animationImages = nil;
                }
            }
            if (isFinishEyeClose == YES) {
                imgView.image = [UIImage imageNamed:@"face_icon_certification_default"];
                numberComplete ++;
                LLog(@"====可正对屏幕%d",numberComplete);
                if (numberComplete==10) {
                    [weakSelf playVoiceWithWithName:@"canOpposite"];
                    self.textLabel.text = @"可正对屏幕";
                }else if (numberComplete == 80) {
                    [weakSelf.faceDelegate sendFaceImage:image];
                    self.captureManager.nowImageDelegate=nil;
                    [self delateNumber];//清数据
                    [weakSelf.previewLayer.session stopRunning];
                    if (weakSelf.isLogin) {
                        [weakSelf playVoiceWithWithName:@"login"];
                        self.textLabel.text = @"正在登录，请稍后";
                    }else{
                        [weakSelf playVoiceWithWithName:@"certification"];
                        self.textLabel.text = @"正在认证，请稍后";
                    }
                }
            }
        }else{
            numberStart ++;
            LLog(@"====请正对屏幕%d",numberStart);
        }
    });
}


#pragma mark --- 拍照
-(void)didClickTakePhoto{
    AVCaptureConnection *myVideoConnection = nil;
    //从 AVCaptureStillImageOutput 中取得正确类型的 AVCaptureConnection
    for (AVCaptureConnection *connection in myStillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                myVideoConnection = connection;
                break;
            }
        }
    }
    //撷取影像（包含拍照音效）
    [myStillImageOutput captureStillImageAsynchronouslyFromConnection:myVideoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        //完成撷取时的处理程序(Block)
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            //取得的静态影像
            UIImage *myImage = [[UIImage alloc] initWithData:imageData];
            //停止摄像
            [self.previewLayer.session stopRunning];
            [self delateNumber];
            [self.faceDelegate sendFaceImage:myImage];
            UIImageWriteToSavedPhotosAlbum(myImage, self, NULL, NULL);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark --- 清掉对应的数
-(void)delateNumber{
    [imgView stopAnimating];
    numberStart = 0;
    numberHeaderRigth = 0;
    numberHeaderLeft = 0;
    numberMouthClose = 0;
    numberMouthOpen= 0;
    numberEyeClose = 0;
    numberEyeOpen = 0;
    numberComplete = 0;
    imgView.animationImages = nil;
    imgView.image = [UIImage imageNamed:@"face_icon_certification_default"];
}

#pragma mark --- UIImageView显示gif动画
- (void)tomAnimationWithName:(NSString *)name count:(NSInteger)count{
    // 如果正在动画，直接退出
    if ([imgView isAnimating]) return;
    // 动画图片的数组
    NSMutableArray *arrayM = [NSMutableArray array];
    // 添加动画播放的图片
    for (int i = 0; i < count; i++) {
        // 图像名称
        NSString *imageName = [NSString stringWithFormat:@"%@%d", name,i];
        UIImage *image = [UIImage imageNamed:imageName];
        [arrayM addObject:image];
    }
    // 设置动画数组
    imgView.animationImages = arrayM;
    // 重复1次
    imgView.animationRepeatCount = 2;
    // 动画时长
    imgView.animationDuration = imgView.animationImages.count * 0.75;
    // 开始动画
    [imgView startAnimating];
}

-(void)dealloc{
    self.captureManager=nil;
    self.viewCanvas=nil;
    [self.previewView removeGestureRecognizer:self.tapGesture];
    self.tapGesture=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
