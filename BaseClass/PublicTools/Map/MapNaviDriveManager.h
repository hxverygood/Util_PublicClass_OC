//
//  MapNaviDriveManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

@class AMapNaviVehicleInfo;
@class AMapNaviPoint;

typedef NS_ENUM(NSInteger, VehicleType) {
    VehicleTypeCar = 0,
    VehicleTypeTruck
};



@protocol MapNaviDriveManagerDelegate <NSObject>

- (void)naviRoutes:(NSDictionary<NSNumber *, AMapNaviRoute *> *)naviRoutesDict;

@end



@interface MapNaviDriveManager : NSObject

@property (nonatomic, weak) id<MapNaviDriveManagerDelegate> delegate;

/// 计算货车导航路径
- (void)calculateTruckRouteWithVehicleId:(NSString *)vehicleId
                                    size:(CGFloat)size
                                   width:(CGFloat)width
                                  height:(CGFloat)height
                                  length:(CGFloat)length
                                  weight:(CGFloat)weight
                                    load:(CGFloat)load
                                axisNums:(CGFloat)axisNums
                              startPoint:(AMapNaviPoint *)startPoint
                                endPoint:(AMapNaviPoint *)endPoint
                               wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                          isEmulatorNavi:(BOOL)isEmulatorNavi;

/// 添加导航View
- (void)addNaviDriveViewInView:(UIView *)containerView
                        bounds:(CGRect)bounds;

@end
