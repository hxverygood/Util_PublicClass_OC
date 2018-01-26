//
//  CheckInput.m
//  BaiLi
//
//  Created by xabaili on 15/10/30.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import "CheckInput.h"

@implementation CheckInput

- (BOOL)checkWithString:(NSString *)string minCount:(NSInteger)minCount andMaxCount:(NSInteger)maxCount {
    NSString *str = string;
    BOOL lengthIsRight = (str.length >= minCount && str.length <= maxCount)  ? YES : NO;
    
    NSString *firstCharacter = [str substringWithRange:NSMakeRange(0, 1)];
    const char *ch = [firstCharacter cStringUsingEncoding:NSASCIIStringEncoding];
    BOOL firstCharacterIsNotDigit = (ch[0] >= 48 && ch[0] <= 57) ? NO : YES;
    
    return (lengthIsRight && firstCharacterIsNotDigit);
}

//判断首字符是否是数字
+ (BOOL)checkFirstCharacterIsNotDigitWithString:(NSString *)string {
    NSString *firstCharacter = nil;
    if (string.length > 0) {
        firstCharacter = [string substringWithRange:NSMakeRange(0, 1)];
        const char *ch = [firstCharacter cStringUsingEncoding:NSUTF8StringEncoding];
        BOOL firstCharacterIsNotDigit = (ch[0] >= 48 && ch[0] <= 57) ? NO : YES;
        return firstCharacterIsNotDigit;
    }
    return NO;
}

//判断字符串首字符是否是数字0
+ (BOOL)checkFirstCharacterIsDigitZeroWithString:(NSString *)string {
    NSString *firstCharacter = nil;
    if (string.length > 0) {
        firstCharacter = [string substringWithRange:NSMakeRange(0, 1)];
        if ([firstCharacter integerValue] == 0) {
            return YES;
        }
    }
    return NO;
}

//用户名
+ (BOOL)validateUserName:(NSString *)name {
    BOOL firstCharacter = [CheckInput checkFirstCharacterIsNotDigitWithString:name];
    
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,18}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    
    return (firstCharacter && B);
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

/// 密码（指定最小和最大字符数量）
+ (BOOL)validatePassword:(NSString *)passWord
                     min:(NSInteger)min
                     max:(NSInteger)max {
    
    NSAssert(min > 0 || max > 0, @"最小值或最大值必须大于1");
    NSAssert(min <= max, @"最小值必须比最大值小");

    NSString *passWordRegex = [NSString stringWithFormat:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{%ld,%ld}$", min, max];
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+ (BOOL)validateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard {
    NSInteger length = 0;
    length = identityCard.length;
    
    if (length != 15 && length !=18) {
        return NO;
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [identityCard substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [identityCard substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year%4==0 || (year%100==0 && year%4==0)) {
                regularExpression = [[NSRegularExpression alloc]
                                     initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                     options:NSRegularExpressionCaseInsensitive
                                     error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]
                                     initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     options:NSRegularExpressionCaseInsensitive
                                     error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:identityCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, identityCard.length)];
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
            
        case 18:
            year = [identityCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]
                                     initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     options:NSRegularExpressionCaseInsensitive
                                     error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]
                                     initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                     options:NSRegularExpressionCaseInsensitive
                                     error:nil];// 测试出生日期的合法性
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:identityCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, identityCard.length)];
            
            
            if(numberofMatch > 0) {
                //计算校验码
                int sum = 0;
                for (int i = 0; i < 17; i++) {
                    sum += ((1<<(18-i-1))%11)*([[identityCard substringWithRange:NSMakeRange(i, 1)] intValue]);
                }
                int n = 0;
                n = (12 - (sum % 11)) % 11;
                
                //判断校验码是否跟最后一位数字或字母相符
                NSString *lastCharacter = [identityCard substringWithRange:NSMakeRange(17, 1)];
                BOOL isCharacter = ([lastCharacter isEqualToString:@"X"] || [lastCharacter isEqualToString:@"x"]);
                if (!isCharacter) {
                    int lastInt = [[identityCard substringWithRange:NSMakeRange(17, 1)] intValue];
                    if (n < 10 && (n == lastInt)) {
                        return true;
                    } else {
                        return false;
                    }
                } else if (n == 10) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
            
        default:
            return false;
    }
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/// 邮编
+ (BOOL)validatePostcode:(NSString *)postcode {
//    NSString *postcodeRegex = @"^[1-9]\\d{5}$";
    NSString *postcodeRegex = @"^\\d{6}$";
    NSPredicate *postcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postcodeRegex];
    return [postcodeTest evaluateWithObject:postcode];
}

//手机号
+ (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(170))\\d{8}$";
    
    
    // 只验证字符数量
    NSString *phoneRegex = @"[0-9]{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//固定电话区号
+ (BOOL)validateTelAreaNumber:(NSString *)telAreaNumber {
    NSString *areaNumberRegex = @"[0]([0-9]{2,3})$";
    NSPredicate *areaNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",areaNumberRegex];
    return [areaNumberTest evaluateWithObject:telAreaNumber];
}

//固定电话
+ (BOOL)validateTelNumber:(NSString *)telNumber {
    NSString *telNumberRegex = @"([^0a-zA-Z][0-9]{7,})";
    NSPredicate *telNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telNumberRegex];
    return [telNumberTest evaluateWithObject:telNumber];
}

//完整固定电话号码
//+ (BOOL) validateTotalTelNumber:(NSString *)telNumber {
//    NSString *totalTelNumberRegex = @"([0-9]|\\-){8-12}";
//    NSPredicate *totalTelNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",totalTelNumberRegex];
//    return [totalTelNumberTest evaluateWithObject:telNumber];
//}

//判断是否是中文
+ (BOOL)validateHan:(NSString *)string {
//    NSString *hanRegex = @"[\u4e00-\u9fa5]";
    
    NSString *hanRegex = @"[^x00-xff]{1,}";
    NSPredicate *HanTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",hanRegex];
    return [HanTest evaluateWithObject:string];
}

//是否包含中文
+ (BOOL)includeHan:(NSString *)string {
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if(a>0x4e00 && a<0x9fff){
            return YES;
        }
    }
    return NO;
}

//中文、英文、数字
+ (BOOL)validateHanAndEnglishAndNumber:(NSString *)string {
    NSString *hanRegex = @"[a-zA-Z0-9\\u4e00-\\u9fa5]+";
//    NSString *hanRegex = @"[^x00-xff]|[0-9a-zA-Z]{2,}";
    NSPredicate *HanTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",hanRegex];
    return [HanTest evaluateWithObject:string];
}

/// 正整数和0（是否是数字）
+ (BOOL)validatePositiveNumuber:(NSString *)string {
    NSString *regex = @"^([1-9]\\d*)|0$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isDigit = [predicate evaluateWithObject:string];
    return isDigit;
}

//正整数和0（需要输入整数有几位数字）
+ (BOOL)validatePositiveNumuber:(NSString *)string withDigitQuantity:(NSInteger)quantity {
    NSString *regex = @"^([1-9]\\d*)|0$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isDigit = [predicate evaluateWithObject:string];
    if (isDigit) {
        // 例如：对于4位验证码，当输入1234时result=10，当输入123时result=1，当输入12时result=0.1
        float result = (float)string.integerValue / pow(10, quantity-1);
        if (result > 1 && result < 10) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

//验证码及位数
+ (BOOL)validateVerifyCode:(NSString *)string
         withDigitQuantity:(NSInteger)quantity {
    NSString *regex = @"[0-9]\\d*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isDigit = [predicate evaluateWithObject:string];
    if (isDigit) {
        NSInteger count = 0;
        // 如果首字符是否为0
        if ([self checkFirstCharacterIsDigitZeroWithString:string]) {
            count = quantity - 2;
        } else {
            count = quantity - 1;
        }
        
        // 例如：对于4位验证码，当输入1234时result=10，当输入123时result=1，当输入12时result=0.1
        float result = (float)string.integerValue / pow(10, count);
        if (result > 1 && result < 10) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

//验证是否是数字
+ (BOOL)validateNumberWithString:(NSString *)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        
        i++;
    }
    return res;
}


//验证是否是数字，及数字位数
+ (BOOL)validateNumberWithString:(NSString*)number
                andDigitQuantity:(NSInteger)quantity {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    if (number.length <= quantity) {
        return res;
    } else {
        return NO;
    }
}

//正整数+小数
+ (BOOL)validateWholeNumberAndDecimal:(NSString *)string {
    NSString *regex = @"^[1-9]d*.d*|0.d*[1-9]d*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:string];
}

//小数
+ (BOOL)validateDecimal:(NSString *)string {
    NSString *decimalRegex = @"[0]+\\.?[0-9]*";
    NSPredicate *decimalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",decimalRegex];
    return [decimalTest evaluateWithObject:string];
}

//数字+逗号
+ (BOOL)validateNumberAndComma:(NSString *)string {
    NSString *numberAndCommaRegex = @"(\\d+,)*(\\d+)$";
    NSPredicate *numberAndCommaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberAndCommaRegex];
    return [numberAndCommaTest evaluateWithObject:string];
}


//只验证字符数量
+ (BOOL)validateCharacterQuantity:(NSString *)string {
    NSString *quantityRegex = @"([0-9a-zA-Z]|[^x00-xff]){2,}";
    NSPredicate *quantityTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",quantityRegex];
    return [quantityTest evaluateWithObject:string];
}



//判断textField内容是否为空
+ (BOOL)checkAllTextFieldInputContentFromView:(UIView *)view {
    NSArray *subViews = view.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            if (textField.text.length == 0) {
                return NO;
            }
        }
    };
    return YES;
}

/// 判断字数（除了空格等）
+ (int)countWord:(NSString *)s {
    int i, l = 0, a = 0;
    NSInteger n=s.length;
    unichar c;
    
    for (i = 0; i < n; i++) {
        c = [s characterAtIndex:i];
        if (!isblank(c) && c != 13 && c != 10) {
            if (isascii(c)  && c < 65 && c > 122 ) {
                a++;
            } else {
                l++;
            }
        }
    }
    
    if (a == 0 && l == 0) {
        return 0;
    }
    
    return l+(int)ceilf((float)(a)/2.0);
}

@end
