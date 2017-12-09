//
//  HSSmallPlaceholderTextField.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSSmallPlaceholderTextField.h"

@implementation HSSmallPlaceholderTextField

// 返回placeholderLabel的bounds，改变返回值，是调整placeholderLabel的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0 , self.bounds.size.width, self.bounds.size.height);
}
// 这个函数是调整placeholder在placeholderLabel中绘制的位置以及范围
- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
}

@end
