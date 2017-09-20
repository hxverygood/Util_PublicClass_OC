//
//  HSZXUtilTools.m
//  HSInvestorAPP
//
//  Created by hoomsun on 2017/4/11.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSZXUtilTools.h"

@implementation HSZXUtilTools

/**
 *  获取当前显示的ViewController
 *
 *  @return 当前显示的ViewController
 */
- (UIViewController *)getCurrentVC
{
  return  [self getCurrentVCFrom:[self getCurrentRootVC]];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentRootVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}


/**
 获取默认图片
 
 @return image
 */
-(UIImage*)getPlaceholderImage
{
    return [UIImage imageNamed:@"placehold"];
}


/*
 改变文字大小
 */
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)text textFont:(NSInteger)integer fromIndex:(NSInteger)index length:(NSInteger)length
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    UIFont *font = [UIFont systemFontOfSize:integer];
    //前面4个字体大小
    [attrString addAttribute:NSFontAttributeName value:font  range:NSMakeRange(index,length)];
    return attrString;
}


/**
 改变button中 图片和文字的位置 可以设置间距
 
 @param button 要改变的button
 @param margin 设置间距
 */
-(void)changeButtonTitleAndImageView:(UIButton*)button  Margin:(CGFloat)margin
{
    CGSize imageSize = button.imageView.size;
    CGSize labelSize = button.titleLabel.size;
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageSize.width+(margin/2.f)), 0, imageSize.width+(margin/2.f))];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, labelSize.width+(margin/2.f), 0, -(labelSize.width+(margin/2.f)))];
    
}


/**
 获取udid
 
 @return <#return value description#>
 */
-(NSString *)UDID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
    NSString *identifierNumber = [NSString stringWithFormat:@"%@",uuidstring];
    identifierNumber = [identifierNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    identifierNumber = [identifierNumber lowercaseString];
    return identifierNumber;
}
/**
 *  动态调整文本控件高度
 *
 *  @param textView 文本控件
 */
-(void)autoAdjustHeight:(UIView *)textView
{
    if ([textView isKindOfClass:[UILabel class]]||[textView isKindOfClass:[UITextView class]]) {
        
        CGRect frame=textView.frame;
        [textView sizeToFit];
        frame.size.height=textView.frame.size.height;
        textView.frame=frame;
    }
    
}
/**
 *  动态调整文本控件宽度
 *
 *  @param textView 文本控件
 */
-(void)autoAdjustWidth:(UIView *)textView
{
    if ([textView isKindOfClass:[UILabel class]]||[textView isKindOfClass:[UITextView class]]) {
        
        CGRect frame=textView.frame;
        [textView sizeToFit];
        frame.size.width=textView.frame.size.width;
        textView.frame=frame;
    }
    
}


/**
 获取文本的高宽
 
 @param text 文本
 @param font 字号
 @return <#return value description#>
 */
-(CGSize)getTextLabel:(NSString*)text Font:(CGFloat)font
{
    return [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}];
}


/**
 旋转图片
 
 @param PI PI值
 @param image imageView
 */
-(void)arrowrotation:(double)PI view:(UIImageView*)image
{
    [UIView animateWithDuration:0.25 animations:^
     {
         image.transform = CGAffineTransformMakeRotation(PI);
     } completion:^(BOOL finished)
     {
         
     }];
}


/**
 ** 绘制横向线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/**
 ** 绘制竖向线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawVerticalDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) , CGRectGetHeight(lineView.frame)/2)];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,0, CGRectGetHeight(lineView.frame));
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}



/**
 获取当前时间
 
 @param formatterStr 时间格式 yyyy-mm-dd HH:mm:ss
 @return <#return value description#>
 */
-(NSString*)getCurrentDateWithFormatterStr:(NSString*)formatterStr
{
    // 实例化NSDateFormatter
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter setDateFormat:formatterStr];
    
    // 获取当前日期
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    
    return currentDateString;
}


/**
 字典转json
 
 @param dic <#dic description#>
 @return <#return value description#>
 */
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


-(CGSize)boundingStringRect:(NSString*)text textFont:(CGFloat)textfont textBaseSize:(CGSize)textSize
{
    CGRect infoRect = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont]}context:nil];
    return infoRect.size;
}

#pragma mark --
#pragma mark -- 文件管理操作

/**
 获得缓存文件大小字符
 
 @return <#return value description#>
 */
-(NSString*)getSizeString
{
    double size = [self readCacheSize];
    NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
    return message;
}

/**
 1. 获取缓存文件的大小
 
 @return <#return value description#>
 */
-( double )readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}

/**
 由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
 // 遍历文件夹获得文件夹大小，返回多少 M
 
 @param folderPath <#folderPath description#>
 @return <#return value description#>
 */
- ( double ) folderSizeAtPath:( NSString *) folderPath
{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil )
    {
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
}

/**
 // 计算 单个文件的大小
 
 @param filePath <#filePath description#>
 @return <#return value description#>
 */
- ( long long ) fileSizeAtPath:( NSString *) filePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

/**
 2. 清除缓存
 */
- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    [self clearFileByPath:cachePath];
}


/**
 清除某个路径下的文件
 */
-(void)clearFileByPath:(NSString*)patch
{
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :patch];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files)
    {
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [patch stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}



/**
  判断这个图片是不是一个二维码

 @param img 传入微二维码图片
 @param block KqrCodeString 二维码信息 isAvailableQRcode yes 是二维码图片
 */
- (void)isAvailableQRcodeIn:(UIImage *)img completion:(void(^)(NSString * KqrCodeString,BOOL isAvailableQRcode))block
{
    
    NSString * qdStr;
    UIImage *image = [img imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        qdStr = [feature.messageString copy];
        block(qdStr,YES);
    } else
    {
        qdStr = @"无可识别的二维码";
        block(qdStr,NO);
    }
}





/**
 为一个imageview添加水印
 (如果这个iamgeview 和屏幕一样大， 图片会平铺)

 @param rect <#rect description#>
 @param waterMarkText <#waterMarkText description#>
 @return <#return value description#>
 */
- (UIImage *)wateMarkImageInRect:(CGRect)rect
                   waterMarkText:(NSString *)waterMarkText {
    
    CGFloat w = 100.0;
    CGFloat h = 40.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    UIColor *color = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:0.25];
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

-(BOOL)FirstGetNewVersionByNotForce
{
    NSString * firtStr = [kUserDefault objectForKey:KFirstGetNewVersion];
    if (firtStr.length)
    {
        return NO;
    }
    
    [kUserDefault setObject:KFirstGetNewVersion forKey:KFirstGetNewVersion];
    return YES;
}

@end
