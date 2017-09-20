//
//  UIBarButtonItem+CustomBarButtonItem.h
//  BaiLi
//
//  Created by xabaili on 15/11/25.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomBarButtonItem)

+ (UIBarButtonItem *)buttonItemWithImageName:(NSString *)imageName
                     andHighlightedImageName:(NSString *)highlightedImageName;

+ (UIBarButtonItem *)backBarButtonItemForNavigationController:(UINavigationController *)navi
                                                withImageName:(NSString *)imageName;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                  highlightedImageName:(NSString *)hlImageName
                                target:(id)target
                                action:(SEL)action;

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                  highlightedImageName:(NSString *)hlImageName
                            buttonSize:(CGSize)size
                                target:(id)target
                                action:(SEL)action;

/// 文字UIBarButtonItem
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                          fontSize:(CGFloat)fontSize
                            target:(id)target
                            action:(SEL)action;

@end
