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
+ (BOOL)isBlankString:(NSString *_Nullable)string;

/// 过滤字符串（空格、换行）
+ (NSString *_Nullable)filterWithString:(NSString *_Nullable)string;

/// 计算text是否需要多行显示
- (BOOL)textNeedMoreLineCountWithFont:(UIFont *_Nullable)font
                                width:(CGFloat)width
                               height:(CGFloat)height;



/**
 获取字符串中指定字符后的子字符串

 @param chracter 指定字符
 @return 返回截取的子字符串
 */
- (NSString *_Nullable)substringBehindCharacter:(NSString *_Nullable)chracter;

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber;

/// 将数字字符串转换为1位小数+元
- (NSString * _Nullable)convertToMoneyWithOneDecimal;

/// 隐藏身份证部分数字
- (NSString * _Nullable)hidePartalIdCard
;
/// 隐藏手机号部分数字
- (NSString * _Nullable)hidePhoneNumber;
/// 隐藏部分Email
- (NSString * _Nullable)hideEmail;

/// 隐藏部分字符串
- (NSString *_Nullable)hideStringWithFrontPartialCount:(NSInteger)frontPartialCount
                              endPartialCount:(NSInteger)endPartialCount;

/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration;

@end
