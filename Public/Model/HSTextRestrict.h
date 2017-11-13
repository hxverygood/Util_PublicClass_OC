//
//  HSTextRestrict.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HSRestrictType)
{
    HSRestrictTypeNone = 0,                     /// 不限制输入的内容
    HSRestrictTypeOnlyNumber = 1,               ///< 只允许输入数字
    HSRestrictTypeOnlyDecimal,                  ///<  只允许输入实数，包括.
    HSRestrictTypeOnlyCharacter,                ///<  只允许输入非中文字符
    HSRestrictTypeOnlyChinese,                  /// 只允许输入中文
    HSRestrictTypeCharacterCount,               ///< 判断字符数量，需配合maxLength属性使用
    HSRestrictTypeCharacterAndNumber,           /// 判断字母和数字
    HSRestrictTypeChineseAndCharAndNumber,      /// 判断中文、字母和数字
    HSRestrictTypeIdCard,                       ///  判断身份证
    HSRestrictTypeNumberOrCharacter,            /// 只允许输入数字和字母
    HSRestrictTypeCustom,                       ///< 自定义规则
};



#pragma mark -

@interface HSTextRestrict : NSObject

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, assign, readonly) HSRestrictType restrictType;
@property (nonatomic, strong) NSString *predicateStr;

// 工厂
+ (instancetype)textRestrictWithRestrictType:(HSRestrictType)restrictType
                               maxTextLength:(NSInteger)maxTextLength;
// 子类实现来限制文本内容
- (void)textDidChanged: (UITextField *)textField;

@end



@interface HSNUmberTextOrCharacter : HSTextRestrict
@end;

@interface HSNumberTextRestrict : HSTextRestrict
@end

@interface HSDecimalTextRestrict : HSTextRestrict
@end

@interface HSCharacterTextRestrict : HSTextRestrict
@end

@interface HSChineseTextRestrict : HSTextRestrict
@end

@interface HSCharacterCountTextRestrict : HSTextRestrict
@end

@interface HSCharacterAndNumberTextRestrict : HSTextRestrict
@end

@interface HSChineseAndCharAndNumberTextRestrict : HSTextRestrict
@end

@interface HSIdCardTextRestrict : HSTextRestrict
@end

@interface HSCustomTextRestrict : HSTextRestrict
@end

