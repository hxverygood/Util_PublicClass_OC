//
//  UITextField+Utils.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "UITextField+Utils.h"

@implementation UITextField (Utils)

- (void)placeholderFontSize:(CGFloat)fontSize {
    CGFloat size = fontSize > 0.0 ? fontSize : 15.0;
    [self setValue:[UIFont boldSystemFontOfSize:size] forKeyPath:@"_placeholderLabel.font"];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

@end
