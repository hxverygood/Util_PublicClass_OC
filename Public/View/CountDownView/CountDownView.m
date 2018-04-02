//
//  CountDownView.m
//  test_utils
//
//  Created by 韩啸 on 2018/3/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "CountDownView.h"
#import "CountDownButton.h"
#import "CountDownLabel.h"

@interface CountDownView()

@property (nonatomic, strong) CountDownButton *button;
@property (nonatomic, strong) CountDownLabel *label;

@property (nonatomic, assign) NSInteger setCountDownTime;
@property (nonatomic, assign) NSInteger count;

@end



@implementation CountDownView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
               buttonFontSize:(CGFloat)buttonFontSize
              buttonTextColor:(UIColor *)buttonTextColor
                labelFontSize:(CGFloat)labelFontSize
               labelTextColor:(UIColor *)labelTextColor
                countDownTime:(NSInteger)countDownTime {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.button = [[CountDownButton alloc] initWithFrame:frame title:buttonTitle fontSize:buttonFontSize buttonColor:buttonTextColor];
        [self.button addTarget:self action:@selector(countDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.label = [[CountDownLabel alloc] initWithFrame:frame fontSize:labelFontSize textColor:labelTextColor];
        [self addSubview:self.button];
        [self addSubview:self.label];
        
        self.setCountDownTime = countDownTime;
    }
    
    return self;
}



#pragma mark - Getter

- (NSInteger)currentCountdownTime {
    return self.count;
}



#pragma mark - Action

- (void)countDownButtonPressed:(UIButton *)sender {
    if (self.buttonPressed) {
        self.buttonPressed();
    }
}

- (void)timerStart {
    [self setupCodeButtonIsEnabled:NO];
    [self resetCountLabel];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    [timer fire];
}




#pragma mark - Func

- (void)setupCodeButtonIsEnabled:(BOOL)enable {
    _button.hidden = !enable;
    _button.enabled = enable;
    _label.hidden = enable;
}

- (void)countDownFromLastVC:(NSTimer *)timer {
    if (self.count == 0) {
        [timer invalidate];
        timer = nil;
        return;
    }
    _count -= 1;
}

- (void)countDown:(NSTimer *)timer {
    NSString *countingText = [NSString stringWithFormat:@"%ld秒后重新发送", (long)self.count];
    self.label.text = countingText;
    
    if (self.count == 0) {
        [timer invalidate];
        timer = nil;
        [self setupCodeButtonIsEnabled:YES];
        
        if (self.completeHandler) {
            self.completeHandler(YES);
        }
        
        return;
    }
    _count -= 1;
}

- (void)resetCountLabel {
    self.count = self.setCountDownTime;
    NSString *countingText = [NSString stringWithFormat:@"%ld秒后重新发送", (long)self.count];
    self.label.text = countingText;
}

@end
