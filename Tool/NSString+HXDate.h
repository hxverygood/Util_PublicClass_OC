//
//  NSString+HXDate.h
//  Baili
//
//  Created by xabaili on 16/1/9.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateFormatterType) {
    DateFormatterTypeYM = 0,       // 年月
    DateFormatterTypeYMd = 1,       // 年月日
    DateFormatterTypeYMdKKmm = 2,     // 年月日 (24)小时 分钟
    DateFormatterTypeYMdKKmmss = 3     // 年月日 (24)小时 分钟 秒
};

@interface NSString (HXDate)

/**
 *  将给定的时间戳转换为字符串
 *
 *  @param timeStamp        时间戳
 *  @param dateFormaterType 包含种格式
 *  @param separator    年月日之间的分隔符
 *
 *  @return 返回一个字符串
 */
+ (nullable instancetype)stringFromDateWithTimeStamp:(NSTimeInterval)timeStamp
                                       dateFormatter:(DateFormatterType)dateFormaterType
                                        andSeparator:(nullable NSString *)separator;

+ (nullable instancetype)stringFromCurrentTimeStampWithDateFormatter:(DateFormatterType)dateFormaterType andSeparator:(nullable NSString *)separator;

/// 获取“几天后”的日期字符串
+ (NSString * _Nullable)dateStringAfterDays:(NSInteger)days;

/// 将时间戳字符串转换为指定时间格式的时间字符串
+ (NSString * _Nullable)convertToDateStringWithTimestampString:(NSString * _Nullable)timestampString dateFormatter:(DateFormatterType)dateFormaterType andSeparator:(nullable NSString *)separator;

/// 将一定格式的时间字符串（如：2018-08-01）转换为时间戳
+ (NSString * _Nullable)convertToTimestampStringFromFormatString:(NSString * _Nullable)date
                                                       separator:(NSString * _Nullable)separator;

/// 获取当前时间戳
+ (nullable instancetype)getCurrentTimeStamp;

/// 获取 NSDate 对应的时间字符串（中国大陆地区）
+ (NSString * _Nullable)getDateStringWithDate:(NSDate * _Nullable)date
                                   dateFormat:(NSString * _Nullable)dateFormat;

@end
