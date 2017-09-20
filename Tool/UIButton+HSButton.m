//
//  UIButton+HSButton.m
//  Hoomsundb
//
//  Created by hoomsun on 16/7/8.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "UIButton+HSButton.h"
#import "UILabel+HSLabel.h"
@implementation UIButton (HSButton)

+(instancetype)buttonWithTitle:(NSString *)title rect:(CGRect)rect {
    //UIButton *button = [[UIButton alloc]initWithFrame:rect];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = rect;
    button.clipsToBounds=YES;
    button.layer.cornerRadius = 5.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:@"sureButton"] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:Blue] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[[UIColor alloc] initWithRed:233/255.0f green:187/255.0f blue:0/255.0f alpha:1]] forState:UIControlStateFocused];
    UILabel *titleLabel = [UILabel  labelWithText:title font:14 rect:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    [button addSubview:titleLabel];
    return button;
}

+(instancetype)sureButtonWithTitle:(NSString *)title rect:(CGRect)rect {
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    UILabel *titleLabel = [UILabel  labelWithText:title font:14 rect:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    [button setBackgroundImage:[self imageWithColor:Blue] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageWithColor:[[UIColor alloc] initWithRed:233/255.0f green:187/255.0f blue:0/255.0f alpha:1]] forState:UIControlStateFocused];
    titleLabel.textColor = [UIColor whiteColor];
    [button addSubview:titleLabel];
    return button;
}



+(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
