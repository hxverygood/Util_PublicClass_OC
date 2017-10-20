//
//  NSString+HXString.m
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import "NSString+HXString.h"

@implementation NSString (HXString)

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

/// 过滤字符串（空格、换行）
+ (NSString *)filterWithString:(NSString *)string {
    NSString *newStr = [string stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [newStr copy];
}


- (BOOL)textNeedMoreLineCountWithFont:(UIFont *)font
                                width:(CGFloat)width
                               height:(CGFloat)height {
    NSDictionary *attrsDictionary = @{@"NSFontAttributeName":[UIFont systemFontOfSize:14.0]};
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:self attributes:attrsDictionary];
   
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width - 14, CGFLOAT_MAX) options:options context:nil];
    
    if (ceil(boundingRect.size.height) > height) {
        return YES;
    }
    return NO;
}


/// 获取字符串中指定字符后的子字符串
- (NSString *)substringBehindCharacter:(NSString *)chracter {
    NSRange range = [self rangeOfString:chracter];
    NSString *subStr = [self substringFromIndex:range.location+1];
    return subStr;
}

/// 将字符串转换为数字，如果不是数字，则返回nil
- (NSNumber * _Nullable)convertToNumber {
    if (!self) {
        return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:self];
    return numberObj;
}

/// 将数字字符串转换为1位小数+元
- (NSString * _Nullable)convertToMoneyWithOneDecimal {
    if (!self) {
        return nil;
    }

    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numberObj = [formatter numberFromString:self];
    if (!numberObj) {
        return nil;
    }
    NSString *result = [NSString stringWithFormat:@"%.1f", numberObj.floatValue];
    return result;
}

/// 将数字字符串转换为千分位显示
- (NSString * _Nullable)convertWithThousandSeparator {
    if (!self) {
        return nil;
    }
    
    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (!num) {
        return nil;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[self doubleValue]]];
    return [resultStr copy];
}

/// 隐藏身份证部分数字
- (NSString * _Nullable)hidePartalIdCard {
    if (!self) {
        return  nil;
    }
    
    NSString *result;
    result = [self hideStringWithFrontPartialCount:3 endPartialCount:4];
    
    return result;
}

/// 隐藏手机号部分数字
- (NSString * _Nullable)hidePhoneNumber {
    if (!self) {
        return  nil;
    }
    
    NSString *result;
    result = [self hideStringWithFrontPartialCount:3 endPartialCount:4];
    
    return result;
}

/// 隐藏部分Email
- (NSString * _Nullable)hideEmail {
    if (!self) {
        return nil;
    }
    
    NSString *result;
    NSString *subString = [self substringBehindCharacter:@"@"];
    result = [self hideStringWithFrontPartialCount:0 endPartialCount:(subString.length+1)];
    return result;
}

/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration {
    if (!self) {
        return 0.0;
    }
    CGFloat minimum = MAX((CGFloat)self.length * 0.14 + 0.5, 0.8);
    return MIN(minimum, 5.0);
}



#pragma mark - Private Func

#pragma mark 隐藏部分字符串
- (NSString *)hideStringWithFrontPartialCount:(NSInteger)frontPartialCount
                              endPartialCount:(NSInteger)endPartialCount {
    if ((self == nil ||
         self == NULL ||
         [self isKindOfClass:[NSNull class]] ||
         [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        && (self.length < (frontPartialCount+endPartialCount))) {
        return nil;
    }
    
    // 截取前1/3部分字符串
    NSRange frontRange = NSMakeRange(0, frontPartialCount);
    NSString *frontStr = [self substringWithRange:frontRange];
    
    // 截取最后的部分
    NSRange endRange = NSMakeRange(self.length-endPartialCount, endPartialCount);
    NSString *endStr = [self substringWithRange:endRange];
    
    
    NSString *replacedStr = @"";
    // 改变中部为星号
    for (int i = 0; i< (self.length-(frontPartialCount+endPartialCount)); i++) {
        replacedStr = [replacedStr stringByAppendingString:@"*"];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@%@%@", frontStr, replacedStr, endStr];
    
    return result;
}

@end
