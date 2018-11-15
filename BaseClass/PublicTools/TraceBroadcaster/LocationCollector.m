//
//  LocationCollector.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/3.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "LocationCollector.h"
#import "MapManager+Utils.h"
#import "MapPoint.h"
#import "TransportLocation.h"

static NSString *const kTransportLocationFileName = @"transportLocation";
#if DEBUG
static CGFloat   const MAX_DISTANCE = 10.0;
#else
static CGFloat   const MAX_DISTANCE = 30.0;
#endif



@interface LocationCollector ()

@property (nonatomic, copy) NSString *transportId;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, assign) NSUInteger sequence;
@property (nonatomic, copy) MapPoint *lastPoint;
@property (nonatomic, strong) QSThreadSafeMutableArray *locations;

@end



@implementation LocationCollector

#pragma mark - Getter

- (QSThreadSafeMutableArray *)locations {
    if (!_locations) {
        _locations = [QSThreadSafeMutableArray array];
    }
    return _locations;
}



#pragma mark - Initializer

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId {
    self = [super init];
    if (self) {
        self.transportId = transportId;
        self.trackId = trackId;

        TransportLocation *savedLocation = [LocationCollector savedLocation];
        if (![savedLocation.trackId isEqualToString:trackId] ||
            ![savedLocation.transportId isEqualToString:transportId]) {
            [LocationCollector removeFile];
        }
        self.sequence = savedLocation.sequence.unsignedIntegerValue;

    }
    return self;
}



#pragma mark - Func

- (void)collectPoint:(MapPoint *)point {
    if (!point) {
        return;
    }

    // 如果坐标没有值，则不存储
    if (point.latitude == nil ||
        point.latitude.doubleValue == 0.0 ||
        point.longitude == nil ||
        point.longitude.doubleValue == 0.0) {
        return;
    }

    if (_lastPoint == nil) {
        [self.locations addObject:point];
        _lastPoint = point;
        return;
    }

    CLLocationCoordinate2D last = CLLocationCoordinate2DMake(_lastPoint.latitude.doubleValue, _lastPoint.longitude.doubleValue);
    CLLocationCoordinate2D current = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
    double distance = [MapManager distanceBetweenPoint:last anotherPoint:current];

    // 距离大于10米才进行记录
    if (distance > MAX_DISTANCE) {
        [self.locations addObject:point];
        _lastPoint = point;
    }
}

- (TransportLocation *)getLocation {
    if (_locations && _locations.count > 0) {
        TransportLocation *location = [[TransportLocation alloc] initWithTransportId:_transportId trackId:_trackId];
        _sequence += 1;

        location.sequence = [NSNumber numberWithUnsignedInteger:_sequence];
        location.locations = [_locations copy];
        if (_sequence == 1) {
            location.state = TRANSPORT_DEPORT;
        }
        else {
            location.state = TRANSPORT_RUNNING;
        }

        [LocationCollector saveFileWithLocation:location];

        return location;
    }

    return nil;
}

/// 重置数组（删除收集的坐标数据）
- (void)resetCollector {
    [self.locations removeAllObjects];
    [LocationCollector removeFile];
}



#pragma mark - Private Func

+ (void)saveFileWithLocation:(TransportLocation *)location {
    NSString *path = [self pathForName:kTransportLocationFileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:location];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
}

+ (TransportLocation *)savedLocation {
    NSString *path = [self pathForName:kTransportLocationFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[TransportLocation class]]) {
        return obj;
    } else {
        return nil;
    }
}

+ (void)removeFile {
    NSString *path = [self pathForName:kTransportLocationFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array[0] stringByAppendingPathComponent:name];
}

@end
