//
//  HSBaseDiseditableTextField.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseDiseditableTextField.h"

@implementation HSBaseDiseditableTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
