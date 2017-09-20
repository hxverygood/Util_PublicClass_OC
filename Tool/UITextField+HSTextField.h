//
//  UITextField+HSTextField.h
//  Hoomsundb
//
//  Created by hoomsun on 16/7/11.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HSTextField)

+ (UITextField *)textFieldTitle:(NSString*)title andFrameByCategory:(CGRect)rect;

+ (UITextField *)textFieldBuyDetailTitle:(NSString *)title andFrameByCategory:(CGRect)rect;

@end
