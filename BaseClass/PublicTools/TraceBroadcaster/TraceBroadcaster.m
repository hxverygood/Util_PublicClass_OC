//
//  TraceBroadcaster.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "TraceBroadcaster.h"
#import "Transport.h"
#import "TrackState.h"
#import "TransportState.h"
#import "TransportStateForSend.h"
#import "RoadTraceMessage.h"
#import "ReceiveMessage.h"
#import "MapPoint.h"

#import "FLSocketManager.h"
#import "Heartbeat.h"
#import "GCDTimerManager.h"
#import "MapManager+Utils.h"
#import "LocationCollector.h"

#import "TrackManager.h"                                        // 高德猎鹰轨迹
#import "RoadTraceMessageForLieYing.h"
#import "LieYingTrackModel.h"                                   // 高德猎鹰轨迹Model



//static NSString *const TAG = @"ws:TraceBroadcaster";
#if DEBUG
static NSString *const SOCKET_PATH = @"wss://www.sdgwl.com:52424/roadtrace/trace";
//static NSString *const SOCKET_PATH = @"ws:www.shandiangou-app.com/roadtrace/trace";
#else
static NSString *const SOCKET_PATH = @"wss://www.shandiangou-app.com/roadtrace/trace";
#endif

static NSInteger const COLLECTLOCATION = 3;
static NSInteger const SENDLOCATIONS = 20;

#if DEBUG
static NSInteger const HEARTBEAT_LOOP = 20;
//static CGFloat   const MAX_DISTANCE = 10.0;
#else
static NSInteger const HEARTBEAT_LOOP = 20;
//static CGFloat   const MAX_DISTANCE = 30.0;
#endif

static NSInteger const CONNECTION_AGAIN_TRY_WAIT = 3;

//@interface TraceBroadcaster () <TrackManagerDelegate>
@interface TraceBroadcaster () <TrackManagerDelegate>

//@property (nonatomic, strong) MessageReceiver *receiver;
@property (nonatomic, assign) SocketState socketState;
@property (nonatomic, assign) NSUInteger recvSequence;
@property (nonatomic, assign) NSUInteger sendSequence;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *transportId;
@property (nonatomic, copy) NSString *trackId;
//@property (nonatomic, assign) NSInteger timer_loop;

@property (nonatomic, strong) GCDTimerManager *collectLocationTimer;
@property (nonatomic, strong) GCDTimerManager *sendLocationTimer;
@property (nonatomic, strong) GCDTimerManager *heartbeatTimer;
@property (nonatomic, strong) TransportLocation *transportLocation;
@property (nonatomic, strong) LocationCollector *locationCollector;
@property (nonatomic, strong) QSThreadSafeMutableArray *locations;

/* 高德猎鹰轨迹 */
//@property (nonatomic, strong) TrackManager *trackManager;
//@property (nonatomic, copy) NSString *lieyingTrackId;

@end



@implementation TraceBroadcaster

#pragma mark - Getter

- (SocketState)socketCurrentState {
    if (self.socket) {
        if (self.socketState == SocketStateIsOpening) {
            return SocketStateIsOpening;
        }

        switch (self.socket.fl_socketStatus) {
            case FLSocketStatusConnected:
            case FLSocketStatusReceived:
                self.socketState = SocketStateOpen;
                return SocketStateOpen;

            case FLSocketStatusFailed:
                self.socketState = SocketStateError;
                return SocketStateError;

            case FLSocketStatusClosedByUser:
            case FLSocketStatusClosedByServer:
                self.socketState = SocketStateClosed;
                return SocketStateClosed;
        }
    }
    else {
        return SocketStateClosed;
    }
}

- (LocationCollector *)locationCollector {
    if (!_locationCollector) {
        _locationCollector = [[LocationCollector alloc] initWithTransportId:_transportId trackId:_trackId];
    }
    return _locationCollector;
}

//- (TrackManager *)trackManager {
//    if (!_trackManager) {
//        _trackManager = [[TrackManager alloc] init];
//    }
//    return _trackManager;
//}

- (QSThreadSafeMutableArray *)locations {
    if (!_locations) {
        _locations = [QSThreadSafeMutableArray array];
    }
    return _locations;
}



//#pragma mark - Initializer

//+ (TraceBroadcaster *)shared {
//    static TraceBroadcaster *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (instance == nil) {
//            instance = [[TraceBroadcaster alloc] init];
//        }
//    });
//    return instance;
//}



#pragma mark - Web Socket Config

//- (void)startupWithTransportId:(NSString *)transportId
//                       trackId:(NSString *)trackId
//                lieyingTrackId:(NSString *)lieyingTrackId
//                    completion:(void (^)(BOOL connectSuccess))completion {

- (void)startupWithTransportId:(NSString *)transportId
                       trackId:(NSString *)trackId
                    completion:(void (^)(BOOL connectSuccess))completion {

//    _timer_loop = 0;
    _sendSequence = 0;
    _recvSequence = 0;
    _socketState = SocketStateClosed;

    _trackId = trackId;
    _transportId = transportId;
//    _lieyingTrackId = lieyingTrackId;

    if (APPDELEGATE.socketNeedClose == YES) {
        [self close];
        return;
    }

    __weak typeof(self) weakself = self;
    [self connSocket:^(BOOL connectSuccess) {
        if (APPDELEGATE.socketNeedClose == YES) {
            [weakself close];
        }

        if (completion) {
            completion(connectSuccess);
        }

//        weakself.trackManager.delegate = weakself;
//        [weakself.trackManager startUploadTrackServiceWithLieyingTrackID:weakself.lieyingTrackId];

        if (connectSuccess) {
            [weakself.collectLocationTimer stopTimer];

            if (!weakself.collectLocationTimer) {
                weakself.collectLocationTimer = [[GCDTimerManager alloc] initWithDelayTime:0.0 timeInterval:COLLECTLOCATION];
            }

//            [weakself.locations removeAllObjects];

            GGLog(@" ######### 启动 Location收集 定时器 ######### ");

            [weakself.collectLocationTimer startTimerCompletion:^(NSInteger count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (APPDELEGATE.socketNeedClose == YES) {
                        [weakself.collectLocationTimer stopTimer];
                        weakself.collectLocationTimer = nil;
                        return;
                    }

                    MapPoint *currentPoint = [[MapPoint alloc] init];
                    currentPoint.longitude = [NSNumber numberWithDouble:APPDELEGATE.mlongitude];
                    currentPoint.latitude = [NSNumber numberWithDouble:APPDELEGATE.mlatitude];
                    currentPoint.timestamp = [NSString getCurrentTimeStamp];

                    [weakself.locationCollector collectPoint:currentPoint];

//                    if (weakself.locations.count == 0) {
//                        [weakself.locations addObject:currentPoint];
//                    }
//                    else {
//                        MapPoint *lastPoint = weakself.locations.lastObject;
//                        CLLocationCoordinate2D last = CLLocationCoordinate2DMake(lastPoint.latitude.doubleValue, lastPoint.longitude.doubleValue);
//                        CLLocationCoordinate2D current = CLLocationCoordinate2DMake(currentPoint.latitude.doubleValue, currentPoint.longitude.doubleValue);
//                        double distance = [MapManager distanceBetweenPoint:last anotherPoint:current];
//
//                        // 距离大于5米才进行记录
//                        if (distance > MAX_DISTANCE) {
//                            [weakself.locations addObject:currentPoint];
//                        }
//                    }
                });
            }];

            [weakself.sendLocationTimer stopTimer];

            if (!weakself.sendLocationTimer) {
                weakself.sendLocationTimer = [[GCDTimerManager alloc] initWithDelayTime:0.0 timeInterval:SENDLOCATIONS];
            }

            GGLog(@" ~~~~~~~~~ 启动 发送Location 定时器 ~~~~~~~~~ ");
            [weakself.sendLocationTimer startTimerCompletion:^(NSInteger count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (APPDELEGATE.socketNeedClose == YES) {
                        [weakself.sendLocationTimer stopTimer];
                        weakself.sendLocationTimer = nil;
                        return;
                    }
//                    TransportLocation *transLocation = [[TransportLocation alloc] init];
//                    transLocation.transportId = weakself.transportId;
//                    transLocation.trackId = weakself.trackId;
//                    transLocation.locations = [weakself.locations copy];

                    TransportLocation *location = [weakself.locationCollector getLocation];
                    [weakself sendPoint:[location copy]];

//                    [weakself.locationCollector];
                });
            }];
        }
    }];
}

- (void)connSocket:(SocketConnectionBlock)completion {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (APPDELEGATE.socketNeedClose == YES) {
            [self close];
            return;
        }

        if (self.socketState == SocketStateIsOpening) {
            GGLog(@"socket正在尝试打开，请不要重复打开");
            return;
        }

        GGLog(@"准备开启socket链接");
        NSLog(@"🐴🐴🐴 websocket: %@", SOCKET_PATH);

        NSArray<NSString *> *callStacks = [NSThread callStackSymbols];
        NSArray<NSString *> *tmpCallStacks = nil;
        if (callStacks.count > 6) {
            tmpCallStacks = [callStacks subarrayWithRange:NSMakeRange(0, 6)];
        }
        else {
            tmpCallStacks = callStacks;
        }
        NSLog(@"－－－－－－ 调用栈 －－－－－－\n%@\n－－－－－－－－－－－－－－－－－－", tmpCallStacks);

        self.socketState = SocketStateIsOpening;

        weakself.socket = [FLSocketManager shareManager];
        [weakself.socket fl_open:SOCKET_PATH connect:^{
            GGLog(@"✅ Websocket连接成功");
            weakself.socketState = SocketStateOpen;

            // 配置
            [weakself configHeartbeat];

            if (completion) {
                completion(YES);
            }
        } receive:^(id message, FLSocketReceiveType type) {
            if (type == FLSocketReceiveTypeForMessage) {
                [weakself receive:message];
            }
            else if (type == FLSocketReceiveTypeForPong){
                GGLog(@"接收 Pong: \n%@", message);
            }
        } failure:^(NSError *error) {
            weakself.socketState = SocketStateError;
            GGLog(@"❌ Websocket连接失败");
            [HUD showInfoWithStatus:@"连接失败，请确保手机网络正常"];

            if (completion) {
                completion(NO);
            }
        }];
    });
}

- (void)close {
    if (_socket != nil) {

        TransportLocation *transLocation = [self.locationCollector getLocation];
        transLocation.transportId = _transportId;
        transLocation.trackId = _trackId;
        transLocation.locations = [_locations copy];
        transLocation.state = TRANSPORT_FINISHED;
        [self sendPoint:transLocation];

        // 停止定时器
        [self.heartbeatTimer stopTimer];
        self.heartbeatTimer = nil;
        [self.collectLocationTimer stopTimer];
        self.collectLocationTimer = nil;
        [self.sendLocationTimer stopTimer];
        self.sendLocationTimer = nil;
        GGLog(@"------- 停止3个定时器 -------");
//        NSLog(@"关闭心跳定时器");



//        __weak typeof(self) weakself = self;
//        [self.socket fl_close:^(NSInteger code, NSString *reason, BOOL wasClean) {
//            GGLog(@"----- Websocket关闭 -----：code = %ld, reason = %@", (long)code, reason);
//            weakself.recvSequence = 0;
//            weakself.sendSequence = 0;
//            weakself.socket = nil;
//            weakself.socketState = SocketStateClosed;
//        }];

        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.socket fl_close:^(NSInteger code, NSString *reason, BOOL wasClean) {
                GGLog(@"----- Websocket关闭 -----：code = %ld, reason = %@", (long)code, reason);
                weakself.recvSequence = 0;
                weakself.sendSequence = 0;
                weakself.socket = nil;
                weakself.socketState = SocketStateClosed;
            }];
        });
    }
    else {

        // 停止定时器
        [self.heartbeatTimer stopTimer];
        self.heartbeatTimer = nil;
        [self.collectLocationTimer stopTimer];
        self.collectLocationTimer = nil;
        [self.sendLocationTimer stopTimer];
        self.sendLocationTimer = nil;

        self.socketState = SocketStateClosed;
        _socket = nil;

        NSLog(@"关闭长连接时 websocket == nil，关闭3个定时器");
//        NSLog(@"关闭长连接时 websocket == nil，关闭心跳定时器");
    }
}



/// 配置心跳计时器，及重连机制
- (void)configHeartbeat {
    if (APPDELEGATE.socketNeedClose == YES) {
        [self close];
        return;
    }

    self.sendSequence = 0;
    self.recvSequence = 0;

    if (self.heartbeatTimer) {
        GGLog(@"~~~~~~~ 先停止 心跳 倒计时 ~~~~~~~~");
        [self.heartbeatTimer stopTimer];
        self.heartbeatTimer = nil;
    }

    if (!self.heartbeatTimer) {
        self.heartbeatTimer = [[GCDTimerManager alloc] initWithDelayTime:0.0 timerCount:HEARTBEAT_LOOP timeInterval:1.0 repeat:YES];
    }

    GGLog(@"~~~~~~~ 准备开启 心跳 倒计时 ~~~~~~~~");
    __weak typeof(self) weakself = self;
    [self.heartbeatTimer startTimerCompletion:^(NSInteger count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (APPDELEGATE.socketNeedClose == YES) {
                GGLog(@"~~~~~~~ 需要停止 心跳 倒计时 ~~~~~~~~");
                [weakself.heartbeatTimer stopTimer];
                weakself.heartbeatTimer = nil;
                return;
            }

            // 判断是否需要重连
            if(count % 3 == 0 &&
               (weakself.sendSequence - weakself.recvSequence) > CONNECTION_AGAIN_TRY_WAIT) {

                GGLog(@"~~~~~~~~ 心跳主动断开长连接 ~~~~~~~~");
                [weakself close];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (APPDELEGATE.socketNeedClose == NO) {
                        GGLog(@"``````` 心跳发起重连 ```````");
                        [weakself connSocket:nil];
                    }
                    else {
                        [weakself.heartbeatTimer stopTimer];
                        weakself.heartbeatTimer = nil;
                    }
                });
            }
            else if (count == 0) {
                [weakself sendHeartbeat];
                weakself.sendSequence += 1;
                //            dispatch_async(dispatch_get_main_queue(), ^{
                //                [weakself sendHeartbeat];
                //                self->_sendSequence += 1;
                //            });
            }
        });
    }];
}



#pragma mark - Socket Send And Receive Message

- (void)send:(NSString *)message {
    if (![NSString isBlankString:message]) {
        // 是否能够发送，由 FLSocketManager 真正发送的时候判断
        [[FLSocketManager shareManager] fl_send:message];
    }

//    if ((self.socket.fl_socketStatus == FLSocketStatusConnected ||
//         self.socket.fl_socketStatus == FLSocketStatusReceived) &&
//        ) {
//
//    }
//    else {
//        GGLog(@"ws连接失败或关闭，无法返送信息");
//    }
}

- (void)receive:(id)message {
    NSDictionary *dict = [(NSString *)message dictionaryWithJsonString];
    if (dict == nil) {
        return;
    }

    GGLog(@"\n---------- WEBSOCKET RECEIVE ----------\n%@\n", (NSString *)message);

    ReceiveMessage *receive = [[ReceiveMessage alloc] initWithDictionary:dict error:nil];
    if (receive.errcode.integerValue != 0) {

    }
    else {
        if (receive.result) {
            if (receive.result.sequence) {
                _recvSequence = receive.result.sequence.unsignedIntegerValue;
            }
        }
    }
}



#pragma mark - Public Func

/// 发送心跳
- (void)sendHeartbeat {

//    if (_socketState == SocketStateClosed ||
//        _socketState == SocketStateError) {
//        [self connSocket:nil];
//        return;
//    }

    if (APPDELEGATE.socketNeedClose == YES) {
        [self.heartbeatTimer stopTimer];
        self.heartbeatTimer = nil;
        return;
    }

    MapPoint *point = [[MapPoint alloc] init];
    NSNumber *longitude = [NSNumber numberWithDouble:APPDELEGATE.mlongitude];
    NSNumber *latitude = [NSNumber numberWithDouble:APPDELEGATE.mlatitude];
    point.longitude = longitude;
    point.latitude = latitude;
    point.timestamp = [NSString getCurrentTimeStamp];

    Heartbeat *heartbeat = [[Heartbeat alloc] init];
    heartbeat.location = point;
    heartbeat.sequence = [NSNumber numberWithUnsignedInteger:_sendSequence];
//    heartbeat.transportId = _transportId;
//    heartbeat.trackId = _trackId;

    RoadTraceMessage *message = [[RoadTraceMessage alloc] init];
    message.type = HEARTBEAT;
    message.body = heartbeat;

    NSString *messageStr = [message modelToJSONString];
    GGLog(@"\n---------- WEBSOCKET HEARTBEAT ----------\n%@\n", messageStr);
    [self send:messageStr];
}

/// 发送坐标点
- (void)sendPoint:(TransportLocation *)location {
    if (!_socket) {
        [self close];
        return;
    }

//    if (_socketState == SocketStateClosed ||
//        _socketState == SocketStateError) {
//        [self connSocket:nil];
//        return;
//    }

    if (location.locations.count == 0) {
        return;
    }

    RoadTraceMessage *message = [[RoadTraceMessage alloc] init];
    message.type = ROADTRACE_TRANSPORT;
    message.body = [location copy];

    NSString *messageStr = [message modelToJSONString];
    GGLog(@"\n++++++++++ WEBSOCKET LOC ++++++++++\n%@\n", messageStr);

    if (self.socket.fl_socketStatus == FLSocketStatusConnected ||
        self.socket.fl_socketStatus == FLSocketStatusReceived) {
        [self send:messageStr];
        [self.locationCollector resetCollector];
    }

}

/// 发送状态
- (void)sendState:(TransportState *)state {
    if (!_socket) {
        [self close];
        return;
    }

    if ([NSString isBlankString:state.state]) {
        return;
    }

//    if (_socketState == SocketStateClosed ||
//        _socketState == SocketStateError) {
//        [self connSocket:nil];
//        return;
//    }

    MapPoint *location = [[MapPoint alloc] init];
    location.latitude = state.location.latitude;
    location.longitude = state.location.longitude;
    location.timestamp = state.location.timestamp;

    TransportStateForSend *stateForSend = [[TransportStateForSend alloc] init];
    stateForSend.transportId = state.transportId;
    stateForSend.trackId = state.trackId;
    stateForSend.state = state.state;
    stateForSend.address = state.address;
    stateForSend.location = location;
    stateForSend.timestamp = state.timestamp;

    RoadTraceMessage *message = [[RoadTraceMessage alloc] init];
    message.type = ROADTRACE_STATE;
    message.body = stateForSend;

    NSString *messageStr = [message modelToJSONString];
    GGLog(@"\n✅ 发送状态：%@\n", stateForSend.state);
    GGLog(@"\n++++++++++ WEBSOCKET SEND STATE ++++++++++\n%@\n", messageStr);
    [self send:messageStr];
}



//#pragma mark - Lieying TrackManager

/* 停止高德猎鹰轨迹manager */
//- (void)stopTrackManager {
//    // 停止高德猎鹰轨迹上报服务
//    [self.trackManager stopTrackService];
//    self.trackManager.delegate = nil;
//    self.trackManager = nil;
//}

//- (void)sendLieYingTrackID:(NSString *)lieYingTrackID {
//    if (![NSString isBlankString:lieYingTrackID]) {
//        if (![NSString isBlankString:_trackId]) {
//            LieYingTrackModel *trackModel = [[LieYingTrackModel alloc] init];
//            trackModel.trackId = _trackId;
//            trackModel.lieyingTrackId = lieYingTrackID.unsignedIntegerValue;
//
//            RoadTraceMessageForLieYing *message = [[RoadTraceMessageForLieYing alloc] init];
//            message.type = ROADTRACE_LIEYING_TRACKID;
//            message.body = trackModel;
//
//            NSString *messageStr = [message modelToJSONString];
//
//            GGLog(@"\n✅ 发送猎鹰TrackID：%ld\n", trackModel.lieyingTrackId);
//            GGLog(@"\n+++++++ WEBSOCKET SEND LIEYING_TRACKID ++++++++\n%@\n", messageStr);
//            [self send:messageStr];
//        }
//        else {
//            GGLog(@"❌ 出车单ID为空，无法上传 lieyingTrackId");
//        }
//    }
//    else {
//        GGLog(@"❌ 猎鹰 trackID 为空，无法上传至服务器");
//    }
//}

//- (void)trackManager:(TrackManager *)trackManager didReceiveLieYingTrackID:(NSString *)trackID {
//    [self sendLieYingTrackID:trackID];
//}

@end
