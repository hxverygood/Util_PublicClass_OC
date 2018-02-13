//
//  NSString+HXString.m
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import "NSString+HXString.h"
#import <sys/utsname.h>
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
    [numberFormatter setPositiveFormat:@",###;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[self integerValue]]];
    return [resultStr copy];
}

/// 将数字字符串转换为千分位显示，保留2位小数
- (NSString * _Nullable)convertWithThousandSeparatorAndTwoDigits {
    if (!self) {
        return nil;
    }
    
    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (!num) {
        return nil;
    }
    
    // 先保留小数点后2位
    NSString *convertStr = [self reserveDecimalPartWithDigitCount:2 roundingMode:NSRoundUp];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *resultStr = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[convertStr doubleValue]]];
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

/// 截取银行卡号后4位
- (NSString * _Nullable)bankCardNumberLast4Digits {
    if (!self) {
        return nil;
    }
    
    if ([NSString isBlankString:self]) {
        return nil;
    }
    
    if (self.length < 4) {
        return self;
    }
    
    NSString *result = [self substringFromIndex:self.length - 4];
    return result;
}


/// 使用SVProgressHUD时，根据文字多少计算HUD要显示的时间。计算方法来自SVProgressHUD
- (CGFloat)hudShowDuration {
    if (!self) {
        return 0.0;
    }
    CGFloat minimum = MAX((CGFloat)self.length * 0.15 + 0.5, 0.8);
    return MIN(minimum, 5.0);
}

//- (BOOL)isUrl {
//    if(self == nil) {
//        return NO;
//    }
//
//    NSString *url;
//    if (self.length > 4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
//        url = [NSString stringWithFormat:@"http://%@",self];
//    }else{
//        url = self;
//    }
//
//    NSString *urlRegex = @"(https|http|ftp|rtsp|igmp|file|rtspt|rtspu)://((((25[0-5]|2[0-4]\\d|1?\\d?\\d)\\.){3}(25[0-5]|2[0-4]\\d|1?\\d?\\d))|([0-9a-z_!~*'()-]*\\.?))([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.([a-z]{2,6})(:[0-9]{1,4})?([a-zA-Z/?_=]*)\\.\\w{1,5}";
//    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
//    return [urlTest evaluateWithObject:url];
//}

- (BOOL)isUrl {
    if (self == nil) {
        return NO;
    }
    
    NSURL *candidateURL = [NSURL URLWithString:self];
    return candidateURL && candidateURL.scheme && candidateURL.host;
}
//判断用户手机型号
+ (NSString * _Nullable)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod6,1"]) return @"iPod Touch 6G";
    if ([deviceString isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    return deviceString;
}

- (NSDictionary *_Nullable)dictionaryWithJsonString {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/// 保留金额小数点后2位
- (NSString * _Nullable)reserveMoneyWithTwoDigit {
    return [self reserveDecimalPartWithDigitCount:2 roundingMode:NSRoundUp];
}

/// 保留小数点后指定的位数
- (NSString * _Nullable)reserveDecimalPartWithDigitCount:(NSInteger)count
                                            roundingMode:(NSRoundingMode)roundMode {
    if (self == nil) {
        return nil;
    }
    
    // 判断是否是数字
    NSNumber *num = [self convertToNumber];
    if (!num) {
        return nil;
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:roundMode
                                       scale:count
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    // 通过字符串计算金额
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *resultDecimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
    NSString *resultDecimalStr = [NSString stringWithFormat:@"%@", resultDecimalNumber];
    
    // 显示2位小数
    NSString *format = [NSString stringWithFormat:@"%%.%ldf", (long)count];
    float number = [resultDecimalStr floatValue];
    NSString *resultStr = [NSString stringWithFormat:format, number];
    
    return resultStr;
}

/**
 金额转换为千分位金额
 
 @param digitString  未转换的金额
 @return 转换后的金额
 */
+(NSString * _Nullable)separatedDigitStringWithStr:(NSString * _Nullable)digitString
{
    if(!digitString || [digitString floatValue] == 0)
    {
        return @"0.00";
    }
    if (digitString.floatValue < 1000)
    {
        return [NSString stringWithFormat:@"%.2f",digitString.floatValue];
    };
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[digitString doubleValue]]];
}


/// 获取沙盒Documents路径
+ (NSString * _Nullable)sandboxDocumentDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return docDir;
}

/// 将时间戳转换为刚刚、x分钟前、今天、昨天等字段
- (NSString * _Nullable)distanceTimeBeforeNowWithShowDetail:(BOOL)showDetail {
    NSString *beforeTimeStr = [self copy];
    
    // 判断是否是数字
    NSNumber *beforeTimeNum = [beforeTimeStr convertToNumber];
    if (beforeTimeNum == nil) {
        return nil;
    }
    
    // 判断整数位数，如果大于9则进行截取
    NSInteger integerLength = [beforeTimeStr integerLength];
    if (integerLength > 10) {
        beforeTimeStr = [beforeTimeStr substringToIndex:10];
    }
    else if (integerLength < 10) {
        return nil;
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - [beforeTimeStr doubleValue];
    // 要显示的时间：刚刚、xx分钟前、
    NSString *distanceStr;
    
    
    NSDate *beforeDate = [NSDate dateWithTimeIntervalSince1970:[beforeTimeStr doubleValue]];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *beforeTimeStr2 = [dateFormatter stringFromDate:beforeDate];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *nowDayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *lastDayStr = [dateFormatter stringFromDate:beforeDate];
    
    if (distanceTime < 60) {  // 小于一分钟
        distanceStr = @"刚刚";
    }
    else if (distanceTime < 60*60) {  // 时间小于一个小时
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    else if(distanceTime < 24*60*60 && ([nowDayStr integerValue] == [lastDayStr integerValue])){  // 时间小于一天，xx时xx分
        distanceStr = [NSString stringWithFormat:@"%@", beforeTimeStr2];
    }
    else if(distanceTime < 24*60*60*2 && [nowDayStr integerValue] != [lastDayStr integerValue]){
        distanceStr = (showDetail == YES ? [NSString stringWithFormat:@"昨天 %@", beforeTimeStr2] : @"昨天");
    }
    else {
        [dateFormatter setDateFormat:(showDetail == YES ? @"YYYY/MM/dd HH:mm" : @"YYYY/MM/dd")];
        distanceStr = [dateFormatter stringFromDate:beforeDate];
    }
    
    return distanceStr;
}

/**
 整数部分有多少位数字
 
 @return 正常情况:>=0；如果不是数字则返回-1
 */
- (NSInteger)integerLength {
    NSNumber *num = [self convertToNumber];
    if (num == nil) {
        return -1;
    }
    
    NSInteger x = [self doubleValue];
    NSInteger sum=0,j=1;
    
    while( x >= 1 ) {
        x=x/10;
        sum++;
        j=j*10;
    }
    
    return sum;
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
