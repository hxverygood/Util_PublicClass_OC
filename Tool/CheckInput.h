//
//  CheckInput.h
//  BaiLi
//
//  Created by xabaili on 15/10/30.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CheckInput : NSObject

/// 判断首字符是否是数字
+ (BOOL)checkFirstCharacterIsNotDigitWithString:(NSString *)string;

//判断字符串首字符是否是数字0
+ (BOOL)checkFirstCharacterIsDigitZeroWithString:(NSString *)string;

/// 用户名
+ (BOOL)validateUserName:(NSString *)name;
/// 密码
+ (BOOL)validatePassword:(NSString *)passWord;
/// 密码（指定最小和最大字符数量）
+ (BOOL)validatePassword:(NSString *)passWord
                     min:(NSInteger)min
                     max:(NSInteger)max;
/// 昵称
+ (BOOL)validateNickname:(NSString *)nickname;
/// 身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
/// 邮箱
+ (BOOL)validateEmail:(NSString *)email;
/// 邮编
+ (BOOL)validatePostcode:(NSString *)postcode;
/// 手机号
+ (BOOL)validateMobile:(NSString *)mobile;
/// 固定电话区号
+ (BOOL)validateTelAreaNumber:(NSString *)telAreaNumber;
/// 固定电话
+ (BOOL)validateTelNumber:(NSString *)telNumber;
//完整固定电话号码，中间用 - 分隔
//+ (BOOL) validateTotalTelNumber:(NSString *)telNumber;
/// 判断是否是中文
+ (BOOL)validateHan:(NSString *)string;
//是否包含中文
+ (BOOL)includeHan:(NSString *)string;

/// 中文、英文、数字
+ (BOOL)validateHanAndEnglishAndNumber:(NSString *)string;

/// 正整数和0（是否是数字）
+ (BOOL)validatePositiveNumuber:(NSString *)string;

/// 正整数和0（需要输入整数有几位数字）
+ (BOOL)validatePositiveNumuber:(NSString *)string withDigitQuantity:(NSInteger)quantity;
/// 验证码及位数
+ (BOOL)validateVerifyCode:(NSString *)string withDigitQuantity:(NSInteger)quantity;
/// 验证是否是数字
+ (BOOL)validateNumberWithString:(NSString *)number;
/// 验证是否是数字，及数字位数
+ (BOOL)validateNumberWithString:(NSString*)number
                andDigitQuantity:(NSInteger)quantity;
/// 正整数+小数
+ (BOOL)validateWholeNumberAndDecimal:(NSString *)string;
/// 小数
+ (BOOL)validateDecimal:(NSString *)string;
/// 数字+逗号
+ (BOOL)validateNumberAndComma:(NSString *)string;

/// 只验证字符数量
+ (BOOL)validateCharacterQuantity:(NSString *)string;

/// 检查所有textField或Label等UIView内容是否为空
+ (BOOL)checkAllTextFieldInputContentFromView:(UIView *)view;

/// 统计  字数（除了空格等）
+ (int)countWord:(NSString *)s;

@end
