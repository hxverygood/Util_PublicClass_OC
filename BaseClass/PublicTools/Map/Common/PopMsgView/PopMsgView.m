//
//  PopMsgView.m
//  DevDemoNavi
//
//  Created by eidan on 2018/1/25.
//  Copyright © 2018年 Amap. All rights reserved.
//

#import "PopMsgView.h"

@interface PopMsgView()

@property (nonatomic ,strong) UILabel *messageLabel;
@property (nonatomic ,strong) NSTimer *myTimer;
@property (nonatomic, strong) TimerTarget *timerTarget;

@end

@implementation PopMsgView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    self.layer.cornerRadius = 5;
    [self addSubview:self.messageLabel];
}

- (void)dealloc {
    [self.myTimer invalidate];
    self.myTimer = nil;
}

#pragma mark - Interface

- (void)showMsg:(NSString *)msg inThe:(UIView *)parentView {
    if ([msg isKindOfClass:[NSString class]] && msg.length) {
        
        self.messageLabel.text = msg;
        CGSize textSize = [self widthWithText:msg size:CGSizeMake(280, 80) font:self.messageLabel.font];
        
        //default
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
        
        CGFloat offset = 10;
        self.messageLabel.frame = CGRectMake(offset, offset, textSize.width, textSize.height);
        self.frame = CGRectMake((parentView.bounds.size.width - (textSize.width + 2 * offset)) / 2, 50, textSize.width + 2 * offset, textSize.height + 2 * offset);
        [parentView addSubview:self];
        
        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
        
        self.timerTarget = [[TimerTarget alloc] init];
        self.timerTarget.realTarget = self;  //破掉循环引用
        
        [self.myTimer invalidate];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self.timerTarget selector:@selector(animationFade) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
        
    }
}

#pragma mari - Utility

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (CGSize)widthWithText:(NSString *)str size:(CGSize)size font:(UIFont *)font {
    
    if (![str isKindOfClass:[NSString class]] || str.length == 0) {
        return CGSizeZero;
    }
    
    return [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
}

- (void)animationFade {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [self.myTimer invalidate];
        [self removeFromSuperview];
    }];
}

@end

#pragma mark - TimerTarget

@implementation TimerTarget

- (void)animationFade {
    [self.realTarget performSelector:@selector(animationFade) withObject:nil];
}


@end
