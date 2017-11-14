//
//  HSZXUtilTools.h
//  HSInvestorAPP
//
//  Created by hoomsun on 2017/4/11.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HSZXUtilTools : NSObject

/**
 *  获取当前显示的ViewController
 *
 *  @return 当前显示的ViewController
 */
- (UIViewController *)getCurrentVC;


/**
 获取默认图片
 
 @return image
 */
-(UIImage*)getPlaceholderImage;


/*
 改变文字大小
 */
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)text textFont:(NSInteger)integer fromIndex:(NSInteger)index length:(NSInteger)length;



/**
 改变button中 图片和文字的位置 可以设置间距
 
 @param button 要改变的button
 @param margin 设置间距
 */
-(void)changeButtonTitleAndImageView:(UIButton*)button  Margin:(CGFloat)margin;

/**
 获取udid
 
 @return <#return value description#>
 */
-(NSString *)UDID;

/**
 *  动态调整文本控件高度
 *
 *  @param textView 文本控件
 */
-(void)autoAdjustHeight:(UIView *)textView;

/**
 *  动态调整文本控件宽度
 *
 *  @param textView 文本控件
 */
-(void)autoAdjustWidth:(UIView *)textView;

/**
 获取文本的高宽
 
 @param text 文本
 @param font 字号
 @return <#return value description#>
 */
-(CGSize)getTextLabel:(NSString*)text Font:(CGFloat)font;

/**
 旋转图片
 
 @param PI PI值
 @param image imageView
 */
-(void)arrowrotation:(double)PI view:(UIImageView*)image;

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 ** 绘制竖向线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawVerticalDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 获取当前时间
 
 @param formatterStr 时间格式 yyyy-mm-dd HH:mm:ss
 @return <#return value description#>
 */
-(NSString*)getCurrentDateWithFormatterStr:(NSString*)formatterStr;

/**
 字典转json
 
 @param dic <#dic description#>
 @return <#return value description#>
 */
-(NSString*)dictionaryToJson:(NSDictionary *)dic;


/**
 计算文字大小
 
 @param text 文本
 @param textfont 字号
 @param textSize 尺寸
 @return <#return value description#>
 */
-(CGSize)boundingStringRect:(NSString*)text textFont:(CGFloat)textfont textBaseSize:(CGSize)textSize;


#pragma mark --
#pragma mark -- 文件管理操作

/**
 获得缓存文件大小字符
 
 @return <#return value description#>
 */
-(NSString*)getSizeString;

/**
 1. 获取缓存文件的大小
 
 @return <#return value description#>
 */
-( double )readCacheSize;

/**
 由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
 // 遍历文件夹获得文件夹大小，返回多少 M
 
 @param folderPath <#folderPath description#>
 @return <#return value description#>
 */
- ( double ) folderSizeAtPath:( NSString *) folderPath;

/**
 // 计算 单个文件的大小
 
 @param filePath <#filePath description#>
 @return <#return value description#>
 */
- ( long long ) fileSizeAtPath:( NSString *) filePath;

/**
 2. 清除缓存
 */
- (void)clearFile;

/**
 清除某个路径下的文件
 */
-(void)clearFileByPath:(NSString*)patch;

/**
 判断这个图片是不是一个二维码
 
 @param img 传入微二维码图片
 @param block KqrCodeString 二维码信息 isAvailableQRcode yes 是二维码图片
 */
- (void)isAvailableQRcodeIn:(UIImage *)img completion:(void(^)(NSString * KqrCodeString,BOOL isAvailableQRcode))block;

/**
 为一个imageview添加水印
 (如果这个iamgeview 和屏幕一样大， 图片会平铺)
 
 @param rect <#rect description#>
 @param waterMarkText <#waterMarkText description#>
 @return <#return value description#>
 */
- (UIImage *)wateMarkImageInRect:(CGRect)rect
                   waterMarkText:(NSString *)waterMarkText;


-(BOOL)FirstGetNewVersionByNotForce;


@end
