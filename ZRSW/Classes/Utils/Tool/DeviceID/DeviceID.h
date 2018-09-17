//
//  DeviceID.h
//  EverInput
//
//  Created by Lines  on 14/7/28.
//  Copyright (c) 2014年 AISpeech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceID : NSObject

+ (DeviceID *)sharedInstance;

+ (NSString *)deviceID;

+ (NSString *)idfaStr;

@end
