//
//  CountDownView.h
//  test_utils
//
//  Created by 韩啸 on 2018/3/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownView : UIView

@property (nonatomic, assign, readonly) NSInteger currentCountdownTime;

@property (nonatomic, copy) void (^buttonPressed)(void);
@property (nonatomic, copy) void (^completeHandler)(BOOL countDownFinished);

- (instancetype)initWithFrame:(CGRect)frame
                  buttonTitle:(NSString *)buttonTitle
               buttonFontSize:(CGFloat)buttonFontSize
              buttonTextColor:(UIColor *)buttonTextColor
                labelFontSize:(CGFloat)labelFontSize
               labelTextColor:(UIColor *)labelTextColor
                countDownTime:(NSInteger)countDownTime;

- (void)timerStart;
- (void)timerStop;

@end
