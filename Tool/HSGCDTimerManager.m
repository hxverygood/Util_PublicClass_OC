//
//  HSGCDTimerManager.m
//  HSNewHoomdb
//
//  Created by hoomsun on 2017/8/2.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSGCDTimerManager.h"

@interface HSGCDTimerManager ()
{
    NSInteger timeout;
}

// timer
@property (nonatomic, strong) dispatch_source_t timer;

// 回掉
@property (nonatomic,copy) HSTimerBLock currentBlock;

@end

@implementation HSGCDTimerManager

-(instancetype)initWithgcdTimerManagerWithTimerCount:(NSInteger)timercOunt withTimeInterval:(NSTimeInterval)timeInterval
{
    self = [super init];
    if (self)
    {
        timeout = timercOunt;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),timeInterval*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^
                                          {
                                              
                                              timeout--;
                                              if(timeout<=0)
                                              { //倒计时结束，关闭
                                                  dispatch_source_cancel(_timer);
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                                     
                                                                     self.currentBlock(timeout);
                                                                     
                                                                 });
                                              }else{
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^
                                                                 {
                                                                     
                                                                     self.currentBlock(timeout);
                                                                     
                                                                 });
                                                  
                                              }
                                          });
        
    }
    return self;
}


// 开始计时
-(void)startTimerCompletion:(HSTimerBLock)block
{
    self.currentBlock = block;
    dispatch_resume(_timer);
    
}


// 挂起计时器(暂停)
-(void)suspenTimer
{
    dispatch_suspend(_timer);
}

// 或者启动计时器
-(void)resumeTimer
{
    dispatch_resume(_timer);
}

// 停止计时器
-(void)stopTimer
{
    dispatch_cancel(_timer);
}


@end
