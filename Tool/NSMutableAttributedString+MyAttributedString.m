//
//  NSMutableAttributedString+MyAttributedString.m
//  BaiLi
//
//  Created by xabaili on 15/10/29.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import "NSMutableAttributedString+MyAttributedString.h"


@implementation NSMutableAttributedString (MyAttributedString)

/**
 *  根据其实和结束位置可改变字符串前后颜色
 *
 *  @param string     输入的字符串
 *  @param startIndex 第一段字符其实位置
 *  @param toIndex    第一段字符结束位置
 *  @param startColor 第一段字符颜色
 *  @param endColor   第二段字符颜色
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           FromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                      withStartColor:(UIColor *)startColor
                         andEndColor:(UIColor *)endColor {
    return [[NSMutableAttributedString alloc] initWithAttributedString:string FromIndex:startIndex toIndex:toIndex withStartColor:startColor andEndColor:endColor];
}

- (instancetype)initWithAttributedString:(NSString *)string
                               FromIndex:(NSInteger)startIndex
                                 toIndex:(NSInteger)toIndex
                          withStartColor:(UIColor *)startColor
                             andEndColor:(UIColor *)endColor {
    NSInteger length = string.length;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:string];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(startIndex, toIndex + 1)];
    [mutStr addAttribute:NSForegroundColorAttributeName value:startColor range:NSMakeRange(startIndex, toIndex + 1)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(toIndex + 1, length - (toIndex + 1))];
    [mutStr addAttribute:NSForegroundColorAttributeName value:endColor range:NSMakeRange(toIndex + 1, length - (toIndex + 1))];
    
    return mutStr;
}


/**
 *  根据起始和结束位置可改变字符串前后颜色及字符大小
 *
 *  @param string     输入的字符串
 *  @param startIndex 第一段字符起始位置
 *  @param toIndex    第一段字符结束位置
 *  @param startSize  第一段字符尺寸
 *  @param endSize    第二段字符尺寸
 *  @param startColor 第一段字符颜色
 *  @param endColor   第二段字符颜色
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                                 FromIndex:(NSInteger)startIndex
                                   toIndex:(NSInteger)toIndex
                             withStartSize:(CGFloat)startSize
                                andEndSize:(CGFloat)endSize
                            withStartColor:(UIColor *)startColor
                               andEndColor:(UIColor *)endColor {
    return [[NSMutableAttributedString alloc] initWithString:string FromIndex:startIndex toIndex:toIndex withStartSize:startSize andEndSize:endSize withStartColor:startColor andEndColor:endColor];
}

- (instancetype)initWithString:(NSString *)string
                     FromIndex:(NSInteger)startIndex
                       toIndex:(NSInteger)toIndex
                 withStartSize:(CGFloat)startSize
                    andEndSize:(CGFloat)endSize
                withStartColor:(UIColor *)startColor
                   andEndColor:(UIColor *)endColor {
    NSInteger length = string.length;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:string];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:startSize] range:NSMakeRange(startIndex, toIndex + 1)];
    [mutStr addAttribute:NSForegroundColorAttributeName value:startColor range:NSMakeRange(startIndex, toIndex + 1)];
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:endSize] range:NSMakeRange(toIndex + 1, length - (toIndex + 1))];
    [mutStr addAttribute:NSForegroundColorAttributeName value:endColor range:NSMakeRange(toIndex + 1, length - (toIndex + 1))];
    
    return mutStr;
}



/**
 *  根据需要改变内容的起始和结束位置生成带属性的字符串
 *  此方法更具通用性，推荐使用
 *
 *  @param string     原字符串
 *  @param startIndex 起始位置
 *  @param toIndex    结束位置
 *  @param size       需要改变的字符大小
 *  @param otherSize  不需要改变的字符大小
 *  @param color      需要改变的字符颜色
 *  @param otherColor 不需要改变的字符颜色
 *  @param lineHeight 行高
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                            withSize:(CGFloat)size
                        andOtherSize:(CGFloat)otherSize
                           withColor:(UIColor *)color
                       andOtherColor:(UIColor *)otherColor
                          lineHeight:(CGFloat)lineHeight {
    return [[NSMutableAttributedString alloc] initWithString:string fromIndex:startIndex toIndex:toIndex withSize:size andOtherSize:otherSize withColor:color andOtherColor:otherColor lineHeight:lineHeight];
}

- (instancetype)initWithString:(NSString *)string
                     fromIndex:(NSInteger)startIndex
                       toIndex:(NSInteger)toIndex
                      withSize:(CGFloat)size
                  andOtherSize:(CGFloat)otherSize
                     withColor:(UIColor *)color
                 andOtherColor:(UIColor *)otherColor
                    lineHeight:(CGFloat)lineHeight
{
    NSInteger length = string.length;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range;
    if (startIndex != 0) {
        range = NSMakeRange(0, startIndex);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherSize] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }
    
    range = NSMakeRange(startIndex, toIndex - startIndex + 1);
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:range];
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    if (toIndex != (length - 1)) {
        range = NSMakeRange(toIndex + 1, length - 1 - toIndex);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherSize] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineHeight > 0 ? lineHeight : paragraphStyle.minimumLineHeight;
    NSRange paragraphRange = NSMakeRange(0, string.length);
    [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:paragraphRange];
    
    return mutStr;
}


+ (instancetype)attributedWithString:(NSString *)string
                            fontSize:(CGFloat)fontSize
                           fontColor:(UIColor *)fontColor
                  paragraphAlignment:(NSTextAlignment)alignment
                         lineSpacing:(CGFloat)lineSpacing {
    return [[NSMutableAttributedString alloc] initWithString:string fontSize:fontSize fontColor:fontColor paragraphAlignment:alignment lineSpacing:lineSpacing];
}

- (instancetype)initWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize
                     fontColor:(UIColor *)fontColor
            paragraphAlignment:(NSTextAlignment)alignment
                   lineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = alignment;
    paragraphStyles.firstLineHeadIndent = 0.001f;
    paragraphStyles.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles, NSFontAttributeName:font, NSForegroundColorAttributeName:fontColor};
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}



+ (instancetype)attributedWithString:(NSString *)string
                            fontSize:(CGFloat)fontSize
                           fontColor:(UIColor *)fontColor
                  paragraphAlignment:(NSTextAlignment)alignment
                         lineSpacing:(CGFloat)lineSpacing
                 firstLineHeadIndent:(CGFloat)headIndent {
    return [[NSMutableAttributedString alloc] initWithString:string fontSize:fontSize fontColor:fontColor paragraphAlignment:alignment lineSpacing:lineSpacing];
}

- (instancetype)initWithString:(NSString *)string
                      fontSize:(CGFloat)fontSize
                     fontColor:(UIColor *)fontColor
            paragraphAlignment:(NSTextAlignment)alignment
                   lineSpacing:(CGFloat)lineSpacing
           firstLineHeadIndent:(CGFloat)headIndent {
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = alignment;
    paragraphStyles.firstLineHeadIndent = headIndent;
    paragraphStyles.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyles, NSFontAttributeName:font, NSForegroundColorAttributeName:fontColor};
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    return attributedString;
}




//+ (instancetype)attributedDeleteLineWithString:(NSString *)string {
//    return [[NSMutableAttributedString alloc] initWithDeleteLineWithString:string];
//}
//
//- (instancetype)initWithDeleteLineWithString:(NSString *)string {
//    NSDictionary *attributes = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)};
//    NSMutableAttributedString *attrStr =
//    [[NSMutableAttributedString alloc]initWithString:string
//                                   attributes:attributes];
//    return attrStr;
//}


+ (instancetype)attributedDeleteLineWithString:(NSString *)string
                                         color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] initWithDeleteLineWithString:string color:color];
}

- (instancetype)initWithDeleteLineWithString:(NSString *)string
                                       color:(UIColor *)color {
    NSDictionary *attributes = @{NSForegroundColorAttributeName : color,
                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)};
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc]initWithString:string
                                          attributes:attributes];
    return attrStr;
}




/// 添加下划线
+ (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] attributedUnderLineWithString:string color:color];
}

- (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color {
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color,
                                  NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                  NSUnderlineColorAttributeName : color
                                };
    NSMutableAttributedString *attrStr =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:attributes];
    
    return attrStr;
}

@end
