//
//  TrackManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/22.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapTrackKit/AMapTrackKit.h>

@class TrackManager;

@protocol TrackManagerDelegate <NSObject>

@optional
/* 生成猎鹰TrackID时调用 */
- (void)trackManager:(TrackManager *)trackManager didReceiveLieYingTrackID:(NSString *)trackID;

/* 查询猎鹰服务器上存储的轨迹数据 */
- (void)trackManager:(TrackManager *)trackManager queryTrackInfo:(NSArray<AMapTrackBasicTrack *> *)tracks;

- (void)trackManager:(TrackManager *)trackManager didFailWithMessage:(NSString *)message;

@end



/// 高德猎鹰轨迹
@interface TrackManager : NSObject

@property (nonatomic, weak) id<TrackManagerDelegate> delegate;

//- (instancetype)initWithTerminalID:(NSUInteger)terminalID;
- (instancetype)init;
- (void)startUploadTrackServiceWithLieyingTrackID:(NSString *)lieyingTrackID;
- (void)stopTrackService;

/**
 查询轨迹信息

 @param lieyingTrackId 高德猎鹰轨迹ID（必填）
 @param startTime 开始时间（必填）
 @param endTime 结束时间（必填）
 */
- (void)queryTrackInfoWithLieyingTrackId:(NSString *)lieyingTrackId
                               startTime:(long long)startTime
                                 endTime:(long long)endTime;

@end
