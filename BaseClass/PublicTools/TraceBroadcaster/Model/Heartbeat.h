//
//  Heartbeat.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

//#import "Transport.h"
#import <Foundation/Foundation.h>

@class MapPoint;

@interface Heartbeat : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *token;
@property (nullable, nonatomic, copy) NSNumber *sequence;
@property (nullable, nonatomic, copy) MapPoint *location;

@end
