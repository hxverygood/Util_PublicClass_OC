//
//  HSCountDownButton.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/4/23.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HSCountDownButton.h"

@interface HSCountDownButton ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger originCount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CountDownStatus countDownStatusInside;

@end



@implementation HSCountDownButton

#pragma mark - Getter

- (NSTimer *)timer {
    if (!_timer) {
        _count = _originCount;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (CountDownStatus)countDownStatus {
    return _countDownStatusInside;
}

- (NSInteger)remainCount {
    return _count;
}



#pragma mark -

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.countDownStatusInside = CountDownTimerIsIdle;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.countDownStatusInside = CountDownTimerIsIdle;
}



#pragma mark - Public Func

- (void)setTitle:(NSString *)title
 backgroundColor:(UIColor *)backgroundColor
           count:(NSInteger)count {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    _bgColor = backgroundColor;
    _originCount = count > 0 ? count : 60;
}

- (void)timerStart {
    if (_countDownStatusInside == CountDownTimerIsCounting) {
        NSLog(@"倒数按钮已经在计时中，请勿重复点击");
        return;
    }
    [self.timer fire];
    
    if (self.statusBlock) {
        self.statusBlock(CountDownTimerIsCounting);
    }
    _countDownStatusInside = CountDownTimerIsCounting;
}

- (void)showCountDownStatus {
    if (_countDownStatusInside == CountDownIsShow) {
        NSLog(@"按钮已经显示为倒数状态");
        return;
    }
    
    if (_count == 0) {
        return;
    }
    else {
        [self setupCodeButtonIsEnabled:NO];
    }
}

//- (void)hideCountDownStatus {
//    [self setupCodeButtonIsEnabled:YES];
//}



#pragma mark - Private Func

- (void)countDown {
    if (self.count == 0) {
        [self timerStop];
//        [self setupCodeButtonIsEnabled:YES];
        
        return;
    }
    
    if (_countDownStatusInside == CountDownIsShow) {
        [self setCountDownTitleWithText:self.count];
    }
    
    _count -= 1;
}

- (void)timerStop {
    [self.timer invalidate];
    _timer = nil;
    
    self.countDownStatusInside = CountDownTimerIsIdle;
    
    if (self.statusBlock) {
        self.statusBlock(CountDownTimerIsIdle);
    }
}

- (void)setupCodeButtonIsEnabled:(BOOL)enable {
    self.enabled = enable;
    if (enable) {
        [self setTitle:self.title forState:UIControlStateNormal];
        self.backgroundColor = _bgColor;
        _countDownStatusInside = CountDownIsHidden;
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        _countDownStatusInside = CountDownIsShow;
    }
}

- (void)setCountDownTitleWithText:(NSInteger)count {
    NSString *countingText = [NSString stringWithFormat:@"%lds后重新认证", count];
    self.titleLabel.text = countingText;
    [self setTitle:countingText forState:UIControlStateNormal];
}

@end
