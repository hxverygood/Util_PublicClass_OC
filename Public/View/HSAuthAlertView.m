//
//  HSAuthAlertView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSAuthAlertView.h"

@interface HSAuthAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, copy) void (^ButtonPressedBlock)(void);
@property (nonatomic, copy) void (^cancelButtonPressedBlock)(void);

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UIView *backgroudView;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end



@implementation HSAuthAlertView

#pragma mark - Getter

- (UIView *)backgroudView {
    if (!_backgroudView) {
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        _backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
//        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
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

+ (instancetype)alertViewWithTitle:(NSString *)title
                      butttonTitle:(NSString *)buttonTitle
                buttonPressedBlock:(void (^)(void))buttonPressedBlock
               cancelButtonPressed:(void (^)(void))cancelButtonPressed {
//    HSAuthAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"HSAuthAlertView" owner:nil options:nil] lastObject];
//    
//    view.titleLabel.text = title ?: @"";
//    [view.authButton setTitle:buttonTitle ?: @"" forState:UIControlStateNormal];
//    
//    CGRect bgViewFrame = [UIScreen mainScreen].bounds;
//    view.backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
//    view.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//    view.layer.cornerRadius = 6.0;
//    view.layer.masksToBounds = YES;
//    
//    view.frame = CGRectMake(0.0, 0.0, 220.0, 140.0);
//    view.center = [UIApplication sharedApplication].keyWindow.center;
//    
//    if (buttonPressedBlock) {
//        view.ButtonPressedBlock = buttonPressedBlock;
//    }
    
    return [[HSAuthAlertView alloc] initWithTitle:title butttonTitle:buttonTitle buttonPressedBlock:buttonPressedBlock cancelButtonPressed:cancelButtonPressed];
}

- (instancetype)initWithTitle:(NSString *)title
                 butttonTitle:(NSString *)buttonTitle
           buttonPressedBlock:(void (^)(void))buttonPressedBlock
          cancelButtonPressed:(void (^)(void))cancelButtonPressed {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSAuthAlertView" owner:nil options:nil] lastObject];
        
        self.titleLabel.text = title ?: @"";
        [self.authButton setTitle:buttonTitle ?: @"" forState:UIControlStateNormal];
        
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        self.backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
        self.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        self.frame = CGRectMake(0.0, 0.0, 280.0, 160.0);
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.backgroundColor = self.startColor;
        
        if (buttonPressedBlock) {
            self.ButtonPressedBlock = buttonPressedBlock;
        }
        
        if (cancelButtonPressed) {
            self.cancelButtonPressedBlock = cancelButtonPressed;
        }
        
    }
    return self;
}



#pragma mark - Action

- (void)buttonPressed:(id)sender {
    if (self.ButtonPressedBlock) {
        self.ButtonPressedBlock();
    }
    [self dismiss];
}

- (void)cancelButtonPressed:(id)sender {
    [self dismiss];
    if (self.cancelButtonPressedBlock) {
        self.cancelButtonPressedBlock();
    }
}



#pragma mark - Func

- (void)show {
    [self.authButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backgroudView];
    [window addSubview:self];
    _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    [UIView animateWithDuration:0.2 animations:^{
        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backgroundColor = self.endColor;
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
    [_backgroudView removeFromSuperview];

//    [UIView animateWithDuration:0.2 animations:^{
//        _backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//        self.backgroundColor = self.startColor;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        [_backgroudView removeFromSuperview];
//        
//        if (self.ButtonPressedBlock) {
//            self.ButtonPressedBlock();
//        }
//    }];
}



@end
