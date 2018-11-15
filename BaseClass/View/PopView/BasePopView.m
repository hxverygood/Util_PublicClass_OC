//
//  BasePopView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BasePopView.h"

static CGFloat animationDuration = 0.5;
static CGFloat animationDelay = 0.0;
static CGFloat animationDamping = 0.6;
static CGFloat animationVelocity = 0.6;



@interface BasePopView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end



@implementation BasePopView

#pragma mark - Getter / Setter

- (UIView *)backgroundView {
    if (!_backgroundView) {
        CGRect bgViewFrame = [UIScreen mainScreen].bounds;
        _backgroundView = [[UIView alloc] initWithFrame:bgViewFrame];
        _backgroundView.backgroundColor = self.startColor;
    }
    return _backgroundView;
}

- (UIColor *)startColor {
    if (!_startColor) {
        _startColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    }
    return _startColor;
}

- (UIColor *)endColor {
    if (!_endColor) {
        _endColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    }
    return _endColor;
}

- (void)setCanDismissWhenTapBackground:(BOOL)canDismissWhenTapBackground {
    _canDismissWhenTapBackground = canDismissWhenTapBackground;

    if (canDismissWhenTapBackground) {
        // 添加tap手势
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] init];
        [gr addTarget:self action:@selector(tapBackgroundViewAction)];
        [_backgroundView addGestureRecognizer:gr];
    }
}



#pragma mark - Func

- (void)show {
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    switch (self.popViewStyle) {
        case PopViewStyleCenter:
        {
            CGRect screenBounds = [UIScreen mainScreen].bounds;
            self.center = CGRectGetCenter(screenBounds);
            self.transform = CGAffineTransformMakeScale(0.0, 0.0);
        }
            break;

        case PopViewStyleFromBottom:
        {
            CGRect frameForShow = self.frame;
            frameForShow.origin.y = (kScreenHeight -CGRectGetHeight(self.frame))/2;
            self.frameForShow = frameForShow;

            CGRect frameForHidden = self.frame;
            frameForHidden.origin.y = kScreenHeight;
            self.frameForHidden = frameForHidden;

            NSAssert(!CGRectEqualToRect(self.frameForShow, CGRectZero), @"frameForShow为空，无法弹出view");
            self.frame = self.frameForHidden;
        }
            break;

        case PopViewStyleCustom:
        {
            self.frame = self.frameForHidden;
        }
            break;

        default:
            break;
    }

    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.backgroundView];
    [window addSubview:self];

    [UIView animateWithDuration:animationDuration delay:animationDelay usingSpringWithDamping:animationDamping initialSpringVelocity:animationVelocity options:UIViewAnimationOptionCurveEaseIn animations:^{
        switch (self.popViewStyle) {
            case PopViewStyleCenter:
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                break;

            case PopViewStyleFromBottom:
            case PopViewStyleCustom:
                self.frame = self.frameForShow;
                break;

            default:
                break;
        }

        self.backgroundView.backgroundColor = self.endColor;
    } completion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:animationDuration delay:animationDelay usingSpringWithDamping:animationDamping initialSpringVelocity:animationVelocity options:UIViewAnimationOptionCurveEaseIn animations:^{
        switch (self.popViewStyle) {
            case PopViewStyleCenter:
                self.transform = CGAffineTransformMakeScale(0.0, 0.0);
                break;

            case PopViewStyleFromBottom:
            case PopViewStyleCustom:
                self.frame = self.frameForHidden;

            default:
                break;
        }

        self.backgroundView.backgroundColor = self.startColor;
    } completion:^(BOOL complete){
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        if (complete && completion) {
            completion();
        }
    }];
}



#pragma mark - Action

- (void)tapBackgroundViewAction {
    [self dismissWithCompletion:nil];
}

@end
