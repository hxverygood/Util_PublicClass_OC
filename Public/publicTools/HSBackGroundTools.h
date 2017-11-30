//
//  HSBackGroundTools.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/11/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import "HSGCDTimerManager.h"

@interface HSBackGroundTools : NSObject

  //定位管理器
@property(nonatomic,strong) LocationManager * lcMaager;

/**
 实例对象

 @return <#return value description#>
 */
+(instancetype)shareTools;

/**
 开始计时
 */
-(void)startBackGroundTimer;


/**
 关闭计时器
 */
-(void)stopTimer;

@end
