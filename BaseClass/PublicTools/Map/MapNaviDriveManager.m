//
//  MapNaviDriveManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapNaviDriveManager.h"

@interface MapNaviDriveManager () <AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) AMapNaviVehicleInfo *vehicleInfo;
/// 是否开启模拟导航
@property (nonatomic, assign) BOOL isEmulatorNavi;

@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, weak) UIView *containerView;

@end



@implementation MapNaviDriveManager

#pragma mark - Getter

- (AMapNaviDriveView *)driveView {
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] init];
    }
    return _driveView;
}



#pragma mark -

- (void)dealloc {
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:_driveView];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];

    BOOL success = [AMapNaviDriveManager destroyInstance];
    NSLog(@"AMapNaviDriveManager 单例是否销毁: %d",success);
}



#pragma mark - Navi Drive View

/// 添加导航View
- (void)addNaviDriveViewInView:(UIView *)containerView
                        bounds:(CGRect)bounds {
    self.containerView = containerView;

    CGRect driveViewBounds = bounds;
    driveViewBounds.origin.x = 0.0;
    driveViewBounds.origin.y = 0.0;
    self.driveView.frame = driveViewBounds;
    self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.driveView.delegate = self;

    [self.containerView addSubview:self.driveView];

    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
}



#pragma mark - Public Func

/// 1. 配置货车车辆信息类
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
                          isEmulatorNavi:(BOOL)isEmulatorNavi {
    AMapNaviVehicleInfo *vehicleInfo = [[AMapNaviVehicleInfo alloc] init];
     //设置车牌号
    vehicleInfo.vehicleId = vehicleId;
    //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    vehicleInfo.type = VehicleTypeTruck;
    //设置货车的类型(大小)
    vehicleInfo.size = size;
    //设置货车的宽度,范围:(0,5],单位：米
    vehicleInfo.width = width;
    //设置货车的高度,范围:(0,10],单位：米
    vehicleInfo.height = height;
     //设置货车的长度,范围:(0,25],单位：米
    vehicleInfo.length = length;
    //设置货车的总重量,范围:(0,100]
    vehicleInfo.weight = weight;
    //设置货车的核定载重,范围:(0,100],核定载重应小于总重
    vehicleInfo.load = load;
    //设置货车的轴数（用来计算过路费及限重）
    vehicleInfo.axisNums = axisNums;

//    AMapNaviPoint *startNaviPoint = [AMapNaviPoint locationWithLatitude:startPoint.coordinate.latitude longitude:startPoint.coordinate.longitude];
//    AMapNaviPoint *endNaviPoint = [AMapNaviPoint locationWithLatitude:endPoint.coordinate.latitude longitude:endPoint.coordinate.longitude];
//    NSMutableArray *wayPointsMutArray = [NSMutableArray array];
//    for (int i = 0; i < wayPoints.count; i++) {
//        CLLocation *waypoint = wayPoints[i];
//        AMapNaviPoint *wayNaviPoint = [AMapNaviPoint locationWithLatitude:waypoint.coordinate.latitude longitude:waypoint.coordinate.longitude];
//        [wayPointsMutArray addObject:wayNaviPoint];
//    }

    [self calculateDriveRouteWithVehicleType:VehicleTypeTruck vehicleInfo:vehicleInfo startPoint:startPoint endPoint:endPoint wayPoints:[wayPoints copy] isEmulatorNavi:isEmulatorNavi];

}


///// 2. 货车路径规划
//- (void)calculateTruckDriveRouteWithVehicleInfo:(AMapNaviVehicleInfo *)vehicleInfo
//                                     startPoint:(AMapNaviPoint *)startPoint
//                                       endPoint:(AMapNaviPoint *)endPoint
//                                      wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
//                                 isEmulatorNavi:(BOOL)isEmulatorNavi {
//    [self calculateDriveRouteWithVehicleType:VehicleTypeTruck vehicleInfo:vehicleInfo startPoint:startPoint endPoint:endPoint wayPoints:wayPoints isEmulatorNavi:isEmulatorNavi];
//}


/// 2. 进行路径规划
- (void)calculateDriveRouteWithVehicleType:(VehicleType)vehicleType
                               vehicleInfo:(AMapNaviVehicleInfo *)vehicleInfo
                                startPoint:(AMapNaviPoint *)startPoint
                                  endPoint:(AMapNaviPoint *)endPoint
                                 wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                            isEmulatorNavi:(BOOL)isEmulatorNavi {

    if (vehicleInfo == nil) {
        NSLog(@"请先配置货车信息");
        return;
    }

    _isEmulatorNavi = isEmulatorNavi;

    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] setVehicleInfo:vehicleInfo];

    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[startPoint]
                                                                    endPoints:@[endPoint]
                                                                    wayPoints:wayPoints
                                                              drivingStrategy:17];
}




#pragma mark - AMapNaviDriveManagerDelegate

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"onCalculateRouteSuccess");

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(naviRoutes:)]) {

//        NSDictionary
        [self.delegate naviRoutes:driveManager.naviRoutes];
    }

    //禁行信息if (driveManager.naviRoute.forbiddenInfo.count) {
    for (AMapNaviRouteForbiddenInfo *info in driveManager.naviRoute.forbiddenInfo) {
        NSLog(@"禁行信息：类型：%ld，车型：%@，道路名：%@，禁行时间段：%@，经纬度：%@",(long)info.type,info.vehicleType,info.roadName,info.timeDescription,info.coordinate);
    }

    //限行设施
    if (driveManager.naviRoute.roadFacilityInfo.count) {
        for (AMapNaviRoadFacilityInfo *info in driveManager.naviRoute.roadFacilityInfo) {
            if (info.type == AMapNaviRoadFacilityTypeTruckHeightLimit || info.type == AMapNaviRoadFacilityTypeTruckWidthLimit || info.type == AMapNaviRoadFacilityTypeTruckWeightLimit) {
                NSLog(@"限行信息：类型：%ld，道路名：%@，经纬度：%@",(long)info.type,info.roadName,info.coordinate);
            }
        }
    }

    if (_isEmulatorNavi) {
        //算路成功后进行模拟导航
        [[AMapNaviDriveManager sharedInstance] startEmulatorNavi];
    }
}


@end
