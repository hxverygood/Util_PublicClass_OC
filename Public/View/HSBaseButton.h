//
//  HSBaseButton.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseButton : UIButton

//#pragma mark - Properties

//@property (nonatomic, strong) NSArray * _Nullable gradientColors;



#pragma mark - Initializer

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor;

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius;

+ (instancetype _Nullable)buttonWithFrame:(CGRect)frame
                                    title:(NSString * _Nullable)title
                               titleColor:(UIColor *_Nullable)titleColor
                                titleSize:(CGFloat)titleSize
                          backgroundColor:(UIColor *_Nullable)backgroundColor
                             cornerRadius:(CGFloat)cornerRadius;

/// 圆角按钮
+ (instancetype _Nullable)roundCornerWithFrame:(CGRect)frame
                                         title:(NSString * _Nullable)title
                                    titleColor:(UIColor *_Nullable)titleColor
                                     titleSize:(CGFloat)titleSize
                               backgroundColor:(UIColor *_Nullable)backgroundColor
                                  cornerRadius:(CGFloat)cornerRadius;

/// 两端为大圆角、底色为渐变的Button
+ (instancetype _Nullable)roundCornerGradientButtonWithFrame:(CGRect)frame
                                                      title:(NSString * _Nullable)title;


//+ (instancetype _Nullable )initWithFrame:(CGRect)frame
//                              titleColor:(UIColor *_Nullable)titleColor
//                            cornerRadius:(CGFloat)cornerRadius;

- (void)setTitleColor:(UIColor *_Nullable)titleColor
         cornerRadius:(CGFloat)cornerRadius;

// 设置button为底色渐变、圆角
- (void)gradientBackgroudWithCornerRadius:(CGFloat)cornerRadius;


@end
