//
//  NSDate+Utils.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/4/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+ (NSDate * __nullable)currentDate {
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];

    return currentDate;
}

@end
