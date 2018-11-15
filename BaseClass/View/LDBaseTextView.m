//
//  LDBaseTextView.m
//  LDDriverSide
//
//  Created by 闪电狗 on 2018/9/29.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "LDBaseTextView.h"

@implementation LDBaseTextView

+(instancetype)view {
    LDBaseTextView *view = [[[NSBundle mainBundle]loadNibNamed:@"LDBaseTextView" owner:nil options:nil]firstObject];
    view.titleLabel.textColor = MainColor;
    return view;
}

@end
