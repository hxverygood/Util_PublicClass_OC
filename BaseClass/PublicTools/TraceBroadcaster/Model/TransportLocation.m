//
//  TransportLocation.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "TransportLocation.h"
#import "MapPoint.h"

@implementation TransportLocation

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId {
    self = [super init];
    if (self) {
        self.transportId = transportId;
        self.trackId = trackId;
    }
    return self;
}

@end
