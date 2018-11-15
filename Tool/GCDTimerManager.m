//
//  GCDTimerManager.m
//  Copyright © 2017年. All rights reserved.
//

#import "GCDTimerManager.h"

@interface GCDTimerManager () {
    NSInteger timeoutReserved;
    NSInteger timeout;
    NSInteger count;
}

// timer
@property (nonatomic, strong) dispatch_source_t timer;

// 回掉
@property (nonatomic,copy) TimerBLock currentBlock;
// 是否循环
@property (nonatomic, assign) BOOL isRepeat;

@end

@implementation GCDTimerManager

/// 初始化无限循环倒计时器
- (instancetype)initWithDelayTime:(NSInteger)delayTime
                     timeInterval:(NSTimeInterval)timeInterval {
    return [[GCDTimerManager alloc] initWithDelayTime:delayTime timerCount:0 timeInterval:timeInterval repeat:YES];
}

- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval {
    return [[GCDTimerManager alloc] initWithDelayTime:delayTime timerCount:timerCount timeInterval:timeInterval repeat:NO];
}

- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval
                           repeat:(BOOL)repeat {
    self = [super init];
    if (self) {
        timeoutReserved = timerCount;
        timeout = timerCount;

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, delayTime), timeInterval * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if (timerCount != 0) {
                self.currentBlock(self->timeout);

                if (self->timeout == 0 &&
                    repeat == NO) {
                    // 不需要循环时倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.delegate && [self.delegate respondsToSelector:@selector(timerStop:)]) {
                            [self.delegate timerStop:self];
                        }
                    });
                    NSLog(@"倒计时停止");
                    return;
                }

                self->timeout -= 1;

                if(self->timeout < 0) {
                    if (repeat) {
                        // 需要循环时计数器重置
                        self->timeout = self->timeoutReserved;
                    }
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"倒计时：%ld", self->timeout);
//                    self.currentBlock(self->timeout);
//                });
            }
            else {
                // 如果是无限循环模式
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"无限循环timer");
                    self->count += 1;
                    self.currentBlock(self->count);
                });
            }
        });

    }
    return self;
}


// 开始计时
- (void)startTimerCompletion:(void(^)(NSInteger count))block {
    if (block) {
        self.currentBlock = block;
        if (_timer) {
            dispatch_resume(_timer);
        }
    }
}


// 挂起计时器(暂停)
- (void)suspendTimer {
    dispatch_suspend(_timer);
}

// 继续倒计时
- (void)resumeTimer {
    dispatch_resume(_timer);
}

// 停止计时器
- (void)stopTimer {
    dispatch_cancel(_timer);
    NSLog(@"倒计时停止");
}


@end
