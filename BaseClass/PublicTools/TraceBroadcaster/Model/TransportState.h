//
//  TransportState.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "Transport.h"
#import "MapPoint.h"

static NSString *const BEGIN_TRANSPORT_TRACER = @"transportTrace";
static NSString *const AUTO_ARRIVAL_DEPORT = @"autoArrivalDepot";
static NSString *const ARRIVAL_DEPORT = @"arrivalDepot";
static NSString *const LEAVED_DEPORT = @"leavedDepot";
static NSString *const ARRIVAL_TRANSPORT = @"arrivalTransport";
static NSString *const LEAVED_TRANSPORT = @"leavedTransport";
static NSString *const FINISHED_TRANSPORT = @"finishedTransport";
static NSString *const BACKED_DEPORT = @"backedDeport";


@interface TransportState : Transport <NSCopying, NSCoding>

/// 当前坐标
@property (nonatomic, strong) MapPoint *location;
/// 当前时间
@property (nonatomic, copy) NSString *timestamp;
/// 任务开始时间
@property (nonatomic, copy) NSString *arriveTransportTime;
/// 任务完成时间
@property (nonatomic, copy) NSString *finishTime;

@end
