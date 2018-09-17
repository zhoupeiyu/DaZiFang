//
//  NSArray+Extension.m
//  LXMath
//
//  Created by 周培玉 on 2018/1/17.
//  Copyright © 2018年 LXM. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (NSArray *)reverseArray {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [arrayTemp addObject:element];
    }

    return arrayTemp;
}
@end
