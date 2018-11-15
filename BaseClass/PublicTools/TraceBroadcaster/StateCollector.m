//
//  StateCollector.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "StateCollector.h"
#import "MapPoint.h"
#import "TraceBroadcaster.h"
#import "GCDTimerManager.h"                                         // 计时器
#import "MapManager+Utils.h"

static NSString *const kTransportStateFileName = @"transportState";
static NSString *const kTransportState_trackId = @"transportState_trackId";


#if DEBUG
#warning fix: state collector radius
static CGFloat const DISTANCE_RADIUS = 200.0;
static NSInteger const STATE_WAIT_LOOP = 10;                    // 状态上报间隔10秒
#else
#warning fix: state collector radius
static CGFloat const DISTANCE_RADIUS = 1000.0;
static NSInteger const STATE_WAIT_LOOP = 20;                    // 状态上报间隔20秒
#endif
static NSInteger const MAX_DELAY_TIME = 6*60*60;                // 签到最长持续6小时

@interface StateCollector ()

@property (nonatomic, copy) NSString *transportId;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, copy) NSString *runningTrackId;
//@property (nonatomic, copy) NSString *lieyingTrackId;
@property (nonatomic, copy) NSArray<MapPoint *> *points;
@property (nonatomic, copy) NSString *currentState;
@property (nonatomic, assign) NSInteger arriveTransportTime;
@property (nonatomic, assign) NSInteger finishTime;
@property (nonatomic, assign) BOOL isBackDepot;

//@property (nonatomic, strong) TransportState *savedState;
@property (nonatomic, strong) TraceBroadcaster *broadcaster;
//@property (nonatomic, assign) BOOL isStartup;

@property (nonatomic, strong) GCDTimerManager *timer;

@end



@implementation StateCollector

#pragma mark - Getter

//- (TransportState *)savedState {
//    return [StateCollector savedTransportState];
//}

- (TraceBroadcaster *)broadcaster {
    if (!_broadcaster) {
        _broadcaster = [[TraceBroadcaster alloc] init];
    }
    return _broadcaster;
}


#pragma mark - Initializer

//- (instancetype)initWithTransportId:(NSString *)transportId
//                            trackId:(NSString *)trackId
//                             points:(NSArray<MapPoint *> *)points
//                       currentState:(NSString *)currentState {
//    self = [super init];
//    if (self) {
//        TransportState *state = [StateCollector savedTransportState];
//        if (state == nil) {
//
//        }
//        else {
//
//        }
//
//        self.transportId = transportId;
//        self.trackId = trackId;
//        self.points = points;
//        self.currentState = BEGIN_TRANSPORT_TRACER;
//        self.arriveTransportTime = [NSString getCurrentTimeStamp].integerValue;
//        self.isBackDepot = NO;
//
//        if ([NSString isBlankString:currentState]) {
//            self.currentState = BEGIN_TRANSPORT_TRACER;
//        }
//        else {
//            self.currentState = currentState;
//        }
//    }
//    return self;
//}

//- (instancetype)initWithTransportId:(NSString *)transportId
//                            trackId:(NSString *)trackId
//                     lieyingTrackId:(NSString *)lieyingTrackId
//                             points:(NSArray<MapPoint *> *)points
//              currentTransportState:(NSString *)currentTransportState
//                    arriveDepotTime:(NSString *)arriveDepotTime
//                         finishTime:(NSString *)finishTime {

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId
                             points:(NSArray<MapPoint *> *)points
              currentTransportState:(NSString *)currentTransportState
                    arriveDepotTime:(NSString *)arriveDepotTime
                         finishTime:(NSString *)finishTime {
    self = [super init];
    if (self) {
//        if ([StateCollector transportStateFileIsOutOfDate]) {
//            self.currentState = BEGIN_TRANSPORT_TRACER;
//        }
//        else {
//            TransportState *savedState = [StateCollector savedTransportState];
//            if (![savedState.trackId isEqualToString:trackId]) {
//                return nil;
//            }
//            else {
//                NSString *state = savedState.state;
//                self.currentState = [NSString isBlankString:state] ? nil : state;
//            }
//        }

        self.currentState = [NSString isBlankString:currentTransportState] ? BEGIN_TRANSPORT_TRACER : currentTransportState;
        self.transportId = transportId;
        self.trackId = trackId;
//        self.lieyingTrackId = lieyingTrackId;
        self.points = points;
        self.isBackDepot = NO;
        self.arriveTransportTime = [self convertToTimestampStringWithFormatDateString:arriveDepotTime] * 1000;
        self.finishTime = [self convertToTimestampStringWithFormatDateString:finishTime] * 1000;

        APPDELEGATE.socketNeedClose = NO;
    }
    return self;
}



#pragma mark - Func

/// 比较trackId是否和之前的一致
//+ (CollectorStateOption)stateCollectorStateWithTrackId:(NSString *)trackId {
//    [StateCollector deleteOutOfDateTransportStateFile];
//
//    TransportState *state = [StateCollector savedTransportState];
//    if (state) {
//        if ([state.trackId isEqualToString:trackId]) {
//            return CollectorStateOptionCanStartOldMission;
//        }
//        else {
//            return CollectorStateOptionTrackIdIsNotSame;
//        }
//    }
//    else {
//        // 如果状态文件不存在，则可以进行新的任务
//        return CollectorStateOptionCanStartNewMission;
//    }
//}

- (void)startup {
    if ([NSString isBlankString:_transportId] ||
        [NSString isBlankString:_trackId]) {
        GGLog(@"transportId 或 trackId 为空，无法收集运行状态和定位信息");
        return;
    }

    APPDELEGATE.socketNeedClose = NO;

    [_timer stopTimer];

    if ([self.currentState isEqualToString:FINISHED_TRANSPORT]) {
        [self stop];
        return;
    }

    if (!_timer) {
        _timer = [[GCDTimerManager alloc] initWithDelayTime:0.0 timeInterval:STATE_WAIT_LOOP];
    }

    GGLog(@" ^^^^^^^ 启动 stateCollector 定时器^^^^^^^ ");
    
    __weak typeof(self) weakself = self;
    [_timer startTimerCompletion:^(NSInteger count) {
        if (APPDELEGATE.socketNeedClose == YES) {
            [weakself.timer stopTimer];
            weakself.timer = nil;
        }

        TransportState *newState = [weakself getState];

        // 如果是已经完成状态，则停止状态收集器和长连接
        if ([weakself.currentState isEqualToString:FINISHED_TRANSPORT]) {
            [weakself stop];
            return;
        }

        // 如果是开始运输状态，则什么也不做
        if ([newState.state containsString:BEGIN_TRANSPORT_TRACER]) {
            return;
        }

//        // 自动到仓开启长连接
//        if ([newState.state containsString:AUTO_ARRIVAL_DEPORT]) {
//            // 开启socket
//            if (weakself.broadcaster.socketCurrentState == SocketStateClosed ||
//                weakself.broadcaster.socketCurrentState == SocketStateError) {
//
//                [weakself.broadcaster close];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [weakself.broadcaster startupWithTransportId:weakself.transportId trackId:weakself.trackId completion:^(BOOL connectSuccess) {
//                        if (connectSuccess) {
//                            weakself.currentState = newState.state;
//                            [weakself.broadcaster sendState:newState];
//                            [StateCollector saveTransportState:newState];
//                        }
//                    }];
//                });
//
//                return;
//            }
//        }
//        else {
//
//        }

        // 开启socket
        if (weakself.broadcaster.socketCurrentState == SocketStateClosed ||
            weakself.broadcaster.socketCurrentState == SocketStateError) {

            [weakself.broadcaster close];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakself.broadcaster startupWithTransportId:weakself.transportId trackId:weakself.trackId lieyingTrackId:weakself.lieyingTrackId completion:^(BOOL connectSuccess) {

                if (APPDELEGATE.socketNeedClose == YES) {
                    [weakself.timer stopTimer];
                    weakself.timer = nil;
                    return;
                }

                 [weakself.broadcaster startupWithTransportId:weakself.transportId trackId:weakself.trackId completion:^(BOOL connectSuccess) {
                    if (connectSuccess) {
                        if ([NSString isBlankString:newState.state] ||
                            [newState.state containsString:BEGIN_TRANSPORT_TRACER]) {
                            return;
                        }

                        if (![newState.state isEqualToString:weakself.currentState]) {

                            // 如果当前是出发状态，新的状态如果不是"自动到仓"或"手动到仓"，则不向服务器发送状态
                            if ([weakself.currentState isEqualToString:BEGIN_TRANSPORT_TRACER] &&
                                (![newState.state isEqualToString:AUTO_ARRIVAL_DEPORT] ||
                                 ![newState.state isEqualToString:ARRIVAL_DEPORT])) {
                                return;
                            }

                            [weakself.broadcaster sendState:newState];
                            weakself.currentState = newState.state;
                        }

                        NSInteger currentTime = [NSString getCurrentTimeStamp].integerValue/1000;
                        if (weakself.finishTime > 0 && (currentTime > weakself.finishTime) &&
                            (currentTime > (weakself.finishTime + MAX_DELAY_TIME))) {
                            [self.broadcaster close];
                            [weakself stop];
                        }
                    }
                }];
            });

            return;
        }


        if (![newState.state isEqualToString:weakself.currentState]) {

            // 开启socket
            if (weakself.broadcaster.socketCurrentState == SocketStateClosed ||
                weakself.broadcaster.socketCurrentState == SocketStateError) {

//                [weakself.broadcaster startupWithTransportId:weakself.transportId trackId:weakself.trackId lieyingTrackId:weakself.lieyingTrackId completion:^(BOOL connectSuccess) {
                [weakself.broadcaster startupWithTransportId:weakself.transportId trackId:weakself.trackId completion:^(BOOL connectSuccess) {
                    if (connectSuccess) {
//                        [StateCollector saveTransportState:newState];
                         weakself.currentState = newState.state;
                        [weakself.broadcaster sendState:newState];
                    }
                }];


//                if ([newState.state isEqualToString:ARRIVAL_DEPORT]
//                    ) {
//                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(stateCollector:updateState:)]) {
//                        [weakself.delegate stateCollector:weakself updateState:ARRIVAL_DEPORT];
//                    }
//
//                    return;
//                }
            }
            else {
//                [StateCollector saveTransportState:newState];
                [weakself.broadcaster sendState:newState];
                weakself.currentState = newState.state;
            }
        }

        NSInteger currentTime = [NSString getCurrentTimeStamp].integerValue/1000;
        if (weakself.finishTime > 0 && (currentTime > weakself.finishTime) &&
            (currentTime > (weakself.finishTime + MAX_DELAY_TIME))) {
//            [StateCollector deleteOutOfDateTransportStateFile];
            [self.broadcaster close];
            [weakself stop];
        }
    }];
}

- (void)stop {
    APPDELEGATE.socketNeedClose = YES;
    [_broadcaster close];
//    [_broadcaster stopTrackManager];
    [_timer stopTimer];
    _timer = nil;
}

- (CollectorArriveOrFinishOption)stateForStartOrFinishMission {
//    [StateCollector deleteOutOfDateTransportStateFile];

    NSInteger currentTime = [NSString getCurrentTimeStamp].integerValue;
    // 如果提前1小时以上到仓，则不可签到
    if (_arriveTransportTime == 0) {
        return CollectorArriveOrFinishOptionTimeError;
    }
    else if ((currentTime < _arriveTransportTime) &&
        ((_arriveTransportTime - currentTime)/1000/60 > 120)) {
        // 到仓前2小时可签到
        return CollectorArriveOrFinishOptionStartTimeNotArrive;
    }

    // 如果到仓时间超过2小时，则不可签到
    if (_finishTime == 0) {
        return CollectorArriveOrFinishOptionTimeError;
    }
    else if ((_arriveTransportTime < currentTime) &&
         (currentTime < _finishTime)  &&
         (currentTime - _arriveTransportTime)/1000 > 1*60*60){
        TransportState *state = [self getState];
        if ([state.state isEqualToString:BEGIN_TRANSPORT_TRACER] ||
            [state.state isEqualToString:AUTO_ARRIVAL_DEPORT]) {
            return CollectorArriveOrFinishOptionExceedStartTime;
        }
    }
    else if ((currentTime > _finishTime) &&
             (currentTime - _finishTime)/1000 > MAX_DELAY_TIME) {
        return CollectorArriveOrFinishOptionExceedFinishTime;
    }

    return CollectorArriveOrFinishOptionNormal;
}

- (NSString *)getCurrentState {
    return _currentState;
}

/// 手动到仓
- (void)arriveDepotWithTrackId:(NSString *)trackId
                    completion:(void (^)(BOOL impSuccess))completion {
    GGLog(@"********* 手动到仓签到 *********");
    [self sendStateWithTrackId:trackId state:ARRIVAL_DEPORT completion:completion];
}

// 离仓签到
- (void)leaveDepotWithTrackId:(NSString *)trackId
                   completion:(void (^)(BOOL impSuccess))completion {
    GGLog(@"********* 手动离仓签到 *********");
    [self sendStateWithTrackId:trackId state:LEAVED_DEPORT completion:completion];
}

/// 手动配送完成
- (void)finishTransportWithTrackId:(NSString *)trackId
                        completion:(void (^)(BOOL impSuccess))completion {
    GGLog(@"********* 配送任务完成 *********");
    [self sendStateWithTrackId:trackId state:FINISHED_TRANSPORT completion:completion];
}

- (void)sendStateWithTrackId:(NSString *)trackId
                       state:(NSString *)state
                  completion:(void (^)(BOOL impSuccess))completion {
    if (![trackId isEqualToString:_trackId]) {
        [HUD showInfoWithStatus:@"您有正在执行的任务，无法进行配送完成操作"];
        return;
    }

    if (self.broadcaster.socketCurrentState == SocketStateClosed) {
        [HUD showInfoWithStatus:@"连接已关闭，请稍后再试"];
        if (completion) {
            completion(NO);
        }

        return;
    }
    else if (self.broadcaster.socketCurrentState == SocketStateError) {
        [HUD showInfoWithStatus:@"连接错误，请稍后再试"];
        if (completion) {
            completion(NO);
        }

        return;
    }
    else if (self.broadcaster.socketCurrentState == SocketStateIsOpening) {
        [HUD showInfoWithStatus:@"正在打开连接，请稍后再试"];
        if (completion) {
            completion(NO);
        }

        return;
    }

    [self setStateWithState:state];

    if (completion) {
        completion(YES);
    }
}




#pragma mark - Private Func

/// 获取到仓、离仓状态
- (TransportState *)getState {
    if (APPDELEGATE.mlatitude < 1  &&
        APPDELEGATE.mlongitude < 1) {
        GGLog(@"坐标信息不正确，无法获取状态信息");
        return nil;
    }
    MapPoint *currentPoint = [[MapPoint alloc] init];
    currentPoint.longitude = [NSNumber numberWithDouble:APPDELEGATE.mlongitude];
    currentPoint.latitude = [NSNumber numberWithDouble:APPDELEGATE.mlatitude];

    return [self getStateWithPoint:currentPoint];
}

/// 获取到仓、离仓状态
- (TransportState *)getStateWithPoint:(MapPoint *)point {
//- (TransportState *)getStateWithTrackId:(NSString *)trackId
//                                  point:(MapPoint *)point {

//    if (![trackId isEqualToString:_trackId]) {
//        NSLog(@"track isn't matched");
//    }


//    MapPoint *currentPoint = [[MapPoint alloc] init];
//    currentPoint.longitude = [NSNumber numberWithDouble:APPDELEGATE.mlongitude];
//    currentPoint.latitude = [NSNumber numberWithDouble:APPDELEGATE.mlatitude];


    NSString *transState = nil;

    if ([_currentState isEqualToString:FINISHED_TRANSPORT]) {
        transState = FINISHED_TRANSPORT;
    }

    if ([self inDeport:point]) {
        if ([_currentState isEqualToString:BEGIN_TRANSPORT_TRACER]) {
            transState = AUTO_ARRIVAL_DEPORT;
            GGLog(@"******* 自动到仓 *******");
        }
//        else if ([_currentState isEqualToString:ARRIVAL_DEPORT]) {
////            GGLog(@"******* 到仓 *******");
//            transState = ARRIVAL_DEPORT;
//        }
//        else if ([_currentState isEqualToString:LEAVED_TRANSPORT]) {
//            transState = BACKED_DEPORT;
//        }
    }
    // 手动离仓，不使用自动离仓
//    else if (![self inDeport:point] &&
//             ([_currentState isEqualToString:AUTO_ARRIVAL_DEPORT] ||
//              [_currentState isEqualToString:ARRIVAL_DEPORT] ||
//              [_currentState isEqualToString:BACKED_DEPORT])) {
//        transState = LEAVED_DEPORT;
//        GGLog(@"******* 离仓 *******");
//    }
    else if ([self inTransportPoint:point]) {
        if ([_currentState isEqualToString:LEAVED_DEPORT] ||
            [_currentState isEqualToString:LEAVED_TRANSPORT]) {
            transState = ARRIVAL_TRANSPORT;
            GGLog(@"------- 到达途经点 -------");
        }
    }
    else if (![self inTransportPoint:point]) {
        if ([_currentState isEqualToString:ARRIVAL_TRANSPORT]) {
            transState = LEAVED_TRANSPORT;
            GGLog(@"------- 离开途经点 -------");
        }
    }

    NSString *address = APPDELEGATE.mAddress;
    MapPoint *location = [[MapPoint alloc] init];
    location.latitude = [point.latitude copy];
    location.longitude = [point.longitude copy];
    location.timestamp = [location.timestamp copy];

    TransportState *state = [[TransportState alloc] init];
    state.transportId = _transportId;
    state.trackId = _trackId;
    state.state = transState ? : _currentState;
    state.address = address;
    state.location = location;
    state.arriveTransportTime = [NSString stringWithFormat:@"%ld", (long)_arriveTransportTime];
    state.finishTime = [NSString stringWithFormat:@"%ld", (long)_finishTime];
    state.timestamp = [NSString getCurrentTimeStamp];

    return state;
}

/// 设置到离仓状态
- (TransportState *)setStateWithState:(NSString *)state {
//    if (trackId != _trackId) {
//        NSLog(@"setState: trackId不一致");
//        return nil;
//    }

    NSString *address = APPDELEGATE.mAddress;
    MapPoint *currentPoint = [[MapPoint alloc] init];
    currentPoint.longitude = [NSNumber numberWithDouble:APPDELEGATE.mlongitude];
    currentPoint.latitude = [NSNumber numberWithDouble:APPDELEGATE.mlatitude];

    TransportState *newState = [[TransportState alloc] init];
    newState.transportId = _transportId;
    newState.trackId = _trackId;
    newState.address = address;
    newState.state = state;
    newState.location = currentPoint;

    if(![_currentState isEqualToString:state]) {
        if ([state isEqualToString:ARRIVAL_DEPORT]) {
            if ([self inDeport:currentPoint] &&
                ([_currentState isEqualToString:BEGIN_TRANSPORT_TRACER] ||
                 [_currentState isEqualToString:AUTO_ARRIVAL_DEPORT])) {
                    _currentState = state;
            }
        }
        else if ([state isEqualToString:LEAVED_DEPORT]) {
            _currentState = state;
        }
        else if ([state isEqualToString:BACKED_DEPORT]) {
            if ([self inDeport:currentPoint] &&
                [_currentState isEqualToString:LEAVED_TRANSPORT]) {
                _currentState = state;
            }
        }
        else if ([state isEqualToString:FINISHED_TRANSPORT]) {
            if (_isBackDepot && ![_currentState isEqualToString:BACKED_DEPORT]) {

            }
            else if (!_isBackDepot && ![_currentState isEqualToString:LEAVED_TRANSPORT]) {

            }
            _currentState = state;
//            else if ([_currentState isEqualToString:LEAVED_TRANSPORT] ||
//                [_currentState isEqualToString:BACKED_DEPORT]) {
//                 _currentState = state;
//#warning fix: test
////                broadcaster.disattachTransportCollector();
//                [[TraceBroadcaster shared] close];
//            }
        }
        else {
            GGLog(@"state isn't supported to set");
            return nil;
        }

        newState.state = state;
        newState.arriveTransportTime = [NSString stringWithFormat:@"%ld", (long)_arriveTransportTime];
        newState.finishTime = [NSString stringWithFormat:@"%ld", (long)_finishTime];
        newState.timestamp = [NSString getCurrentTimeStamp];
//        [StateCollector saveTransportState:newState];

        [self.broadcaster sendState:newState];
    }

    return newState;
}


/// 是否到仓
- (BOOL)inDeport:(MapPoint *)point {
    if (_points.count == 0) {
        return NO;
    }

    if (point.longitude.doubleValue <= 0.0 ||
        point.latitude.doubleValue <= 0.0) {
        return NO;
    }

    CLLocationCoordinate2D pointOne = CLLocationCoordinate2DMake(_points[0].latitude.doubleValue, _points[0].longitude.doubleValue);
    CLLocationCoordinate2D pointTwo = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
    double distance = [MapManager distanceBetweenPoint:pointOne anotherPoint:pointTwo];

    return distance < DISTANCE_RADIUS;
}


/// 是否到达途经点
- (BOOL)inTransportPoint:(MapPoint *)point {
    for (int i = 1; i < _points.count; i++) {
        MapPoint *mapPoint = _points[i];
        CLLocationCoordinate2D pointOne = CLLocationCoordinate2DMake(mapPoint.latitude.doubleValue, mapPoint.longitude.doubleValue);
        CLLocationCoordinate2D pointTwo = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
        double distance = [MapManager distanceBetweenPoint:pointOne anotherPoint:pointTwo];
        if (distance < DISTANCE_RADIUS) {
            return YES;
        }
    }
    return NO;
}

// 判断是否到达终点
- (BOOL)inFinalPoint:(MapPoint *)point {
    if (_points.count == 0) {
        return NO;
    }

    if (point.longitude.doubleValue <= 0.0 ||
        point.latitude.doubleValue <= 0.0) {
        return NO;
    }

    NSInteger lastIndex = _points.count - 1;
    CLLocationCoordinate2D pointOne = CLLocationCoordinate2DMake(_points[lastIndex].latitude.doubleValue, _points[lastIndex].longitude.doubleValue);
    CLLocationCoordinate2D pointTwo = CLLocationCoordinate2DMake(point.latitude.doubleValue, point.longitude.doubleValue);
    double distance = [MapManager distanceBetweenPoint:pointOne anotherPoint:pointTwo];

    return distance < DISTANCE_RADIUS;
}


- (NSUInteger)convertToTimestampStringWithFormatDateString:(NSString *)formatDateString {
//#warning fix: timpstamp length
    NSString *timestampStr = nil;
    if ([formatDateString containsString:@"-"]) {
        timestampStr = [NSString convertToTimestampStringFromFormatString:formatDateString separator:@"-"];
        return timestampStr.unsignedIntegerValue;
    }
    else if ([formatDateString containsString:@"."]) {
        timestampStr = [NSString convertToTimestampStringFromFormatString:formatDateString separator:@"."];
        return timestampStr.unsignedIntegerValue;
    }
    else if ([formatDateString convertToNumber]) {
        timestampStr = [NSString convertToTimestampStringFromFormatString:formatDateString separator:@""];
        return timestampStr.unsignedIntegerValue;
    }
    else {
        return 0;
    }
}



#pragma mark - Save and Read TransportStateFile

///// 保存运输状态
//+ (void)saveTransportState:(TransportState *)transportState {
//    NSString *trackId = transportState.trackId;
//
//    if ([NSString isBlankString:trackId]) {
//        GGLog(@"trackId为空，无法保存运输状态");
//        return;
//    }
//
////    NSString *filePath = [NSString stringWithFormat:@"%@_%@+%@", kTransportStateFileBaseName, trackId, [NSString getCurrentTimeStamp]];
//    NSString *path = [self pathForName:kTransportStateFileName];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:transportState];
//    if (data) {
//        __unused BOOL success = [data writeToFile:path atomically:YES];
//        GGLog(@"✅ %@ 保存 %@: %@", kTransportStateFileName, transportState.state, success ? @"成功" : @"失败");
//
//        TransportState *savedState = [StateCollector savedTransportState];
//        GGLog(@"✅ %@ 保存后的状态 %@", kTransportStateFileName, savedState.state);
//    }
//}
//
///// 读取运输状态
//+ (TransportState *)savedTransportState {
//    NSString *path = [self pathForName:kTransportStateFileName];
//    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    if ([obj isKindOfClass:[TransportState class]]) {
//        TransportState *state = (TransportState *)obj;
//        return [state copy];
//    } else {
//        return nil;
//    }
//}
//
///// 判断运输状态文件是否过期（相对于到仓时间是否过去了6小时）
//+ (BOOL)transportStateFileIsOutOfDate {
//    TransportState *state = [StateCollector savedTransportState];
//    if (state) {
//        if ([NSString isBlankString:state.arriveTransportTime] ||
//            [NSString isBlankString:state.finishTime]) {
//            [StateCollector removeSavedTransportStateFile];
//            return YES;
//        }
//        else {
//            NSString *currentTimestampStr = [NSString getCurrentTimeStamp];
//            NSInteger currentTimestamp = currentTimestampStr.integerValue;
//            NSInteger finishTimestamp = state.finishTime.integerValue;
//
//            if ((currentTimestamp - finishTimestamp)/1000 >= MAX_DELAY_TIME) {
//                [StateCollector removeSavedTransportStateFile];
//                return YES;
//            }
//            else {
//                return NO;
//            }
//        }
//    }
//    else {
//        return YES;
//    }
//}
//
//+ (void)deleteOutOfDateTransportStateFile {
//    TransportState *state = [StateCollector savedTransportState];
//
//    if (state) {
//        if ([NSString isBlankString:state.arriveTransportTime] ||
//            [NSString isBlankString:state.finishTime]) {
//            [StateCollector removeSavedTransportStateFile];
//        }
//        else {
//            NSString *currentTimestampStr = [NSString getCurrentTimeStamp];
//            NSInteger currentTimestamp = currentTimestampStr.integerValue;
//            NSInteger finishTimestamp = state.finishTime.integerValue;
//
//            if ((currentTimestamp - finishTimestamp)/1000 >= MAX_DELAY_TIME) {
//                [StateCollector removeSavedTransportStateFile];
//            }
//        }
//    }
//}

//+ (void)removeSavedTransportStateFilleWithTrackId:(NSString *)trackId {
//    if ([NSString isBlankString:trackId]) {
//        return;
//    }
//
//    NSArray *fileNames = [StateCollector findAllFileInLibraryDirectory];
//    if (fileNames.count == 0) {
//        return;
//    }
//
//    for (NSString *fileName in fileNames) {
//        if ([fileName hasPrefix:kTransportStateFileName] &&
//            [fileName containsString:trackId]) {
//            NSString *path = [self pathForName:fileName];
//            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
//            if (exist) {
//                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//            }
//        }
//    }
//}


/// 删除保存的运输状态文件
+ (void)removeSavedTransportStateFile {
    NSString *path = [self pathForName:kTransportStateFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        GGLog(@"⛰xxxxxxxxxx 删除 轨迹状态 文件 xxxxxxxxxx ⛰");
    }
}

/// 根据部分文件名查找文件
//+ (NSString *)findFileNameForPartialName:(NSString *)partialName {
//    NSArray *fileNames = [StateCollector findAllFileInLibraryDirectory];
//    if (fileNames.count == 0) {
//        return nil;
//    }
//
//    NSString *fileName = nil;
//    for (NSString *fileNameStr in fileNames) {
//        if ([fileNameStr hasPrefix:kTransportStateFileName] &&
//            [fileNameStr containsString:partialName]) {
//            fileName = fileNameStr;
//            break;
//        }
//    }
//
//    return fileName;
//}

/// 查找 Library 目录下的所有文件
+ (NSArray *)findAllFileInLibraryDirectory {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [fileManager contentsOfDirectoryAtPath:pathArray[0] error:&error];

    return fileList;
}

+ (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *path = [array[0] stringByAppendingPathComponent:@"Lighting Dog"];
//    path = [path stringByAppendingPathComponent:name];

    NSString *path = [array[0] stringByAppendingPathComponent:name];
    return path;
}


///// 保存当前正在进行的运输单编号
//+ (void)saveTrackId:(NSString *)trackId {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:trackId.integerValue forKey:kTransportState_trackId];
//    [userDefaults synchronize];
//}
//
///// 读取保存的正在进行的运输单编号
//+ (NSInteger)savedTrackId {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger trackId = [userDefaults integerForKey:kTransportState_trackId];
//    return trackId;
//}
//
///// 删除正在进行的出车单信息 trackId
//+ (void)deleteTrackId {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:kTransportState_trackId];
//    [userDefaults synchronize];
//}

@end
