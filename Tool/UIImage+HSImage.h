//
//  UIImage+HSImage.h
//  Hoomsundb
//
//  Created by hoomsun on 2016/12/6.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HSImage)

/**
 屏幕截图（工厂方法）

 @param view 需要截屏的当前视图，例如self.view
 @return UIImage
 */
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view;
- (UIImage *)initWithView:(UIView *)view andRatio:(CGFloat)ratio;


/**
 屏幕“区域”截屏（工厂方法）

 @param view 需要截屏的当前视图，例如self.view
 @param rect 需要截取的区域
 @return 裁切后的UIImage
 */
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view
                                       andRect:(CGRect)rect;
- (UIImage *)initWithView:(UIView *)view
                     rect:(CGRect)rect
                 andRatio:(CGFloat)ratio;



/**
 “区域”截屏，指定原始图片的缩放比例（工厂方法）

 @param view 需要截屏的当前视图，例如self.view
 @param rect 需要截取的区域
 @param ratio 缩放比例
 @return 裁切后的UIImage
 */
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view
                                          rect:(CGRect)rect
                                      andRatio:(CGFloat)ratio;

/**
 裁切图片

 @param rect 需要截取的区域
 @param ratio 缩放比例
 @return 裁切后的UIImage
 */
- (UIImage *)clipImageWithRect:(CGRect)rect
                      andRatio:(CGFloat)ratio;


/**
 读取二维码

 @return 二维码中包含的字符串
 */
- (NSString *)getInfoFromImage;

/// 设置图片透明度
- (UIImage *)convertImageAlpha:(CGFloat)alpha
                         image:(UIImage*)image;

/// 将UIView转化成image
+ (UIImage*)convertImageWithView:(UIView*)view;

@end
