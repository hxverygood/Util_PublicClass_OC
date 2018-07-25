//
//  NSString+HXDate.m
//  Baili
//
//  Created by xabaili on 16/1/9.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import "NSString+HXDate.h"


@implementation NSString (HXDate)

/**
 *  将时间NSDate转换为字符串
 *
 *  @param timeStamp        时间戳
 *  @param dateFormaterType 包含种格式
 *  @param separator    年月日之间的分隔符
 *
 *  @return 返回一个字符串
 */
+ (instancetype)stringFromDateWithTimeStamp:(NSTimeInterval)timeStamp
                              dateFormatter:(DateFormatterType)dateFormaterType
                               andSeparator:(NSString *)separator {
    // 计算时间戳数字位数
    NSInteger tmp = timeStamp / 1000000000;
    if (tmp > 10) {
        NSInteger count = 1;
        double time = tmp;
        while (time / 10 >= 1) {
            time = time / 10;
            count *= 10;
        }
        timeStamp /= count;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (dateFormaterType) {
        case DateFormatterTypeYM:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"YYYY年MM月"];
            }
            else {
                 formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM", separator];
            }
            break;
        case DateFormatterTypeYMd:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd", separator, separator];
            break;
        case DateFormatterTypeYMdKKmm:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd  HH:mm", separator, separator];
            break;
            
        case DateFormatterTypeYMdKKmmss:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd  HH:mm:ss", separator, separator];
            break;
            
        default:
            break;
    }
    
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;
    
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}



+ (instancetype)stringFromCurrentTimeStampWithDateFormatter:(DateFormatterType)dateFormaterType
                                               andSeparator:(NSString *)separator {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    switch (dateFormaterType) {
        case DateFormatterTypeYM:
            if ([NSString isBlankString:separator]) {
                formatter.dateFormat = [NSString stringWithFormat:@"YYYY年MM月"];
            }
            else {
                formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM", separator];
            }
        break;
            
        case DateFormatterTypeYMd:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd", separator, separator];
            break;
            
        case DateFormatterTypeYMdKKmm:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd HH:mm", separator, separator];
            break;
            
        case DateFormatterTypeYMdKKmmss:
            formatter.dateFormat = [NSString stringWithFormat:@"YYYY%@MM%@dd HH:mm:ss", separator, separator];
            break;
            
        default:
            break;
    }
    
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.locale = local;
    
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/// 将时间戳字符串转换为指定时间格式的时间字符串
+ (nullable NSString *)convertToDateStringWithTimestampString:(NSString *)timestampString dateFormatter:(DateFormatterType)dateFormaterType andSeparator:(NSString *)separator {
    if ([NSString isBlankString:timestampString]) {
        return nil;
    }
    else {
        NSNumber *timeNum = [timestampString convertToNumber];
        if (timeNum) {
            NSString *timeStr = [NSString stringFromDateWithTimeStamp:timeNum.doubleValue dateFormatter:DateFormatterTypeYMd andSeparator:@"."];
            return timeStr;
        }
        else {
            return timestampString;
        }
    }
}

/// 获取当前时间戳
+ (instancetype)getCurrentTimeStamp {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970] * 1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}


#pragma mark - Private Func

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
