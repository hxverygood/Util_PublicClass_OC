//
//  UITabBarItem+HSTabBarItem.m
//  Hoomsundb
//
//  Created by hoomsun on 16/7/8.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UITabBarItem+HSTabBarItem.h"

@implementation UITabBarItem (HSTabBarItem)

+(instancetype)tabBarItemWithImageName:(NSString *)imageName selectedImage:(NSString *)selectedImage title:(NSString *)title {
    UITabBarItem *item = [[UITabBarItem alloc]init];
    item.title = title;
    
    UIImage *image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.image = image;
    item.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YELLOW, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"root_tab_bg_hl"]];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YELLOW, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
//    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"root_tab_bg_hl"]];
    return item;
}

@end
