//
//  NSString+HXString.h
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (HXString)

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString * _Nullable)string;

/// 过滤字符串（空格、换行）
+ (NSString * _Nullable)filterWithString:(NSString * _Nullable)string;

/// 计算text是否需要多行显示
- (BOOL)textNeedMoreLineCountWithFont:(UIFont * _Nullable)font
                                width:(CGFloat)width
                               height:(CGFloat)height;



/**
 获取字符串中指定字符后的子字符串

 @param chracter 指定字符
 @return 返回截取的子字符串
 */
- (NSString * _Nullable)substringBehindCharacter:(NSString * _Nullable)chracter;

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber;

/// 将数字字符串转换为1位小数+元
- (NSString * _Nullable)convertToMoneyWithOneDecimal;

/// 将数字字符串转换为千分位显示
- (NSString * _Nullable)convertWithThousandSeparator;
/// 将数字字符串转换为千分位显示，保留2位小数
- (NSString * _Nullable)convertWithThousandSeparatorAndTwoDigits;

/// 隐藏身份证部分数字
- (NSString * _Nullable)hidePartalIdCard;
/// 隐藏手机号部分数字
- (NSString * _Nullable)hidePhoneNumber;
/// 隐藏部分Email
- (NSString * _Nullable)hideEmail;
/// 截取银行卡号后4位
- (NSString * _Nullable)bankCardNumberLast4Digits;

/// 隐藏部分字符串
- (NSString * _Nullable)hideStringWithFrontPartialCount:(NSInteger)frontPartialCount
                                        endPartialCount:(NSInteger)endPartialCount;

/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration;

/// 判断字符串是否是url
- (BOOL)isUrl;

//判断用户手机型号
+ (NSString * _Nullable)deviceVersion;

/// NSString转NSDictionary
- (NSDictionary * _Nullable)dictionaryWithJsonString;

/**
 金额转换为千分位金额
 
 @param digitString  未转换的金额
 @return 转换后的金额
 */
+(NSString * _Nullable)separatedDigitStringWithStr:(NSString * _Nullable)digitString;

/// 保留金额小数点后2位
- (NSString * _Nullable)reserveMoneyWithTwoDigit;

/// 保留小数点后指定的位数
- (NSString * _Nullable)reserveDecimalPartWithDigitCount:(NSInteger)count
                                            roundingMode:(NSRoundingMode)roundMode;

/// 将时间戳转换为刚刚、x分钟前、今天、昨天等字段
- (NSString * _Nullable)distanceTimeBeforeNowWithShowDetail:(BOOL)showDetail;

/**
 整数部分有多少位数字

 @return 正常情况:>=0；如果不是数字则返回-1
 */
- (NSInteger)integerLength;

/// 获取沙盒Documents路径
+ (NSString * _Nullable)sandboxDocumentDirectoryPath;

@end
