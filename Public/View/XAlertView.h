//
//  XAlertView.h
//  TR7TreesV3
//
//  Created by hoomsun-finance on 16/5/1.
//  Copyright © 2016年 hoomsun-finance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XAlertView : UIView

@property (nonatomic, strong) UIButton * btn1;
@property (nonatomic, strong) UIButton * btn2;
@property (nonatomic, strong) UIButton * btn3;
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;
- (void)dissmiss;
- (void)show;

@end
