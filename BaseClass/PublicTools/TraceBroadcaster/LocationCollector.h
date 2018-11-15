//
//  LocationCollector.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/3.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapPoint;
@class TransportLocation;

@interface LocationCollector : NSObject

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId;

- (void)collectPoint:(MapPoint *)point;
- (TransportLocation *)getLocation;

/// 重置数组（删除收集的坐标数据）
- (void)resetCollector;

@end
