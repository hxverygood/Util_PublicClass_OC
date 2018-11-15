//
//  TraceBroadcaster.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportLocation.h"

@class Transport;
@class FLSocketManager;



typedef NS_ENUM(NSInteger, SocketState) {
    SocketStateClosed,
    SocketStateIsOpening,           // socket正在打开
    SocketStateOpen,
    SocketStateError
};


typedef void (^SocketConnectionBlock)(BOOL connectSuccess);


@interface TraceBroadcaster : NSObject

@property (nonatomic, strong) FLSocketManager *socket;
@property (nonatomic, assign, readonly) SocketState socketCurrentState;

//+ (TraceBroadcaster *)shared;

- (void)startupWithTransportId:(NSString *)transportId
                       trackId:(NSString *)trackId
                    completion:(void (^)(BOOL connectSuccess))completion;

//- (void)startupWithTransportId:(NSString *)transportId
//                       trackId:(NSString *)trackId
//                lieyingTrackId:(NSString *)lieyingTrackId
//                    completion:(void (^)(BOOL connectSuccess))completion;

- (void)close;

/* 停止高德猎鹰轨迹manager */
//- (void)stopTrackManager;

/// 发送坐标点
//- (void)sendPoint:(TransportLocation *)location;
/// 发送状态
- (void)sendState:(__kindof Transport *)state;

@end
