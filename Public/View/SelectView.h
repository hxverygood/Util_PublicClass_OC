//
//  SelectView.h
//  SelectCity
//
//  Created by 张广全 on 16/11/2.
//  Copyright © 2016年 zgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView

- (instancetype)initWithFrame:(CGRect)rect selectCityWithTitle:(NSString *)title buttonColor:(UIColor *)buttonColor;

- (void)showCityView:(void(^)(NSString *provinceStr,NSString *cityStr,NSString * disStr))selectStr;

@end
