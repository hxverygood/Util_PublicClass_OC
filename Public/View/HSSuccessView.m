//
//  HSSuccessView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSSuccessView.h"

@interface HSSuccessView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) UIView *backgroudView;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@property (nonatomic, copy) void (^closelButtonPressedBlock)(void);

@end

@implementation HSSuccessView

+ (instancetype)showSucccessViewWithImageName:(NSString *)imageName
                                      content:(NSString *)content
                          closelButtonPressed:(void (^)(void))closelButtonPressedBlock {
    return [[HSSuccessView alloc] initWithImageName:imageName content:content closelButtonPressed:closelButtonPressedBlock];
}

- (instancetype)initWithImageName:(NSString *)imageName
                          content:(NSString *)content
              closelButtonPressed:(void (^)(void))closelButtonPressedBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSSuccessView" owner:nil options:nil] lastObject];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        self.backgroudView = [[UIView alloc] initWithFrame:bgViewFrame];
        self.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        if ([NSString isBlankString:imageName]) {
            self.imageView.image = [UIImage imageNamed:@"成功"];
        } else {
            self.imageView.image = [UIImage imageNamed:imageName];
        }
        
        if ([NSString isBlankString:content]) {
            self.contentLabel.text = @"";
        } else {
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributedWithString:content fontSize:15.0 fontColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0] paragraphAlignment:NSTextAlignmentCenter lineSpacing:1.2];
            self.contentLabel.attributedText = attStr;
        }
    
        if (closelButtonPressedBlock) {
            self.closelButtonPressedBlock = closelButtonPressedBlock;
        }
        
        [self show];
    }
    return self;
}



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



#pragma mark - UI

- (void)layoutSubviews {
    [super layoutSubviews];

    [self setNeedsDisplay];
//    [self layoutIfNeeded];
    self.center = [UIApplication sharedApplication].keyWindow.center;
}



#pragma mark - Action

- (IBAction)closeButtonPressed:(id)sender {
    [self dismiss];
}



#pragma mark - Private Func

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backgroudView];
    [window addSubview:self];
    self.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroudView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.backgroundColor = self.endColor;
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
    [_backgroudView removeFromSuperview];
    
    if (self.closelButtonPressedBlock) {
        self.closelButtonPressedBlock();
    }
}





@end
