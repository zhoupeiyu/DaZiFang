//
//  UIDevice+Info.h
//  LexueMath
//
//  Created by Danny on 15/3/10.
//  Copyright (c) 2015年 Lines. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_1X [[UIDevice currentDevice] is1x]
#define IS_2X [[UIDevice currentDevice] is2x]
#define IS_3X [[UIDevice currentDevice] is3x]

@interface UIDevice(Info)
- (NSString *)modelName;
- (BOOL)is1x;
- (BOOL)is2x;
- (BOOL)is3x;
- (BOOL)isIPhone4;
- (BOOL)isIPhone5;
- (BOOL)isIPhone6;
- (BOOL)isIPhone6P;
/** mac地址 */
+ (NSString *)macAddress;

/** ram的size */
+ (NSUInteger)ramSize;

/** cpu个数 */
+ (NSUInteger)cpuNumber;

/** 系统的版本号 */
+ (NSString *)systemVersion;

/** 是否有摄像头 */
+ (BOOL)hasCamera;

/** 获取手机内存总量, 返回的是字节数 */
+ (NSUInteger)totalMemoryBytes;

/** 获取手机可用内存, 返回的是字节数 */
+ (NSUInteger)freeMemoryBytes;

/** 获取手机硬盘总空间, 返回的是字节数 */
+ (NSUInteger)totalDiskSpaceBytes;

/** 获取手机硬盘空闲空间, 返回的是字节数 */
+ (NSUInteger)freeDiskSpaceBytes;

/// Whether the device is a simulator.
@property (nonatomic, readonly, getter=isSimulator) BOOL isSimulator;

// 系统版本比较
- (BOOL)systemVersionLowerThan:(NSString*)version;
- (BOOL)systemVersionNotHigherThan:(NSString *)version;
- (BOOL)systemVersionHigherThan:(NSString*)version;
- (BOOL)systemVersionNotLowerThan:(NSString *)version;

@end
