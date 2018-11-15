//
//  TransportLocation.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "Transport.h"


static NSString *const TRANSPORT_DEPORT = @"arrived";
static NSString *const TRANSPORT_RUNNING = @"running";
static NSString *const TRANSPORT_FINISHED = @"finished";


@class MapPoint;

@protocol MapPoint
@end


@interface TransportLocation : Transport

//@property (nonatomic, copy) NSString<Optional> *sequence;
//@property (nonatomic, copy) NSString<Optional> *transportId;
//@property (nonatomic, copy) NSString<Optional> *trackId;
//@property (nonatomic, copy) NSString<Optional> *state;
@property (nonatomic, copy) NSArray<MapPoint *><Optional, MapPoint> *locations;
@property (nonatomic, copy) NSNumber *sequence;

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId;



@end
