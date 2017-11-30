//
//  HSBackGroundTools.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/11/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBackGroundTools.h"


// 剩余最小时间
#define remainingSecond 30

// 预估时间
#define expectSecond 120

@implementation HSBackGroundTools
{
    // 计时器
    HSGCDTimerManager * bgTimer;
    
}


/**
实例对象

@return <#return value description#>
*/
+(instancetype)shareTools
{
    HSBackGroundTools * tools = [[HSBackGroundTools alloc] init];
    return tools;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        bgTimer = [[HSGCDTimerManager alloc] initWithgcdTimerManagerWithTimerCount:expectSecond];
        _lcMaager = [LocationManager sharedManager];
    }
    return self;
}


/**
 开始计时
 */
-(void)startBackGroundTimer
{
    [bgTimer startTimerCompletion:^(NSInteger count)
    {
        NSLog(@"==剩余时间%ld==",count);
        if (count == remainingSecond)
        {
            // 重新定位
        
        }
    }];
}


/**
 关闭计时器
 */
-(void)stopTimer
{
    [bgTimer stopTimer];
}

@end
