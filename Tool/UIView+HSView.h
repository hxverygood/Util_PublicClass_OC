//
//  UIView+HSView.h
//  Hoomsundb
//
//  Created by hoomsun on 16/7/11.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HSView)

+ (UIView *)viewWithImageView:(NSString*)imageView Categary:(CGRect)rect;

+ (CGRect)fullScreenFrame;

/**
 设置默认的渐变色
 */
-(void)setViewNorlMalGradientColor;



// 获取渐变色图片
-(UIImage*)getNorlMalGradientColorImage;



/**
 设置渐变色
 
 @param lefC 左边颜色
 @param centC 中间过度色
 @param rigtC 右边颜色
 */
-(void)setViewGradientColorLeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC;







/**
 绘制渐变图
 
 @param lefC <#lefC description#>
 @param centC <#centC description#>
 @param rigtC <#rigtC description#>
 @return <#return value description#>
 */

//
-(UIImage*)getGradientImageWithLeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC;




/**
 绘制线性渐变
 
 @param context <#context description#>
 @param path <#path description#>
 @param lefC <#lefC description#>
 @param centC <#centC description#>
 @param rigtC <#rigtC description#>
 */
- (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path LeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC;



@end
