//
//  CountDownButton.m
//  test_utils
//
//  Created by 韩啸 on 2018/3/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "CountDownButton.h"

@implementation CountDownButton

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  buttonColor:(UIColor *)buttonColor {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [self setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    
    return self;
}

@end
