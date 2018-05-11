//
//  HSCountDownButton.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/4/23.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HSBaseButton.h"

typedef NS_ENUM(NSInteger, CountDownStatus) {
    CountDownTimerIsIdle,
    CountDownTimerIsCounting,
    CountDownIsShow,
    CountDownIsHidden
};



@interface HSCountDownButton : HSBaseButton

@property (nonatomic, assign, readonly) CountDownStatus countDownStatus;
@property (nonatomic, assign, readonly) NSInteger remainCount;
@property (nonatomic, copy) void (^statusBlock)(CountDownStatus status);

- (void)setTitle:(NSString *)title
 backgroundColor:(UIColor *)backgroundColor
           count:(NSInteger)count;

- (void)timerStart;
//- (void)timerStop;
- (void)showCountDownStatus;
- (void)setupCodeButtonIsEnabled:(BOOL)enable;
//- (void)hideCountDownStatus;

@end
