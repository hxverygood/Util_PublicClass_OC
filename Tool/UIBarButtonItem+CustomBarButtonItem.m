//
//  UIBarButtonItem+CustomBarButtonItem.m
//  BaiLi
//
//  Created by xabaili on 15/11/25.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import "UIBarButtonItem+CustomBarButtonItem.h"

@implementation UIBarButtonItem (CustomBarButtonItem)

/**
 *  设置UIBarButtonItem
 *
 *  @param imageName            正常状态的图片名称
 *  @param highlightedImageName 高亮状态的图片名称
 *
 *  @return UIBarButtonItem实例对象
 */
+ (UIBarButtonItem *)buttonItemWithImageName:(NSString *)imageName
                     andHighlightedImageName:(NSString *)highlightedImageName {
    UIImage *buttonItemImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    [button setBackgroundImage:buttonItemImage forState:UIControlStateNormal];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (highlightedImageName != nil) {
        UIImage *buttonItemImageHL = [[UIImage imageNamed:highlightedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [button setBackgroundImage:buttonItemImageHL forState:UIControlStateHighlighted];
    }
    return buttonItem;
}

+ (UIBarButtonItem *)backBarButtonItemForNavigationController:(UINavigationController *)navi
                                                withImageName:(NSString *)imageName {
    UIImage *backButtonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    id appearance = nil;
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        appearance = [UIBarButtonItem appearanceWhenContainedIn:[navi class], nil];
    } else {
        appearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[navi class]]];
    }
    [appearance setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:navi action:NULL];
    
    return backBarButtonItem;
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                  highlightedImageName:(NSString *)hlImageName
                                target:(id)target
                                action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName
                  highlightedImageName:(NSString *)hlImageName
                            buttonSize:(CGSize)size
                                target:(id)target
                                action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title
                        titleColor:(UIColor *)titleColor
                          fontSize:(CGFloat)fontSize
                            target:(id)target
                            action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = title;
    NSUInteger titleSize = fontSize == 0 ? 14.0 : fontSize;
    UIFont *font = [UIFont boldSystemFontOfSize:titleSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    item.tintColor = titleColor;
    [item setTarget:target];
    [item setAction:action];
    
    return item;
}


@end
