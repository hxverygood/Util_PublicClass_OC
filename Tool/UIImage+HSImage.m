//
//  UIImage+HSImage.m
//  Hoomsundb
//
//  Created by hoomsun on 2016/12/6.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UIImage+HSImage.h"

#define iphone_res_2x ([UIScreen mainScreen].bounds.size.height <= 667.0f)

@implementation UIImage (HSImage)

/// 屏幕截图
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view {
    CGFloat ratio = 0.0f;
    if (iphone_res_2x) {
        ratio = 2.0f;
    } else {
        ratio = 3.0f;
    }
    return [[UIImage alloc] initWithView:view andRatio:ratio];
}

/// 屏幕截图
- (UIImage *)initWithView:(UIView *)view andRatio:(CGFloat)ratio {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, ratio);
    // 获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //UIView之所以能够显示，是因为它内部有一个层layer，通过渲染的形式绘制上下文
    [view.layer renderInContext:ctx];
    
    // 生成当前屏幕的一张截图
    self = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    return self;
}


// 屏幕“区域”截图
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view
                                       andRect:(CGRect)rect {
    CGFloat ratio = 0.0f;
    if (iphone_res_2x) {
        ratio = 2.0f;
    } else {
        ratio = 3.0f;
    }
    return [[UIImage alloc] initWithView:view rect:rect andRatio:ratio];
}

// 屏幕“区域”截图
- (UIImage *)initWithView:(UIView *)view
                     rect:(CGRect)rect
                 andRatio:(CGFloat)ratio {
    self = [super init];
    if (!self) {
        return nil;
    }

    UIImage *tmpImage = [[UIImage alloc] initWithView:view andRatio:ratio];
    self = [tmpImage clipImageWithRect:rect andRatio:ratio];
    
    return self;
}

// “区域”截屏，指定原始图片的缩放比例
+ (UIImage *)generateScreenSharedImageWithView:(UIView *)view
                                          rect:(CGRect)rect
                                      andRatio:(CGFloat)ratio {
    return [[UIImage alloc] initWithView:view rect:rect andRatio:ratio];
}

// 裁切图片
- (UIImage *)clipImageWithRect:(CGRect)rect
                      andRatio:(CGFloat)ratio {
    // 区域截屏
    CGRect regionRect = CGRectMake(rect.origin.x*ratio, rect.origin.y*ratio, rect.size.width*ratio, rect.size.height*ratio);
    UIImage *newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, regionRect)];
    
    return [newImage copy];
}

/// 按比例缩放图片（指定宽度）
- (UIImage *)scaleToWidth:(CGFloat)width {

    // 如果传入的宽度比当前宽度还要大,就直接返回

    if (width > self.size.width) {
        return  self;
    }

    // 计算缩放之后的高度
    CGFloat height = (width / self.size.width) * self.size.height;

    UIImage *image = [self generateNewImageWithWidth:width height:height];

    return image;
}

/// 按比例进行缩放，使其宽度或高度都不大于某个值
- (UIImage *)scaleToExpectedWidthOrHeight:(CGFloat)expectedWidthOrHeight {
    if (expectedWidthOrHeight > self.size.width &&
        expectedWidthOrHeight > self.size.height) {
        return self;
    }

    CGFloat width = 0.0;
    CGFloat height = 0.0;

    if (self.size.width >= self.size.height) {
        width = expectedWidthOrHeight;
        height = (width / self.size.width) * self.size.height;
    }
    else {
        height = expectedWidthOrHeight;
        width = (height / self.size.height) * self.size.width;
    }

    UIImage *image = [self generateNewImageWithWidth:width height:height];

    return image;
}


/// 读取二维码
- (NSString *)getInfoFromImage {
    UIImage *srcImage = self;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    
    return feature.messageString;
}


/// 设置图片透明度
- (UIImage *)convertImageAlpha:(CGFloat)alpha
                         image:(UIImage*)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/// 将UIView转化成image
+ (UIImage*)convertImageWithView:(UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



#pragma mark - Private Func

- (UIImage *)generateNewImageWithWidth:(CGFloat)width
                           height:(CGFloat)height {
    // 初始化要画的大小
    CGRect  rect = CGRectMake(0, 0, width, height);

    // 1. 开启图形上下文
    UIGraphicsBeginImageContext(rect.size);

    // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
    [self drawInRect:rect];

    // 3. 取到图片

    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();

    // 4. 关闭上下文
    UIGraphicsEndImageContext();
    // 5. 返回
    return image;
}

@end
