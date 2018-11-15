//
//  StateCollector.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportState.h"

@class MapPoint;
@class StateCollector;



//typedef NS_ENUM(NSInteger, CollectorStateOption) {
//    CollectorStateOptionCanStartNewMission,
//    CollectorStateOptionCanStartOldMission,
//    CollectorStateOptionTrackIdIsNotSame,
//};

typedef NS_ENUM(NSInteger, CollectorArriveOrFinishOption) {
    CollectorArriveOrFinishOptionStartTimeNotArrive,    // 任务时间没到（1小时之内方可签到）
    CollectorArriveOrFinishOptionExceedStartTime,       // 任务开始时间超过2小时，不可签到
    CollectorArriveOrFinishOptionExceedFinishTime,      // 超过了任务结束时间
    CollectorArriveOrFinishOptionNotInArea,             // 如果没有在签到区域内
    CollectorArriveOrFinishOptionNormal,                // 状态正常
    CollectorArriveOrFinishOptionTimeError              // 时间异常
};



@protocol StateCollectorDelegate <NSObject>

@optional
- (void)stateCollector:(StateCollector *)stateCollector
           updateState:(NSString *)state;

@end



@interface StateCollector : NSObject

@property (nonatomic, weak) id<StateCollectorDelegate> delegate;

// 判断是否可以收集并上报轨迹
//+ (CollectorStateOption)stateCollectorStateWithTrackId:(NSString *)trackId;

///// 读取运输状态
//+ (TransportState *)savedTransportState;
//
///// 删除保存的运输状态文件
//+ (void)removeSavedTransportStateFile;
//
///// 之前保存的运输状态是否过期(从任务开始时间开始后推6小时)
//+ (BOOL)transportStateFileIsOutOfDate;



//- (instancetype)initWithTransportId:(NSString *)transportId
//                            trackId:(NSString *)trackId
//                     lieyingTrackId:(NSString *)lieyingTrackId
//                             points:(NSArray<MapPoint *> *)points
//              currentTransportState:(NSString *)currentTransportState
//                    arriveDepotTime:(NSString *)arriveDepotTime
//                         finishTime:(NSString *)finishTime;

- (instancetype)initWithTransportId:(NSString *)transportId
                            trackId:(NSString *)trackId
                             points:(NSArray<MapPoint *> *)points
              currentTransportState:(NSString *)currentTransportState
                    arriveDepotTime:(NSString *)arriveDepotTime
                         finishTime:(NSString *)finishTim;

/// 是否可以进行 签到、完成 操作
- (CollectorArriveOrFinishOption)stateForStartOrFinishMission;

//- (instancetype)initWithTransportId:(NSString *)transportId
//                            trackId:(NSString *)trackId
//                             points:(NSArray<MapPoint *> *)points
//                       currentState:(NSString *)currentState;

- (void)startup;
- (void)stop;

// 判断是否到仓
- (BOOL)inDeport:(MapPoint *)point;

// 判断是否到达终点
- (BOOL)inFinalPoint:(MapPoint *)point;

//- (TransportState *)setStateWithTrackId:(NSString *)trackId
//                                  state:(NSString *)state;


- (NSString *)getCurrentState;
/// 获取到仓、离仓状态
- (TransportState *)getStateWithPoint:(MapPoint *)point;
/// 获取到离仓状态
//- (TransportState *)getStateWithTrackId:(NSString *)trackId
//                                  point:(MapPoint *)point;


/**
 手动到仓

 @param trackId 出车单ID
 @param completion 操作是否成功的回调
 */
- (void)arriveDepotWithTrackId:(NSString *)trackId
                    completion:(void (^)(BOOL impSuccess))completion;

/**
 手动离仓签到

 @param trackId 出车单ID
 @param completion 操作是否成功的回调
 */
- (void)leaveDepotWithTrackId:(NSString *)trackId
                   completion:(void (^)(BOOL impSuccess))completion;

/**
 手动配送完成

 @param trackId 出车单ID
 @param completion 操作是否成功的回调
 */
- (void)finishTransportWithTrackId:(NSString *)trackId
                        completion:(void (^)(BOOL impSuccess))completion;

@end
