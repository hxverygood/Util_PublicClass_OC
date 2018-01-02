//
//  HSGCDTimerManager.h
//  HSNewHoomdb
//
//  Created by hoomsun on 2017/8/2.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HSTimerBLock) (NSInteger count);

@interface HSGCDTimerManager : NSObject

// 时间间隔
@property(nonatomic,assign)NSTimeInterval  timeInterval;

-(instancetype)initWithgcdTimerManagerWithTimerCount:(NSInteger)timercOunt withTimeInterval:(NSTimeInterval)timeInterval;

// 开始计时
-(void)startTimerCompletion:(HSTimerBLock)block;

-(void)stopTimer;


// 挂起计时器(暂停)
-(void)suspenTimer;


// 或者启动计时器
-(void)resumeTimer;

@end
