//
//  GCDTimerManager.h
//  Copyright © 2017年. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDTimerManager;

typedef void(^TimerBLock) (NSInteger count);

@protocol GCDTimerManagerDelegate <NSObject>

- (void)timerStop:(GCDTimerManager *)timer;

@end



@interface GCDTimerManager : NSObject

// 时间间隔
@property(nonatomic, assign) NSTimeInterval  timeInterval;
@property(nonatomic, assign) id<GCDTimerManagerDelegate> delegate;

/// 初始化无限循环倒计时器
- (instancetype)initWithDelayTime:(NSInteger)delayTime
                     timeInterval:(NSTimeInterval)timeInterval;

- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval;

// 是否重复执行
- (instancetype)initWithDelayTime:(NSInteger)delayTime
                       timerCount:(NSInteger)timerCount
                     timeInterval:(NSTimeInterval)timeInterval
                           repeat:(BOOL)repeat;

// 开始计时
- (void)startTimerCompletion:(TimerBLock)block;
// 停止定时器
- (void)stopTimer;
// 挂起计时器(暂停)
- (void)suspendTimer;
// 继续计时器
- (void)resumeTimer;

@end
