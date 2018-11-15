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
@class MapNaviDriveManager;

typedef NS_ENUM(NSInteger, VehicleType) {
    VehicleTypeCar = 0,
    VehicleTypeTruck
};



@protocol MapNaviDriveManagerDelegate <NSObject>

@optional

// 接收路径规划结果
- (void)didReceiveNaviRoutes:(NSDictionary<NSNumber *, AMapNaviRoute *> *)naviRoutesDict;

// 更新定位信息
- (void)updateNaviLocation:(AMapNaviLocation *)naviLocation;

// 开始导航按钮
- (void)needStartNavi:(BOOL)startNavi;

@end



@interface MapNaviDriveManager : NSObject

@property (nonatomic, strong) AMapNaviVehicleInfo *vehicleInfo;
@property (nonatomic, strong) NSArray<AMapNaviPoint *> *wayPoints;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
//@property (nonatomic, assign) BOOL needArriveDepot;
@property (nonatomic, weak) id<MapNaviDriveManagerDelegate> delegate;
/// 开启导航按钮
@property (nonatomic, strong) UIButton *startNaviButton;


#pragma mark - 路径规划

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

/// MapKit 显示货车路径规划
- (void)truckRoutePlanWithMapView:(MAMapView *)mapView
                       startPoint:(AMapNaviPoint *)startPoint
                         endPoint:(AMapNaviPoint *)endPoint
                        wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints;



#pragma mark - 导航相关

// 初始化
- (instancetype)initWithStartPoint:(AMapNaviPoint *)startPoint
                         wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                          endPoint:(AMapNaviPoint *)endPoint;

- (instancetype)initWithVehicleInfo:(AMapNaviVehicleInfo *)vehicleInfo
                         startPoint:(AMapNaviPoint *)startPoint
                          wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                           endPoint:(AMapNaviPoint *)endPoint;

- (void)destroy;

- (void)setStartPoint:(AMapNaviPoint *)startPoint
            wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
             endPoint:(AMapNaviPoint *)endPoint;

/// 添加导航View
- (void)addNaviDriveViewInView:(UIView *)containerView
                        bounds:(CGRect)bounds;

/// 路径规划
- (void)calculateRoute;

/// 开始导航
- (void)startNavi:(BOOL)start;


// 小车导航
- (void)naviCarWithVehicleId:(NSString *)vehicleId
                  startPoint:(AMapNaviPoint *)startPoint
              startPointName:(NSString *)startPointName
                    endPoint:(AMapNaviPoint *)endPoint
                endPointName:(NSString *)endPointName
                   wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
               wayPointNames:(NSArray<NSString *> *)wayPointNames;

- (void)presentCarRoutePlanVCWithVehicleId:(NSString *)vehicleId
                                startPoint:(AMapNaviPoint *)startPoint
                                 wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                                  endPoint:(AMapNaviPoint *)endPoint;

// 卡车导航
- (void)naviTruckWithVehicleId:(NSString *)vehicleId
                          size:(CGFloat)size
                         width:(CGFloat)width
                        height:(CGFloat)height
                        length:(CGFloat)length
                        weight:(CGFloat)weight
                          load:(CGFloat)load
                      axisNums:(CGFloat)axisNums
                    startPoint:(AMapNaviPoint *)startPoint
                startPointName:(NSString *)startPointName
                      endPoint:(AMapNaviPoint *)endPoint
                  endPointName:(NSString *)endPointName
                     wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                 wayPointNames:(NSArray<NSString *> *)wayPointNames;

@end
