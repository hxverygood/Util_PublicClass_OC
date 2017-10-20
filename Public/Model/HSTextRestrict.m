//
//  HSTextRestrict.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSTextRestrict.h"

typedef BOOL(^HSStringFilter)(NSString * aString);

static inline NSString * kFilterString(NSString * handleString, HSStringFilter subStringFilter)
{
    NSMutableString * modifyString = handleString.mutableCopy;
    for (NSInteger idx = 0; idx < modifyString.length;) {
        NSString * subString = [modifyString substringWithRange: NSMakeRange(idx, 1)];
        if (subStringFilter(subString)) {
            idx++;
        } else {
            [modifyString deleteCharactersInRange: NSMakeRange(idx, 1)];
        }
    }
    return modifyString;
}

static inline BOOL kMatchStringFormat(NSString * aString, NSString * matchFormat)
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", matchFormat];
    return [predicate evaluateWithObject: aString];
}



#pragma mark -

@interface HSTextRestrict ()

@property (nonatomic, readwrite) HSRestrictType restrictType;

@end

@implementation HSTextRestrict

+ (instancetype)textRestrictWithRestrictType:(HSRestrictType)restrictType
                               maxTextLength:(NSInteger)maxTextLength
{
    HSTextRestrict * textRestrict;
    switch (restrictType) {
        case HSRestrictTypeOnlyNumber:
            textRestrict = [[HSNumberTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeOnlyDecimal:
            textRestrict = [[HSDecimalTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeOnlyCharacter:
            textRestrict = [[HSCharacterTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeCharacterCount:
            textRestrict = [[HSCharacterCountTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeCharacterAndNumber:
            textRestrict = [[HSCharacterAndNumberTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeChineseAndCharAndNumber:
            textRestrict = [[HSChineseAndCharAndNumberTextRestrict alloc] init];
            break;
        
        case HSRestrictTypeIdCard:
            textRestrict = [[HSIdCardTextRestrict alloc] init];
            break;
            
        case HSRestrictTypeCustom:
            textRestrict = [[HSCustomTextRestrict alloc] init];
            break;
            
        default:
            
            break;
    }
    textRestrict.maxLength = (maxTextLength == 0) ? NSUIntegerMax : maxTextLength;
    textRestrict.restrictType = restrictType;
    return textRestrict;
}

- (void)textDidChanged: (UITextField *)textField {

}

@end



#pragma mark - 子类实现

// 数字
@implementation HSNumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^\\d$");
    });
}

@end

// 小数
@implementation HSDecimalTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[0-9.]$");
    });
}

@end
// 只允许非中文输入
@implementation HSCharacterTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[^[\\u4e00-\\u9fa5]]$");
    });
}

@end

// 只允许中文输入
@implementation HSChineseTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"[^x00-xff]{1,}");
    });
}

@end


/// 判断字符数量
@implementation HSCharacterCountTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
}

@end


/// 判断字母和数字
@implementation HSCharacterAndNumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[A-Za-z0-9]+$");
    });
}

@end


/// 判断中文、字母和数字
@implementation HSChineseAndCharAndNumberTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString,@"^[a-zA-Z0-9\\u4e00-\\u9fa5]+");
    });
}

@end


///  判断身份证
@implementation HSIdCardTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
        return kMatchStringFormat(aString, @"^[Xx0-9]+$");
    });
}

@end



// 自定义正则
@implementation HSCustomTextRestrict

- (void)textDidChanged:(UITextField *)textField
{
    if (textField.text.length > self.maxLength) {
        textField.text = [textField.text substringToIndex:self.maxLength];
    }
    
    if (![self isBlankString:self.predicateStr]) {
        textField.text = kFilterString(textField.text, ^BOOL(NSString *aString) {
            return kMatchStringFormat(aString, self.predicateStr);
        });
    }
}



#pragma mark - Private Func

- (BOOL)isBlankString:(NSString *)string {
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


