//
//  HSGCDTimerManager.h
//  HSNewHoomdb
//
//  Created by hoomsun on 2017/8/2.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSGCDTimerManager;

typedef void(^HSTimerBLock) (NSInteger count);

@protocol HSGCDTimerManagerDelegate <NSObject>

- (void)timerStop:(HSGCDTimerManager *)timer;

@end

@interface HSGCDTimerManager : NSObject

// 时间间隔
@property(nonatomic,assign)NSTimeInterval  timeInterval;

@property (nonatomic, assign) id<HSGCDTimerManagerDelegate> delegate;

-(instancetype)initWithgcdTimerManagerWithTimerCount:(NSInteger)timercOunt withTimeInterval:(NSTimeInterval)timeInterval;

// 开始计时
-(void)startTimerCompletion:(HSTimerBLock)block;

-(void)stopTimer;


// 挂起计时器(暂停)
-(void)suspenTimer;


// 或者启动计时器
-(void)resumeTimer;

@end
