//
//  NSObject+UITool.h
//  Baili
//
//  Created by xabaili on 15/12/12.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UITool)

/// 判断UITextField或UILabel中的内容是否为空
- (BOOL)contentIsEmptyWithTextFieldOrLabelArray:(NSArray *)array;

/// 判断UITextField或UILabel中的内容是否相等
- (BOOL)contentIsEqualWithTextFieldOrLabelArray:(NSArray *)array;

/**
 *  获取通过xib设计的UIView或UITableViewCell高度
 *
 *  @param nibName xib文件名
 *
 *  @return cell的高度
 */
- (CGFloat)viewHeightWithNibName:(NSString *)nibName;


/// 去除导航栏底部横线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view;

/// 收起键盘
- (void)hideKeyboard;

@end
