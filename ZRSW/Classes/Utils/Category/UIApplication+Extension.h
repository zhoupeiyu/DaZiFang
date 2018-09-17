//
//  UIApplication+Extension.h
//  LXMath
//
//  Created by 周培玉 on 2018/1/18.
//  Copyright © 2018年 LXM. All rights reserved.
//

#import <UIKit/UIKit.h>



/// Returns "Documents" folder in this app's sandbox.
NSString *NSDocumentsPath(void);

/// Returns "Library" folder in this app's sandbox.
NSString *NSLibraryPath(void);

/// Returns "Caches" folder in this app's sandbox.
NSString *NSCachesPath(void);

@interface UIApplication (Extension)

//document
@property (nonatomic, readonly,getter=documentsURL) NSURL *documentsURL;
@property (nonatomic, readonly,getter=documentsPath) NSString *documentsPath;
//caches
@property (nonatomic, readonly, getter=cachesURL) NSURL *cachesURL;
@property (nonatomic, readonly, getter=cachesPath) NSString *cachesPath;
//library
@property (nonatomic, readonly, getter=libraryURL) NSURL *libraryURL;
@property (nonatomic, readonly, getter=libraryPath) NSString *libraryPath;

@property (nonatomic, readonly, getter=appBundleName) NSString *appBundleName;
@property (nonatomic, readonly, getter=appBundleID) NSString *appBundleID;
@property (nonatomic, readonly, getter=appVersion) NSString *appVersion;
@property (nonatomic, readonly, getter=appBuildVersion) NSString *appBuildVersion;


//内存使用
@property (nonatomic, readonly, getter=memoryUsage) int64_t memoryUsage;
//cpu 使用
@property (nonatomic, readonly, getter=cpuUsage) float cpuUsage;

/// App是否被破解了
/// Whether this app is priated (not from appstore).
@property (nonatomic, readonly, getter=isPirated) BOOL isPirated;

/// App是否正在被调试
/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly, getter= isBeingDebugged) BOOL isBeingDebugged;

@end
