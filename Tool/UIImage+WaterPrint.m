//
//  UIImage+WaterPrint.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/20.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UIImage+WaterPrint.h"

@implementation UIImage (WaterPrint)

/**
 * 加半透明水印（铺满整个区域）
 * @param rect 需要加水印的区域
 * @param waterMarkText 水印文字
 * @returns 加好水印的图片
 */
- (UIImage *)wateMarkImageInRect:(CGRect)rect
                   waterMarkText:(NSString *)waterMarkText {

    CGFloat w = 100.0;
    CGFloat h = 40.0;

    UIGraphicsBeginImageContext(CGSizeMake(w, h));

    UIColor *color = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    [waterMarkText drawInRect:CGRectMake(10.0, 0.0, w, h) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();



    UIGraphicsBeginImageContext(CGSizeMake(w, h*2));

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI/6);

    CGContextRef ctx_ = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx_, transform);
    CGContextDrawImage(ctx_, (CGRect){CGPointMake(10.0, 0.0), tmpImage.size}, tmpImage.CGImage);
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();



    UIGraphicsBeginImageContext(rect.size);
    // 平铺
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero, CGSizeMake(w, h*2)}, [smallImage CGImage]);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultingImage;
}



/**
 给UIImage添加水印

 @param imageLogo logo图片
 @param waterString 水印文字
 @return 添加水印后的图像
 */
- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString*)waterString {
    if (self.size.width == 0 ||
        self.size.height == 0) {
        return nil;
    }

    UIGraphicsBeginImageContext(self.size);
    //原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGFloat waterX = 633;
    CGFloat waterY = 461;
    CGFloat waterW = 16;
    CGFloat waterH = 16;
    //logo的渲染
    [imageLogo drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];

    //渲染文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:[UIColor redColor]};
    [waterString drawInRect:CGRectMake(0, 0, 300, 60) withAttributes:dic];

    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  // 此处注意要最后写入关闭绘制
    return imageNew;
}

@end
