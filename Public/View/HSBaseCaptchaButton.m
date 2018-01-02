//
//  HSBaseCaptchaButton.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2017/12/25.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseCaptchaButton.h"

@implementation HSBaseCaptchaButton

#pragma mark - Initailizer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
//    self.layer.cornerRadius = 3.0;
//    self.layer.masksToBounds = YES;
}

- (void)setup {
    if ([self isBlankString:self.titleLabel.text]) {
        self.titleLabel.text = @"获取验证码";
    }
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.backgroundColor = [UIColor clearColor];
    [self setTitleColor:YELLOW_BUTTON forState:UIControlStateNormal];
    
    self.layer.borderColor = YELLOW_BUTTON.CGColor;
    self.layer.borderWidth = 1.0;
    //        self.layer.cornerRadius = 3.0;
    //        self.layer.masksToBounds = YES;
}



#pragma mark - Private Func

/// 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
