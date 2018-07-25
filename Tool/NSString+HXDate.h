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

/// 将时间戳字符串转换为指定时间格式的时间字符串
+ (nullable NSString *)convertToDateStringWithTimestampString:(nullable NSString *)timestampString dateFormatter:(DateFormatterType)dateFormaterType andSeparator:(nullable NSString *)separator;

/// 获取当前时间戳
+ (nullable instancetype)getCurrentTimeStamp;

@end
