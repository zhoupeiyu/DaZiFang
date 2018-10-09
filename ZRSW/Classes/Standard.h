//
//  Standard.h
//  ProjectFramework
//
//  Created by 周培玉 on 2018/9/10.
//  Copyright © 2018年 周培玉. All rights reserved.
//

#ifndef Standard_h
#define Standard_h

#define MainColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define MAX_RECORD_TIME                     120.0f
#define VIDEO_PLAYER_CONTROL_BAR_ALPHA      0.6f

#define kCommonCellHeight                   44
#define kCommonTextFrameHeight              48

#define kTabBarH        49.0f
#define kStatusBarH     [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarH (IS_IPHONE_X ? 88.0f : 64.0f)
#define kiphonexBottom (IS_IPHONE_X ? 34.0f : 0.f)
#define kiphonexTop (IS_IPHONE_X ? 24.0f : 0.f)

#define LSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

//version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IsIOS7                          SYSTEM_VERSION_GREATER_THAN(@"7.0")
#define IsIOS8                          SYSTEM_VERSION_GREATER_THAN(@"8.0")
#define IsIOS10P                        SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define ISIOS7_ORLESS                   SYSTEM_VERSION_LESS_THAN(@"7.0")
#define ISIOS9_ORLESS                   SYSTEM_VERSION_LESS_THAN(@"9.0")
#define ISIOS11_ORLESS                  SYSTEM_VERSION_LESS_THAN(@"11.0")

#define ISIOS9_GREATER                  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

#define IS_IPAD                         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA                       ([[UIScreen mainScreen] scale] >= 2.0)

#define KeyWindow                       UIApplication.sharedApplication.keyWindow
#define SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH               (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH               (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS             (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5                     (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6                     (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P                    (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_5_OR_LESS             (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_6_OR_LESS             (IS_IPHONE && SCREEN_MAX_LENGTH <= 667.0)

#define IS_IPHONE_X                      ((int)((SCREEN_HEIGHT/SCREEN_WIDTH)*100) == 216)?YES:NO
//scale
#define Scare                           [[UIScreen mainScreen] scale]
#define KSeparatorLineHeight                      (Scare >= 1 ? 1/Scare : 1)
#define kUI_WidthS(a)                   (((a) / 375.0) * SCREEN_WIDTH)
#define kUI_HeightS(a)                  (((a) / 667.0) * SCREEN_HEIGHT)

#define WS(weakSelf)                    __weak __typeof(&*self)weakSelf = self;

#ifdef DEBUG

#define DLog( s, ... ) printf("\n%s\n",[[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] )

#else

#define DLog( s, ... )

#endif


#ifdef DEBUG
#define LLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define LLog(...)
#endif


//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//真机
#endif

#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

#pragma clang diagnostic ignored "-Wdocumentation"
#pragma clang diagnostic ignored "-Wstrict-prototypes"


#endif /* Standard_h */
