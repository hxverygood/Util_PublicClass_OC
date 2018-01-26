//
//  UIView+HSView.m
//  Hoomsundb
//
//  Created by hoomsun on 16/7/11.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UIView+HSView.h"

@implementation UIView (HSView)

+(UIView *)viewWithImageView:(NSString*)imageView Categary:(CGRect)rect {
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    //view.layer.cornerRadius = 5.0f;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(12+4, 9+4, 25-8, 25-8)];
    imageview.image = [UIImage imageNamed:imageView];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageview];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width +imageview.frame.origin.x + 12, 9, 1, 25)];
    lineLabel.backgroundColor = [[UIColor alloc]initWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:0.2];
    [view addSubview:lineLabel];
    return view;
}

+ (CGRect)fullScreenFrame {
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    BOOL isIPhoneX = ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f) ? YES : NO;
    
    UIViewController *currentVC = [UIViewController currentViewController];
    BOOL naviBarIsHidden = currentVC.navigationController.isNavigationBarHidden;
    
    CGFloat navHeight = isIPhoneX ? 88.0 : 64.0;
    CGFloat naviHeightDiff = (navIsTranlucent || naviBarIsHidden) ? 0.0 : navHeight;
    CGFloat bottomDiff = isIPhoneX ? 34.0 : 0.0;
    
    CGFloat viewHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - naviHeightDiff - bottomDiff;
    CGRect viewFrame = CGRectMake(0.0, 0.0, kScreenWidth, viewHeight);
    
    return viewFrame;
}



#pragma mark - Private Func

- (CGFloat)navigationBarHeight {
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    
    CGFloat navHeight = [self isIPhoneX] ? 88.0 : 64.0;
    CGFloat heightDiff = navIsTranlucent ? 0.0 : navHeight;
    return heightDiff;
}

- (BOOL)isIPhoneX {
    BOOL isIPhoneX = ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f) ? YES : NO;
    return isIPhoneX;
}

/**
 设置默认的渐变色
 */
-(void)setViewNorlMalGradientColor
{
    [self setViewGradientColorLeftColor:[UIColor colorWithHexString:@"a98149"] CenterColor:[UIColor colorWithHexString:@"b68e56"] RightColor:[UIColor colorWithHexString:@"cca76c"]];
}


// 获取渐变色图片
-(UIImage*)getNorlMalGradientColorImage
{
    return [self getGradientImageWithLeftColor:[UIColor colorWithHexString:@"a98149"] CenterColor:[UIColor colorWithHexString:@"b68e56"] RightColor:[UIColor colorWithHexString:@"cca76c"]];
}


/**
 设置渐变色
 
 @param lefC 左边颜色
 @param centC 中间过度色
 @param rigtC 右边颜色
 */
-(void)setViewGradientColorLeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)lefC.CGColor, (__bridge id)centC.CGColor, (__bridge id)rigtC.CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame =  CGRectMake(0, 0, self.width, self.height);
    [self.layer addSublayer:gradientLayer];
}






/**
 绘制渐变图
 
 @param lefC <#lefC description#>
 @param centC <#centC description#>
 @param rigtC <#rigtC description#>
 @return <#return value description#>
 */

//
-(UIImage*)getGradientImageWithLeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC
{
    //开启图形上下文
    UIGraphicsBeginImageContext(self.bounds.size);
    
    //获得当前画板（上下文）
    CGContextRef gc = UIGraphicsGetCurrentContext();
    //创建CGMutablePathRef (实质是创建绘制路径)
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    // 起点
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    //绘制渐变
    [self drawLinearGradient:gc path:path LeftColor:lefC CenterColor:centC RightColor:rigtC];
    //注意释放CGMutablePathRef(实质是闭合路径)
    CGPathRelease(path);
    //从Context中获取图像，并显示在界面上(获取绘制的图片)
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



/**
 绘制线性渐变
 
 @param context <#context description#>
 @param path <#path description#>
 @param lefC <#lefC description#>
 @param centC <#centC description#>
 @param rigtC <#rigtC description#>
 */
- (void)drawLinearGradient:(CGContextRef)context path:(CGPathRef)path LeftColor:(UIColor*)lefC CenterColor:(UIColor*)centC RightColor:(UIColor*)rigtC
{
    //  绘制背景渐变的
    //  CGColorSpaceCreateDeviceRGB 获得rgb色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 色彩得分梯度范围 （0-1） ，且呈现递增趋势
    CGFloat locations[] = { 0.3,0.5,1.0};
    // 颜色数组
    NSArray *colors = @[(__bridge id) lefC.CGColor, (__bridge id) centC.CGColor,(__bridge id) rigtC.CGColor];
    
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    // 根据绘制的路径绘制成的矩形的rect
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    // 方向只由两个点控制
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetWidth(pathRect), CGRectGetHeight(pathRect));
    
    // 拓展
    // UIGraphicsPushContext: 压栈当前的绘制对象，生成新的绘制图层
    // CGContextSaveGState:  压栈当前的绘制状态
    
    //    A.将context绘制状态参数上下文copy一份，保存在内存，以后更改的绘制状态不影响内存中的绘制状态
    //    CGContextSaveGState(context)
    //    B.将之前保存的绘制状态覆盖掉context的绘制状态，并将内存中的绘制状态释放
    //    CGContextRestoreGState(context);
    
    
    // 大概意思就是保存当前的绘制状态吧
    CGContextSaveGState(context);
    
    //添加上下文和绘制路径
    CGContextAddPath(context, path);
    
    // 裁剪上下文
    CGContextClip(context);
    
    // 绘制线性的线变色
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // 更新或者覆盖上下文
    CGContextRestoreGState(context);
    
    //释放色渐变
    CGGradientRelease(gradient);
    
    //释放色彩空间
    CGColorSpaceRelease(colorSpace);
}



@end
