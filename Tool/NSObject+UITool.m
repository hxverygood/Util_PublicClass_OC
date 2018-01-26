//
//  NSObject+UITool.m
//  Baili
//
//  Created by xabaili on 15/12/12.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import "NSObject+UITool.h"
#import <UIKit/UIKit.h>

@implementation NSObject (UITool)

/// 判断UITextField或UILabel中的内容是否为空
- (BOOL)contentIsEmptyWithTextFieldOrLabelArray:(NSArray *)array {
    for (NSObject *object in array) {
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)object;
            if (textField.text.length == 0) {
                return YES;
            }
        } else {
            UILabel *label = (UILabel *)object;
            if (label.text.length == 0) {
                return YES;
            }
        }
    }
    return NO;
}

/// 判断UITextField或UILabel中的内容是否相等
- (BOOL)contentIsEqualWithTextFieldOrLabelArray:(NSArray *)array {
    NSMutableArray *contentArray = [NSMutableArray array];
    for (NSObject *object in array) {
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)object;
            [contentArray addObject:textField.text];
        } else {
            UILabel *label = (UILabel *)object;
            [contentArray addObject:label.text];
        }
    }
    
    for (int i=0; i<=contentArray.count-2; i++) {
        NSString *firstContent = contentArray[i];
        for (int j=i+1; j<=contentArray.count-1; j++) {
            NSString *secondContent = contentArray[j];
            if (![firstContent isEqualToString:secondContent]) {
                return NO;
            }
        }
    }
    return YES;
}


/**
 *  获取通过xib设计的UIView或UITableViewCell高度
 *
 *  @param nibName xib文件名
 *
 *  @return cell的高度
 */
- (CGFloat)viewHeightWithNibName:(NSString *)nibName {
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    if (nib == nil) {
        return 0.0;
    }
    UIView *view = [[nib instantiateWithOwner:nil options:nil] lastObject];
    return view.frame.size.height;
}


/// 去除导航栏底部横线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


/// 收起键盘
- (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
