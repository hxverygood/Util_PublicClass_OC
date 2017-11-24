//
//  UIView+HSView.m
//  Hoomsundb
//
//  Created by hoomsun on 16/7/11.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UIView+HSView.h"

@implementation UIView (HSView)

+(UIView *)viewWithImageView:(NSString*)imageView Categary:(CGRect)rect {
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    //view.layer.cornerRadius = 5.0f;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(12+4, 9+4, 25-8, 25-8)];
    imageview.image = [UIImage imageNamed:imageView];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageview];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.size.width +imageview.frame.origin.x + 12, 9, 1, 25)];
    lineLabel.backgroundColor = [[UIColor alloc]initWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:0.2];
    [view addSubview:lineLabel];
    return view;
}

+ (CGRect)fullScreenFrame {
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    BOOL isIPhoneX = ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f) ? YES : NO;
    
    CGFloat navHeight = isIPhoneX ? 88.0 : 64.0;
    CGFloat naviHeightDiff = navIsTranlucent ? 0.0 : navHeight;
    CGFloat bottomDiff = isIPhoneX ? 34.0 : 0.0;
    
    CGFloat viewHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - naviHeightDiff - bottomDiff;
    CGRect viewFrame = CGRectMake(0.0, 0.0, kScreenWidth, viewHeight);
    
    return viewFrame;
}



#pragma mark - Private Func

- (CGFloat)navigationBarHeight {
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    
    CGFloat navHeight = [self isIPhoneX] ? 88.0 : 64.0;
    CGFloat heightDiff = navIsTranlucent ? 0.0 : navHeight;
    return heightDiff;
}

- (BOOL)isIPhoneX {
    BOOL isIPhoneX = ([[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f) ? YES : NO;
    return isIPhoneX;
}

@end
