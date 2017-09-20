//
//  HSAuthCompletionView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/10.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSAuthCompletionView.h"

@interface HSAuthCompletionView ()

/// 额度Label
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet HSBaseButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *promptLimitButton;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) void (^ButtonPressedBlock)(BOOL applyButtonPressed, BOOL promptLimitButtonPressed);

@property (nonatomic, strong) UIView *backgroudView;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end

@implementation HSAuthCompletionView

#pragma mark - Getter

- (UIView *)backgroudView {
    if (!_backgroudView) {
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        _backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
    }
    return _backgroudView;
}

- (UIColor *)startColor {
    if (!_startColor) {
        _startColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return _startColor;
}

- (UIColor *)endColor {
    if (!_endColor) {
        _endColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
    return _endColor;
}



#pragma mark - initializer

+ (instancetype)alertSuccessViewWithLimit:(NSString *)limit
                buttonPressedBlock:(void (^)(BOOL applyButtonPressed, BOOL promptLimitButtonPressed))buttonPressedBlock {
    return [[HSAuthCompletionView alloc] initWithLimit:limit buttonPressedBlock:buttonPressedBlock];
}

- (instancetype)initWithLimit:(NSString *)limit
           buttonPressedBlock:(void (^)(BOOL, BOOL))buttonPressedBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSAuthCompletionView" owner:nil options:nil] lastObject];
        
        self.limitLabel.text = [self limitStringWith:limit];
        self.backgroundColor = [UIColor clearColor];
        
        [self.applyButton addTarget:self action:@selector(applyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.promptLimitButton addTarget:self action:@selector(promptLimitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        self.backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
        self.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        self.backView.layer.cornerRadius = 8.0;
        self.backView.layer.masksToBounds = YES;
        
        CGSize size = self.frame.size;
        self.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.backView.backgroundColor = self.startColor;
        
        if (buttonPressedBlock) {
            self.ButtonPressedBlock = buttonPressedBlock;
        }
        
    }
    return self;
}



#pragma mark - Action

- (void)applyButtonPressed:(id)sender {
    [self dismiss];
    
    if (self.ButtonPressedBlock) {
        self.ButtonPressedBlock(YES, NO);
    }
}

- (void)promptLimitButtonPressed:(id)sender {
    [self dismiss];
    
    if (self.ButtonPressedBlock) {
        self.ButtonPressedBlock(NO, YES);
    }
}



#pragma mark - Func

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backgroudView];
    [window addSubview:self];
    _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    [UIView animateWithDuration:0.2 animations:^{
        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backView.backgroundColor = self.endColor;
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
    [_backgroudView removeFromSuperview];
}

// 拼接额度字符串
- (NSString *)limitStringWith:(NSString *)limit {
    NSNumber *num = [limit convertToNumber];
    if (!num) {
        return @"******";
    }
    
    limit = [limit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![limit hasPrefix:@"¥"]) {
        NSString *result = [NSString stringWithFormat:@"¥ %@", limit];
        return result;
    } else {
        return limit;
    }
}

@end
