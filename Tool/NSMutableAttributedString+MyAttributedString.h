//
//  NSMutableAttributedString+MyAttributedString.h
//  BaiLi
//
//  Created by xabaili on 15/10/29.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (MyAttributedString)

+ (instancetype)attributedWithString:(NSString *)string
                           FromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                      withStartColor:(UIColor *)startColor
                         andEndColor:(UIColor *)endColor;

//- (instancetype)initWithAttributedString:(NSString *)string
//                               FromIndex:(NSInteger)startIndex
//                                 toIndex:(NSInteger)toIndex
//                          withStartColor:(UIColor *)startColor
//                             andEndColor:(UIColor *)endColor;


/**
 *  对段落进行设置
 *
 *  @param string      要处理的NSString
 *  @param fontSize    文字字号
 *  @param fontColor   文字颜色
 *  @param alignment   段落文字对齐方式
 *  @param lineSpacing 行间距
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fontSize:(CGFloat)fontSize
                          fontColor:(UIColor *)fontColor
                 paragraphAlignment:(NSTextAlignment)alignment
                        lineSpacing:(CGFloat)lineSpacing;


/**
 *  设置段落间距、首行缩进、字号、颜色等
 *
 *  @param string      要处理的NSString
 *  @param fontSize    文字字号
 *  @param fontColor   文字颜色
 *  @param alignment   段落文字对齐方式
 *  @param lineSpacing 行间距
 *  @param headIndent  首行缩进
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                            fontSize:(CGFloat)fontSize
                           fontColor:(UIColor *)fontColor
                  paragraphAlignment:(NSTextAlignment)alignment
                         lineSpacing:(CGFloat)lineSpacing
                 firstLineHeadIndent:(CGFloat)headIndent;

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
                         andEndColor:(UIColor *)endColor;



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
 *
 *  @return NSMutableAttributedString
 */
+ (instancetype)attributedWithString:(NSString *)string
                           fromIndex:(NSInteger)startIndex
                             toIndex:(NSInteger)toIndex
                            withSize:(CGFloat)size
                        andOtherSize:(CGFloat)otherSize
                           withColor:(UIColor *)color
                       andOtherColor:(UIColor *)otherColor
                          lineHeight:(CGFloat)lineHeight;


/// 添加下划线
+ (instancetype)attributedUnderLineWithString:(NSString *)string
                                        color:(UIColor *)color;

@end
