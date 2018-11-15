//
//  TrackManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/22.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "TrackManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#define kAMapTrackServiceID  @"4584"

typedef NS_ENUM(NSInteger, TrackManagerType) {
    TrackManagerTypeUploadTrack,
    TrackManagerTypeQueryTrack
};



@interface TrackManager () <AMapTrackManagerDelegate> {
    BOOL _serviceStarted;
    BOOL _gatherStarted;
    BOOL _createTrackID;
}

@property (nonatomic, assign) TrackManagerType managerType;
@property (nonatomic, strong) AMapTrackManager *trackManager;
@property (nonatomic, copy) NSString *terminalID;
@property (nonatomic, copy) NSString *lieyingTrackID;
@property (nonatomic, assign) long long queryTrackStartTime;
@property (nonatomic, assign) long long queryTrackEndTime;

@end



@implementation TrackManager

#pragma mark - Initializer

//- (instancetype)initWithTerminalID:(NSUInteger)terminalID {
//    _terminalID = terminalID;
//
//    return [[TrackManager alloc] init];
//}


- (instancetype)init {
    self = [super init];

    if (self) {
        [self initTrackManager];
    }

    return self;
}

- (void)initTrackManager {
    AMapTrackManagerOptions *option = [[AMapTrackManagerOptions alloc] init];
    option.serviceID = kAMapTrackServiceID; //Service ID 需要根据需要进行修改

    //初始化AMapTrackManager
    self.trackManager = [[AMapTrackManager alloc] initWithOptions:option];
#if DEBUG
    self.trackManager.distanceFilter = 10.0;
#else
    self.trackManager.distanceFilter = 30.0;
#endif
    [self.trackManager changeGatherAndPackTimeInterval:5 packTimeInterval:20];
    self.trackManager.delegate = self;
    [self.trackManager setAllowsBackgroundLocationUpdates:YES];
    [self.trackManager setPausesLocationUpdatesAutomatically:NO];
}

- (void)dealloc {
    [self stopTrackService];
    self.trackManager.delegate = nil;
    self.trackManager = nil;
}




#pragma mark - Func

/* 开启轨迹服务 */
- (void)startUploadTrackServiceWithLieyingTrackID:(NSString *)lieyingTrackID {
    if (self.trackManager == nil) {
        return;
    }

    _managerType = TrackManagerTypeUploadTrack;

    _lieyingTrackID = lieyingTrackID;

    if (![TrackManager isBlankString:lieyingTrackID]) {
        GGLog(@"✅ 猎鹰轨迹 - 已存在 TrackID: %@", lieyingTrackID);
    }

    if (_serviceStarted == NO) {
        //查询终端是否存在
        NSString *userId = [LoginInfo savedLoginInfo].currentUser.ID;
        if (![TrackManager isBlankString:userId]) {
            AMapTrackQueryTerminalRequest *request = [[AMapTrackQueryTerminalRequest alloc] init];
            request.serviceID = self.trackManager.serviceID;
            request.terminalName = userId;
            [self.trackManager AMapTrackQueryTerminal:request];
        }
    } else {
//        [self.trackManager stopService];
    }
}

- (void)startTrackServiceWithTerminalID:(NSString *)terminalID {
    if ([TrackManager isBlankString:terminalID]) {
        return;
    }

    _terminalID = terminalID;

    //启动上报服务(service id)
    AMapTrackManagerServiceOption *serviceOption = [[AMapTrackManagerServiceOption alloc] init];
    serviceOption.terminalID = terminalID;//Terminal ID 需要根据需要进行修改
    GGLog(@"✅ 猎鹰轨迹 - 终端ID: %@", terminalID);
    [self.trackManager startServiceWithOptions:serviceOption];
}

/**
 查询轨迹信息

 @param lieyingTrackId 高德猎鹰轨迹ID
 */
- (void)queryTrackInfoWithLieyingTrackId:(NSString *)lieyingTrackId
                               startTime:(long long)startTime
                                 endTime:(long long)endTime {
    NSString *errorInfo = nil;
    NSString *userId = [LoginInfo savedLoginInfo].currentUser.ID;
    if ([TrackManager isBlankString:userId]) {
        errorInfo = @"userId为空，无法查询轨迹";
    }
    else if ([TrackManager isBlankString:lieyingTrackId]) {
        errorInfo = @"猎鹰ID为空，无法查询轨迹";
    }

    else if (startTime == 0) {
        errorInfo = @"查询起始时间为空，无法查询轨迹";
    }
    else if (endTime == 0) {
        errorInfo = @"查询终止时间为空，无法查询轨迹";
    }

    if (![TrackManager isBlankString:errorInfo]) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(trackManager:didFailWithMessage:)]) {
            [self.delegate trackManager:self didFailWithMessage:errorInfo];
        }
        return;
    }

    _managerType = TrackManagerTypeQueryTrack;
    _lieyingTrackID = lieyingTrackId;
    _queryTrackStartTime = startTime;
    _queryTrackEndTime = endTime;

    if (_serviceStarted == NO) {
        //查询终端是否存在
        if (![TrackManager isBlankString:userId]) {
            AMapTrackQueryTerminalRequest *request = [[AMapTrackQueryTerminalRequest alloc] init];
            request.serviceID = self.trackManager.serviceID;
            request.terminalName = userId;
            [self.trackManager AMapTrackQueryTerminal:request];
        }
    }
    else {
        // 查询Track信息
        AMapTrackQueryTrackInfoRequest *request = [[AMapTrackQueryTrackInfoRequest alloc] init];
        request.serviceID = kAMapTrackServiceID;
        request.terminalID = _terminalID;
        request.trackID = _lieyingTrackID;
        request.startTime = _queryTrackStartTime;
        request.endTime = _queryTrackEndTime;
        request.correctionMode = @"denoise=1,mapmatch=1,threshold=100,mode=driving";
        request.recoupMode = AMapTrackRecoupModeDriving;
        request.recoupGap = 500;
        request.pageSize = 999;
        [self.trackManager AMapTrackQueryTrackInfo:request];

        GGLog(@"猎鹰轨迹查询 - 参数: %@", [request modelToJSONObject]);
    }
}

- (void)stopTrackService {
//    [self.trackManager stopGaterAndPack];
    [self.trackManager stopService];
}



#pragma mark - AMapTrackManagerDelegate

#pragma mark 查询/添加终端ID
// 查询终端结果
- (void)onQueryTerminalDone:(AMapTrackQueryTerminalRequest *)request response:(AMapTrackQueryTerminalResponse *)response
{
    //查询成功
    if ([[response terminals] count] > 0) {
        // 查询到结果，使用 Terminal ID
        NSString *terminalID = [[[response terminals] firstObject] tid];
        [self startTrackServiceWithTerminalID:terminalID];
    }
    else {
        switch (_managerType) {
            case TrackManagerTypeUploadTrack:
            {
                //查询结果为空，创建新的terminal
                NSString *userId = [LoginInfo savedLoginInfo].currentUser.ID;
                if (![TrackManager isBlankString:userId]) {
                    AMapTrackAddTerminalRequest *addRequest = [[AMapTrackAddTerminalRequest alloc] init];
                    addRequest.serviceID = self.trackManager.serviceID;
                    addRequest.terminalName = userId;
                    [self.trackManager AMapTrackAddTerminal:addRequest];
                }
            }
                break;

            case TrackManagerTypeQueryTrack:
            {

            }
                break;

            default:
                break;
        }
    }
}

// 创建终端结果
- (void)onAddTerminalDone:(AMapTrackAddTerminalRequest *)request response:(AMapTrackAddTerminalResponse *)response {
    //创建terminal成功
    NSString *terminalID = [response terminalID];
    [self startTrackServiceWithTerminalID:terminalID];
}


#pragma mark 开启/关闭终端
//service 开启结果回调
- (void)onStartService:(AMapTrackErrorCode)errorCode {
    if (errorCode == AMapTrackErrorOK) {
        _serviceStarted = YES;

        if (_managerType == TrackManagerTypeUploadTrack) {
            //开始服务成功，继续开启收集上报
            if ([TrackManager isBlankString:_lieyingTrackID]) {
                AMapTrackAddTrackRequest *request = [[AMapTrackAddTrackRequest alloc] init];
                request.serviceID = self.trackManager.serviceID;
                request.terminalID = self.trackManager.terminalID;

                [_trackManager AMapTrackAddTrack:request];
            }
            else {
                _trackManager.trackID = _lieyingTrackID;
                [_trackManager startGatherAndPack];
            }
        }
        else if (_managerType == TrackManagerTypeQueryTrack) {
            // 查询Track信息
            AMapTrackQueryTrackInfoRequest *request = [[AMapTrackQueryTrackInfoRequest alloc] init];
            request.serviceID = kAMapTrackServiceID;
            request.terminalID = _terminalID;
            request.trackID = _lieyingTrackID;
            request.startTime = _queryTrackStartTime;
            request.endTime = _queryTrackEndTime;
            request.correctionMode = @"denoise=1,mapmatch=1,threshold=100,mode=driving";
            request.recoupMode = AMapTrackRecoupModeDriving;
            request.recoupGap = 500;
            request.pageSize = 999;
            [self.trackManager AMapTrackQueryTrackInfo:request];

            GGLog(@"猎鹰轨迹查询 - 参数: %@", [request modelToJSONObject]);
        }
    } else {
        // 开始服务失败
        _serviceStarted = NO;
        GGLog(@"❌ 开始轨迹服务失败");
    }
}

- (void)onStopService:(AMapTrackErrorCode)errorCode {
    _serviceStarted = NO;
    _gatherStarted = NO;

    GGLog(@"✅ 猎鹰轨迹 - onStopService: %ld", (long)errorCode);
}

#pragma mark 开启/关闭位置收集器
// gather 开启结果回调
- (void)onStartGatherAndPack:(AMapTrackErrorCode)errorCode {
    if (errorCode == AMapTrackErrorOK) {
        //开始采集成功
        _gatherStarted = YES;
        GGLog(@"✅ 猎鹰 - 开始采集轨迹");
    } else {
        //开始采集失败
        _gatherStarted = NO;
        GGLog(@"❌ 猎鹰 - 采集轨迹失败");
    }
}

/// 停止收集
- (void)onStopGatherAndPack:(AMapTrackErrorCode)errorCode {
    _gatherStarted = NO;

    GGLog(@"onStopGatherAndPack: %ld", (long)errorCode);
}


#pragma mark 添加轨迹ID
/// 添加trackID
- (void)onAddTrackDone:(AMapTrackAddTrackRequest *)request response:(AMapTrackAddTrackResponse *)response {
    GGLog(@"onAddTrackDone%@", response.formattedDescription);

    if (response.code == AMapTrackErrorOK) {
        //创建trackID成功，开始采集
        self.trackManager.trackID = response.trackID;
        _lieyingTrackID = response.trackID;

        if ([TrackManager isBlankString:response.trackID]) {
            GGLog(@"没有获取到 lieying_trackID");
        }
        else {
            GGLog(@"✅ 猎鹰轨迹 - TrackID: %@", response.trackID);
            [self.trackManager startGatherAndPack];

            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(trackManager:didReceiveLieYingTrackID:)]) {
                [self.delegate trackManager:self didReceiveLieYingTrackID:response.trackID];
            }
        }


    } else {
        //创建trackID失败
        GGLog(@"创建 trackID 失败");
    }
}


#pragma mark 查询轨迹信息
/* 查询轨迹信息 */
- (void)onQueryTrackInfoDone:(AMapTrackQueryTrackInfoRequest *)request response:(AMapTrackQueryTrackInfoResponse *)response {
//    NSLog(@"onQueryTrackInfoDone: %@", response.);

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(trackManager:queryTrackInfo:)]) {
        [self.delegate trackManager:self queryTrackInfo:response.tracks];
    }
}


#pragma mark 失败信息回调
// 错误回调
- (void)didFailWithError:(NSError *)error associatedRequest:(id)request {
    NSString *errorMessage = nil;

    if ([request isKindOfClass:[AMapTrackQueryTerminalRequest class]]) {
        // 查询参数错误
        errorMessage = @"查询终端编号时参数错误";
        GGLog(@"❌ 查询终端时参数错误");
    }
    else if ([request isKindOfClass:[AMapTrackAddTerminalRequest class]]) {
        // 创建terminal失败
        errorMessage = [NSString stringWithFormat:@"创建终端失败：%@,", error.localizedDescription];
        GGLog(@"❌ 创建 terminal 失败: %@", error.localizedDescription);
    }
    else if ([request isKindOfClass:[AMapTrackQueryTrackInfoRequest class]]) {
        errorMessage = [NSString stringWithFormat:@"查询轨迹数据失败：%@,", error.localizedDescription];
        GGLog(@"❌ 查询 TrackInfo 失败: %@", error.localizedDescription);
    }
    else {
        errorMessage = error.localizedDescription;
        GGLog(@"❌ 猎鹰error: %@", error.localizedDescription);
    }

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(trackManager:didFailWithMessage:)]) {
        [self.delegate trackManager:self didFailWithMessage:errorMessage];
    }
}




#pragma mark - Private Func

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
