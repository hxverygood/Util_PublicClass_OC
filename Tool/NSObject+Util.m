//
//  NSObject+Util.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/1/5.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "NSObject+Util.h"

@implementation NSObject (Util)

/// 打印引用计数
- (void)printRetainCount {
    NSLog(@"\n\n************** %@: retain count = %ld **************\n\n", NSStringFromClass([self class]), CFGetRetainCount((__bridge CFTypeRef)(self)));
}

@end
