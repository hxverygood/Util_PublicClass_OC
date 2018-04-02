//
//  CountDownLabel.m
//  test_utils
//
//  Created by 韩啸 on 2018/3/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "CountDownLabel.h"

@implementation CountDownLabel

- (instancetype)initWithFrame:(CGRect)frame
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.font = [UIFont systemFontOfSize:fontSize];
        self.textColor = textColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 2.0;
    }
    
    return self;
}

@end
