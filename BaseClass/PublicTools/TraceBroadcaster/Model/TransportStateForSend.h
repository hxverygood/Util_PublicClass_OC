//
//  TransportStateForSend.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "Transport.h"
#import "MapPoint.h"

@interface TransportStateForSend : Transport

/// 当前坐标
@property (nonatomic, copy) MapPoint *location;
/// 当前时间
@property (nonatomic, copy) NSString *timestamp;

@end
