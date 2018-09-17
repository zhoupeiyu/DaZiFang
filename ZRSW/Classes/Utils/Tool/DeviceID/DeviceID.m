//
//  DeviceID.m
//  EverInput
//
//  Created by Lines  on 14/7/28.
//  Copyright (c) 2014年 AISpeech. All rights reserved.
//

#import "DeviceID.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "SynthesizeSingleton.h"
//#import "SSKeychain.h"
#import "SAMKeychain.h"
#import <AdSupport/AdSupport.h>
NSString * const kKCServiceName = @"group.AiIME";
NSString * const kUDIDName = @"UDID";

@interface DeviceID ()

@property (nonatomic, strong) NSString *uniqueID;

@end

@implementation DeviceID

SYNTHESIZE_SINGLETON_ARC(DeviceID);

- (id)init {
    self = [super init];
    if (self) {
        self.uniqueID = [SAMKeychain passwordForService:kKCServiceName account:kUDIDName];
        if (0 == self.uniqueID.length) {
            self.uniqueID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            self.uniqueID = [self.uniqueID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [SAMKeychain setPassword:self.uniqueID forService:kKCServiceName account:kUDIDName];
        }
    }
    return self;
}

+ (NSString *)deviceID {
    return [[self sharedInstance] uniqueID];
}

+ (NSString *)idfaStr {
	NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
	if (idfa.length <= 0) {
		idfa = @"用户未授权获取idfa";
	}
	return idfa;
}
@end
