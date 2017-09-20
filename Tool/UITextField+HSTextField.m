//
//  UITextField+HSTextField.m
//  Hoomsundb
//
//  Created by hoomsun on 16/7/11.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UITextField+HSTextField.h"

@implementation UITextField (HSTextField)

+ (UITextField *)textFieldTitle:(NSString*)title andFrameByCategory:(CGRect)rect{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = title;
    textField.textAlignment = NSTextAlignmentCenter;
    //textField.layer.cornerRadius = 5.0f;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setValue:Gray167 forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = [[UIColor alloc]initWithRed:54/255.0f green:54/255.0f blue:54/255.0f alpha:1];
    textField.inputView.backgroundColor = [[UIColor alloc]initWithRed:54/255.0f green:54/255.0f blue:54/255.0f alpha:1];
    textField.clearButtonMode = 1;
    return textField;
}

+ (UITextField *)textFieldBuyDetailTitle:(NSString *)title andFrameByCategory:(CGRect)rect {
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.font = [UIFont systemFontOfSize:12];
    textField.placeholder = title;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.cornerRadius = 5.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor = (__bridge CGColorRef _Nullable)([[UIColor alloc]initWithRed:1 green:88/255.0f blue:74/255.0f alpha:1]);
    textField.layer.borderWidth = 1.0f;
    return textField;
}

@end
