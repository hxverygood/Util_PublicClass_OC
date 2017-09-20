//
//  HSInsetsTextField.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/7.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSInsetsTextField.h"

@implementation HSInsetsTextField

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 15, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 15, 0);
}

@end
