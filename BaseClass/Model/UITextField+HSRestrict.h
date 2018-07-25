//
//  UITextField+HSRestrict.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextRestrict.h"

@class HSTextRestrict;

@interface UITextField (HSRestrict)

/// 设置后生效
@property (nonatomic, assign) HSRestrictType restrictType;
/// 文本最长长度
@property (nonatomic, assign) NSUInteger maxTextLength;
/// 设置自定义正则，配合HSRestrictTypeCustom使用
@property (nonatomic, strong) NSString *predicateStr;
/// 设置自定义的文本限制
@property (nonatomic, strong) HSTextRestrict *textRestrict;

@end
