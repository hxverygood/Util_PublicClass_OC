//
//  RoadTraceMessage.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transport.h"

static NSString *const HEARTBEAT = @"heartbeat";
static NSString *const ROADTRACE_TRANSPORT = @"roadtrace_transport";
static NSString *const ROADTRACE_STATE = @"roadtrace_state";
static NSString *const ROADTRACE_SUB_TRANSPORT = @"roadtrace_sub_transport";
static NSString *const ROADTRACE_LIEYING_TRACKID = @"roadtrace_lieying_trackId";

@interface RoadTraceMessage : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) id body;

@end
