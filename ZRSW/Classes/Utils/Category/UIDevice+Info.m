//
//  UIDevice+Info.m
//  LexueMath
//
//  Created by Danny on 15/3/10.
//  Copyright (c) 2015年 Lines. All rights reserved.
//

#import "UIDevice+Info.h"
#import "sys/utsname.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/processor_info.h>

@implementation UIDevice(Info)
- (NSString *)modelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSArray *modelArray = @[
                            @"i386", @"x86_64",
                            
                            @"iPhone1,1",
                            @"iPhone1,2",
                            @"iPhone2,1",
                            @"iPhone3,1",
                            @"iPhone3,2",
                            @"iPhone3,3",
                            @"iPhone4,1",
                            @"iPhone5,1",
                            @"iPhone5,2",
                            @"iPhone5,3",
                            @"iPhone5,4",
                            @"iPhone6,1",
                            @"iPhone6,2",
                            @"iPhone7,1",
                            @"iPhone7,2",
                            
                            @"iPod1,1",
                            @"iPod2,1",
                            @"iPod3,1",
                            @"iPod4,1",
                            @"iPod5,1",
                            
                            @"iPad1,1",
                            @"iPad2,1",
                            @"iPad2,2",
                            @"iPad2,3",
                            @"iPad2,4",
                            @"iPad3,1",
                            @"iPad3,2",
                            @"iPad3,3",
                            @"iPad3,4",
                            @"iPad3,5",
                            @"iPad3,6",
                            @"iPad4,1",
                            @"iPad4,2",
                            @"iPad4,3",
                            @"iPad5,3",
                            @"iPad5,4",
                            
                            @"iPad4,4",
                            @"iPad4,5",
                            @"iPad4,6",
                            @"iPad4,7",
                            @"iPad4,8",
                            @"iPad4,9",
                            @"iPad2,5",
                            @"iPad2,6",
                            @"iPad2,7",
                            ];
    NSArray *modelNameArray = @[
                                
                                @"iPhone Simulator", @"iPhone Simulator",
                                
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iphone 6Plus",
                                @"iphone 6",
                                
                                @"iPod Touch 1G",
                                @"iPod Touch 2G",
                                @"iPod Touch 3G",
                                @"iPod Touch 4G",
                                @"iPod Touch 5G",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                @"iPad iPad Air",
                                @"iPad iPad Air",
                                @"iPad iPad Air",
                                @"iPad iPad Air2",
                                @"iPad iPad Air2",
                                
                                @"iPad mini2",
                                @"iPad mini2",
                                @"ipad mini2",
                                @"iPad mini3",
                                @"iPad mini4",
                                @"ipad mini3",
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"
                                ];
    NSInteger modelIndex = - 1;
    NSString *modelNameString = nil;
    modelIndex = [modelArray indexOfObject:deviceString];
    if (modelIndex >= 0 && modelIndex < [modelNameArray count]) {
        modelNameString = [modelNameArray objectAtIndex:modelIndex];
    }
    return modelNameString;
}

- (BOOL)is1x
{
    NSArray *modelNameArray = @[
                                @"iPhone 2G",
                                @"iPhone 3G",
                                @"iPhone 3GS",
                                
                                @"iPad",
                                @"iPad 2(WiFi)",
                                @"iPad 2(GSM)",
                                @"iPad 2(CDMA)",
                                @"iPad 2(WiFi + New Chip)",
                                
                                @"iPad mini (WiFi)",
                                @"iPad mini (GSM)",
                                @"ipad mini (GSM+CDMA)"

                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)is2x
{
    NSArray *modelNameArray = @[
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                @"iphone 6",
                                
                                @"iPad 3(WiFi)",
                                @"iPad 3(GSM+CDMA)",
                                @"iPad 3(GSM)",
                                @"iPad 4(WiFi)",
                                @"iPad 4(GSM)",
                                @"iPad 4(GSM+CDMA)",
                                @"iPad iPad Air",
                                @"iPad iPad Air",
                                @"iPad iPad Air",
                                @"iPad iPad Air2",
                                @"iPad iPad Air2",
                                
                                @"iPad mini2",
                                @"iPad mini2",
                                @"ipad mini2",
                                @"iPad mini3",
                                @"iPad mini4",
                                @"ipad mini3",
                                
                                @"iPod Touch 4G",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    return NO;
}
- (BOOL)is3x
{
    NSArray *modelNameArray = @[
                                @"iphone 6Plus",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }

    return NO;
}

- (BOOL)isIPhone4
{
    NSArray *modelNameArray = @[
                                @"iPhone 4(GSM)",
                                @"iPhone 4(GSM Rev A)",
                                @"iPhone 4(CDMA)",
                                @"iPhone 4S",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isIPhone5
{
    NSArray *modelNameArray = @[
                                @"iPhone 5(GSM)",
                                @"iPhone 5(GSM+CDMA)",
                                @"iPhone 5c(GSM)",
                                @"iPhone 5c(Global)",
                                @"iphone 5s(GSM)",
                                @"iphone 5s(Global)",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)isIPhone6
{
    NSArray *modelNameArray = @[
                                @"iphone 6",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    
    return NO;
}
- (BOOL)isIPhone6P
{
    NSArray *modelNameArray = @[
                                @"iphone 6Plus",
                                ];
    NSString *aModelName = [self modelName];
    for (NSString *str in modelNameArray)
    {
        if ([str isEqualToString:aModelName])
        {
            return YES;
        }
    }
    
    return NO;
}
+ (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

+ (NSUInteger)ramSize {
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)cpuNumber {
    return [self getSysInfo:HW_NCPU];
}


+ (NSUInteger)totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)freeMemoryBytes
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

+ (NSUInteger)freeDiskSpaceBytes
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *number = attributes[NSFileSystemFreeSize];
    return [number unsignedIntegerValue];
}

+ (NSUInteger)totalDiskSpaceBytes
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSNumber *number = attributes[NSFileSystemSize];
    return [number unsignedIntegerValue];
}
- (BOOL)isSimulator {
    static dispatch_once_t one;
    static BOOL simu;
    dispatch_once(&one, ^{
        simu = NSNotFound != [[self model] rangeOfString:@"Simulator"].location;
    });
    return simu;
}
- (BOOL)systemVersionLowerThan:(NSString *)version {
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)systemVersionHigherThan:(NSString *)version {
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)systemVersionNotHigherThan:(NSString *)version {
    if (version == nil || version.length == 0) {
        return NO;
    }
    
    if ([self.systemVersion isEqualToString:version]) {
        return YES;
    } else {
        return [self systemVersionLowerThan:version];
    }
}

- (BOOL)systemVersionNotLowerThan:(NSString *)version {
    if (version == nil || version.length == 0) {
        NSLog(@"### Error Version");
        return NO;
    }
    
    if ([self.systemVersion isEqualToString:version]) {
        return YES;
    } else {
        return [self systemVersionHigherThan:version];
    }
}

@end
