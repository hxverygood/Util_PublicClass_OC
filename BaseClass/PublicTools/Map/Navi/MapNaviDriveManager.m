//
//  MapNaviDriveManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapNaviDriveManager.h"

#import "MANaviRoute.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import "MapNaviInfoView.h"                                     // 导航最上方信息展示Viwe
#import "CommonUtility.h"
#import "ErrorInfoUtility.h"
#import "SpeechSynthesizer.h"
#import "MoreMenuView.h"



static const CGFloat naviFuncButtonWidth = 44.0;
static const NSInteger RoutePlanningPaddingEdge = 40;


@interface MapNaviDriveManager () <AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate, AMapNaviDriveDataRepresentable, AMapSearchDelegate, MAMapViewDelegate, MoreMenuViewDelegate>

/* 导航View相关组件、属性 */
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) BOOL showTrafficLayer;
@property (nonatomic, assign) BOOL needStartNavi;
@property (nonatomic, assign) BOOL calculateRouteSucces;

/// 顶部导航信息View
@property (nonatomic, strong) MapNaviInfoView *naviInfoView;
/// 车道信息ImageView
@property (nonatomic, strong) UIImageView *laneInfoView;
/// 路口放大图ImageView
@property (nonatomic, strong) UIImageView *crossImageView;
/// 实时路况按钮
@property (nonatomic, strong) UIButton *showTrafficButton;
/// 全览按钮
@property (nonatomic, strong) UIButton *showModeButton;
/// 正北按钮
@property (nonatomic, strong) UIButton *trackingModeButton;
/// 更多设置弹窗
@property (nonatomic, strong) MoreMenuView *moreMenu;


@property (nonatomic, strong) AMapNaviPoint *startPoint;

/// 是否开启模拟导航
@property (nonatomic, assign) BOOL isEmulatorNavi;

/* map路径规划相关属性 */
@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
/// 用于显示当前路线方案
@property (nonatomic) MANaviRoute *naviRoute;
/// 当前路线方案索引值
@property (nonatomic) NSInteger currentCourse;

/// 导航manager
@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;

@end



@implementation MapNaviDriveManager

#pragma mark - Getter

- (AMapNaviDriveView *)driveView {
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] init];
        _driveView.showUIElements = NO;
        _driveView.showCompass = YES;
        _driveView.showScale = YES;
        _driveView.autoZoomMapLevel = YES;
        _driveView.showGreyAfterPass = YES;

        // 修改罗盘位置
        if ([self.driveView respondsToSelector:NSSelectorFromString(@"naviMapView")]) {
            UIView *temp = [self.driveView performSelector:NSSelectorFromString(@"naviMapView")];
            for (UIView *view in temp.subviews) {
                if ([view isKindOfClass:[MAMapView class]]) {
                    MAMapView *mapView = (MAMapView *)view;
//                    mapView.showsCompass = YES;
                    CGPoint origin = mapView.compassOrigin;
                    CGSize size = mapView.compassSize;
                    mapView.compassOrigin = CGPointMake(kScreenWidth - 5.0 - (size.width + (naviFuncButtonWidth - size.width)/2), origin.y + 80.0);
                    break;
                }
            }
        }

//        [_driveView performSelector:@selector(setCompassOrigin:) withObject:[NSValue valueWithCGPoint:CGPointMake(kScreenWidth - 20 - 25.0, 50.0)]];

        _driveView.showTrafficLayer = YES;
        _driveView.delegate = self;
        [_driveView setCarImage:[UIImage imageNamed:@"navi_car"]];
        [_driveView setCarCompassImage:[UIImage new]];

//        if (_needArriveDepot) {
//            [_driveView setStartPointImage:[UIImage imageNamed:@"navi_point_begin"]];
//        }
//        else {
//            [_driveView setStartPointImage:[UIImage imageNamed:@"navi_point_finish"]];
//        }

        [_driveView setStartPointImage:nil];
        [_driveView setWayPointImage:[UIImage imageNamed:@"navi_point_finish"]];
        [_driveView setEndPointImage:[UIImage imageNamed:@"navi_point_finish"]];
        //当显示模式为非锁车模式时，是否在6秒后自动设置为锁车模式
        _driveView.autoSwitchShowModeToCarPositionLocked = YES;
    }
    return _driveView;
}

- (MapNaviInfoView *)naviInfoView {
    if (!_naviInfoView) {
        _naviInfoView  = [MapNaviInfoView view];
    }
    return _naviInfoView;
}

- (AMapNaviCompositeManager *)compositeManager {
    if (!_compositeManager) {
        _compositeManager = [[AMapNaviCompositeManager alloc] init];  // 初始化
//        _compositeManager.delegate = self;  // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    }
    return _compositeManager;
}



#pragma mark - Initiailizer

- (instancetype)initWithStartPoint:(AMapNaviPoint *)startPoint
                         wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                          endPoint:(AMapNaviPoint *)endPoint {
    self = [super init];

    if (self) {
        self.startPoint = startPoint;
        self.wayPoints = wayPoints;
        self.endPoint = endPoint;
    }

    return self;
}

- (instancetype)initWithVehicleInfo:(AMapNaviVehicleInfo *)vehicleInfo
                         startPoint:(AMapNaviPoint *)startPoint
                          wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                           endPoint:(AMapNaviPoint *)endPoint {
    self = [super init];

    if (self) {
        self.vehicleInfo = vehicleInfo;
        self.startPoint = startPoint;
        self.wayPoints = wayPoints;
        self.endPoint = endPoint;
    }

    return self;
}

- (void)destroy {
    [self startNavi:NO];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:_driveView];
    [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];

    BOOL success = [AMapNaviDriveManager destroyInstance];
    GGLog(@"AMapNaviDriveManager 单例是否销毁: %d", success);

    [self.driveView removeFromSuperview];
    self.driveView.delegate = nil;

    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
}




#pragma mark - Navi Drive View

- (void)setStartPoint:(AMapNaviPoint *)startPoint
            wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
             endPoint:(AMapNaviPoint *)endPoint {
    self.startPoint = startPoint;
    self.wayPoints = wayPoints;
    self.endPoint = endPoint;

//    [self calculateRoute];
}

/// 添加导航View
- (void)addNaviDriveViewInView:(UIView *)containerView
                        bounds:(CGRect)bounds {
    self.containerView = containerView;

    CGRect driveViewBounds = bounds;
    driveViewBounds.origin.x = 0.0;
    driveViewBounds.origin.y = 0.0;
    self.driveView.frame = driveViewBounds;
//    self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.driveView.delegate = self;

    [self.containerView addSubview:self.driveView];

    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];

    [self initDriveManager];
    [self setupView];
}

- (void)setupView {

    // 车道前景信息
    self.laneInfoView = [[UIImageView alloc] init];
    self.laneInfoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.laneInfoView setCenter:CGPointMake(CGRectGetMidX(self.driveView.bounds), 80 + 20)];
    [self.driveView addSubview:self.laneInfoView];

    // 路口放大图
//    self.crossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.driveView.bounds)-90, 80, 180, 140)];
//    [self.driveView addSubview:self.crossImageView];


    UIView *firstButtonContainer = [[UIView alloc] init];
    firstButtonContainer.backgroundColor = [UIColor whiteColor];
    [firstButtonContainer cornerRadius:5.0];
    [firstButtonContainer borderWidth:1.0 borderColor:LineColor];
    firstButtonContainer.frame = CGRectMake(kScreenWidth - 5 - naviFuncButtonWidth, CGRectGetHeight(self.naviInfoView.bounds) + 20 + 36, naviFuncButtonWidth, (naviFuncButtonWidth+20) *3);
    [self.driveView addSubview:firstButtonContainer];

    _startNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startNaviButton.frame = CGRectMake(0, 10, naviFuncButtonWidth, naviFuncButtonWidth);
    [_startNaviButton setBackgroundImage:[UIImage imageNamed:@"ic_navigation_normal"] forState:UIControlStateNormal];
    [_startNaviButton setBackgroundImage:[UIImage imageNamed:@"ic_navigation_light"] forState:UIControlStateSelected];
    [_startNaviButton addTarget:self action:@selector(startNaviButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [firstButtonContainer addSubview:_startNaviButton];

    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(10.0, CGRectGetMaxY(_startNaviButton.frame) + 9, naviFuncButtonWidth-20, 1.0);
    line1.backgroundColor = LineColor;
    [firstButtonContainer addSubview:line1];

    // 路况信息
    _showTrafficButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect showTrafficButtonFrame = _startNaviButton.frame;
    showTrafficButtonFrame.origin.y = CGRectGetMaxY(line1.frame) + 10;
    _showTrafficButton.frame = showTrafficButtonFrame;
    [_showTrafficButton setBackgroundImage:[UIImage imageNamed:@"default_navi_traffic_close_normal"] forState:UIControlStateNormal];
    [_showTrafficButton setBackgroundImage:[UIImage imageNamed:@"default_navi_traffic_open_normal"] forState:UIControlStateSelected];
    [_showTrafficButton addTarget:self action:@selector(showTrafficButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _showTrafficButton.selected = self.driveView.showTrafficLayer;
    [firstButtonContainer addSubview:_showTrafficButton];

    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(10.0, CGRectGetMaxY(_showTrafficButton.frame) + 9, naviFuncButtonWidth-20, 1.0);
    line2.backgroundColor = LineColor;
    [firstButtonContainer addSubview:line2];

    // 全览模式
    _showModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect showModeButtonFrame = _showTrafficButton.frame;
    showModeButtonFrame.origin.y = CGRectGetMaxY(line2.frame) + 10;
    _showModeButton.frame = showModeButtonFrame;
    [_showModeButton setBackgroundImage:[UIImage imageNamed:@"default_navi_browse_normal"] forState:UIControlStateNormal];
    [_showModeButton setBackgroundImage:[UIImage imageNamed:@"default_navi_browse_ver_highlighted"] forState:UIControlStateSelected];
    [_showModeButton addTarget:self action:@selector(showModeButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked) {
        _showModeButton.selected = NO;
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview) {
        _showModeButton.selected = YES;
    }
    [firstButtonContainer addSubview:_showModeButton];



//    UIView *secondButtonContainer = [[UIView alloc] init];
//    secondButtonContainer.backgroundColor = [UIColor whiteColor];
//    [secondButtonContainer cornerRadius:5.0];
//    [secondButtonContainer borderWidth:1.0 borderColor:LineColor];
//    CGRect secondButtonContainerFrame = firstButtonContainer.frame;
//    secondButtonContainerFrame.origin.y = CGRectGetMaxY(firstButtonContainer.frame) + 10;
//    secondButtonContainerFrame.size.height = naviFuncButtonWidth;
//    secondButtonContainer.frame = secondButtonContainerFrame;
//    secondButtonContainer.backgroundColor = [UIColor whiteColor];
//    [self.driveView addSubview:secondButtonContainer];
//
//    // 正北模式
//    _trackingModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _trackingModeButton.frame = CGRectMake(0.0, 0.0, naviFuncButtonWidth, naviFuncButtonWidth);
//    [_trackingModeButton setBackgroundImage:[UIImage imageNamed:@"default_navi_north_highlighted"] forState:UIControlStateNormal];
//    [_trackingModeButton setBackgroundImage:[UIImage imageNamed:@"default_navi_up"] forState:UIControlStateSelected];
//    [_trackingModeButton addTarget:self action:@selector(trackingModeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    _trackingModeButton.selected = YES;
//    [secondButtonContainer addSubview:_trackingModeButton];

}

- (void)initMoreMenu {
    if (self.moreMenu == nil) {
        self.moreMenu = [[MoreMenuView alloc] initWithSuperView:_containerView];
        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.moreMenu setDelegate:self];
    }
}


/// 开始导航
//- (void)startNavi {
//    _needStartNavi = YES;
//}
//
//- (void)stopNavi {
//    _needStartNavi = NO;
//}

- (void)startNavi:(BOOL)start {
    if (start) {
        NSLog(@"需要开启导航");
        _needStartNavi = YES;
        _calculateRouteSucces = NO;
        [self calculateRoute];
    }
    else {
        NSLog(@"需要关闭导航");
        _needStartNavi = NO;
        [[AMapNaviDriveManager sharedInstance] stopNavi];
        [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
        [self.naviInfoView dismiss];
        _startNaviButton.selected = start;
    }
}



#pragma mark - Action

- (void)startNaviButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
//    [self startNavi:sender.selected];

    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(needStartNavi:)]) {
        [self.delegate needStartNavi:sender.selected];
    }
}

- (void)showTrafficButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;

    _driveView.showTrafficLayer = sender.selected;
}

- (void)showModeButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        _driveView.showMode = AMapNaviDriveViewShowModeOverview;
        [_driveView updateRoutePolylineInTheVisualRangeWhenTheShowModeIsOverview];
    }
    else {
        _driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    }
}

- (void)trackingModeButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        _driveView.showMode = AMapNaviViewTrackingModeCarNorth;
//        _driveView.
    }
    else {
        _driveView.showMode = AMapNaviViewTrackingModeMapNorth;
    }
}



#pragma mark - AMapSearch Route

/// MapKit 货车路径规划
- (void)truckRoutePlanWithMapView:(MAMapView *)mapView
                       startPoint:(AMapNaviPoint *)startPoint
                         endPoint:(AMapNaviPoint *)endPoint
                        wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints {

    self.mapView = mapView;
    self.mapView.delegate = self;

    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude);
    CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude);
    NSMutableArray *mutGeoPointArray = [NSMutableArray array];
    for (int i = 0; i < wayPoints.count; i++) {
        AMapNaviPoint *waypoint = wayPoints[i];
        AMapGeoPoint *geoPoint = [AMapGeoPoint locationWithLatitude:waypoint.latitude longitude:waypoint.longitude];
        [mutGeoPointArray addObject:[geoPoint copy]];
    }

    self.startAnnotation.coordinate = startCoordinate;
    self.destinationAnnotation.coordinate = destinationCoordinate;

    AMapTruckRouteSearchRequest *routeReq = [[AMapTruckRouteSearchRequest alloc] init];
    /* 出发点. */
    routeReq.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude
                                               longitude:startCoordinate.longitude];
    /* 途经点 */
    if (mutGeoPointArray.count > 0) {
        routeReq.waypoints = mutGeoPointArray;
    }

    /* 目的地. */
    routeReq.destination = [AMapGeoPoint locationWithLatitude:destinationCoordinate.latitude
                                                    longitude:destinationCoordinate.longitude];

    [self.search AMapTruckRouteSearch:routeReq];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil) {
        return;
    }

    self.route = response.route;

    if (response.count > 0) {
        [self addNaviRoute];
    }
}

/* 展示当前路线方案. */
- (void)addNaviRoute {
    MANaviAnnotationType type = MANaviAnnotationTypeTruck;

    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];

    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

/* 清空地图上已有的路线. */
- (void)clear {
    [self.naviRoute removeFromMapView];
}



#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[LineDashPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashType = kMALineDashTypeSquare;
        polylineRenderer.strokeColor = [UIColor redColor];

        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MANaviPolyline class]]) {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];

        polylineRenderer.lineWidth = 8;

        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }

        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MAMultiPolyline class]]) {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];

        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];

        return polylineRenderer;
    }

    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";

        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }

        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;

        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;

                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;

                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;

                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                case MANaviAnnotationTypeTruck:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;

                default:
                    break;
            }
        }
        else
        {
//            /* 起点. */
//            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
//            {
//                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
//            }
//            /* 终点. */
//            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
//            {
//                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
//            }

        }

        return poiAnnotationView;
    }

    return nil;
}




#pragma mark - 路径规划

//- (void)searchRoutePlanningDrive
//{
//    self.startAnnotation.coordinate = self.startCoordinate;
//    self.destinationAnnotation.coordinate = self.destinationCoordinate;
//
//    AMapTruckRouteSearchRequest *navi = [[AMapTruckRouteSearchRequest alloc] init];
//    /* 出发点. */
//    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
//                                           longitude:self.startCoordinate.longitude];
//    /* 目的地. */
//    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
//                                                longitude:self.destinationCoordinate.longitude];
//
//    [self.search AMapTruckRouteSearch:navi];
//}

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

#warning fix: Car Type for AMap Navi 
    //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    vehicleInfo.type = VehicleTypeCar;
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
        NSLog(@"请先配置车辆信息");
        return;
    }

    _isEmulatorNavi = isEmulatorNavi;

    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
    [[AMapNaviDriveManager sharedInstance] setVehicleInfo:vehicleInfo];

    [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[startPoint]
                                                                    endPoints:@[endPoint]
                                                                    wayPoints:wayPoints
                                                              drivingStrategy:18];
}



#pragma mark - AMapNaviDriveManager

/// 初始化DriveManager
- (void)initDriveManager {
    //请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];

    [[AMapNaviDriveManager sharedInstance] setAllowsBackgroundLocationUpdates:YES];
    [[AMapNaviDriveManager sharedInstance] setPausesLocationUpdatesAutomatically:YES];

    //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self.driveView];
    //将当前类添加为导航数据的Representative，使其可以接收到导航诱导数据
    [[AMapNaviDriveManager sharedInstance] addDataRepresentative:self];
}

/// 计算路线
- (void)calculateRoute {
    if (_vehicleInfo == nil) {
        _startNaviButton.selected = NO;
        return;
    }

    if (_startPoint == nil ||
        _endPoint == nil) {
        _startNaviButton.selected = NO;
        return;
    }

    //进行路径规划
//    [HUD show];
    [[AMapNaviDriveManager sharedInstance] setVehicleInfo:_vehicleInfo];
    _startPoint = [AMapNaviPoint locationWithLatitude:APPDELEGATE.mlatitude longitude:APPDELEGATE.mlongitude];

    // 规划路径所需条件和参数校验是否成功，不代表算路成功与否
    BOOL success = [[AMapNaviDriveManager sharedInstance] calculateDriveRouteWithStartPoints:@[_startPoint] endPoints:@[_endPoint] wayPoints:_wayPoints drivingStrategy:AMapNaviDrivingStrategySingleAvoidHighwayAndCostAndCongestion];
    GGLog(@"✅ 规划路径所需条件和参数校验: %@", success ? @"成功" : @"失败");
}




#pragma mark - AMapNaviDriveManager Delegate

// 四边流出的空间
- (UIEdgeInsets)driveViewEdgePadding:(AMapNaviDriveView *)driveView {
    return UIEdgeInsetsMake(80.0 + 20.0, 20.0, (isIPhoneXSeries() ? 34.0 : 0.0) + 28.0 + 52.0 + 20.0, 44.0 + 25.0);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error {
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"✅ onCalculateRouteSuccess");
//    [HUD dismiss];

    if (_calculateRouteSucces == NO &&
        _needStartNavi == YES) {
        [[AMapNaviDriveManager sharedInstance] startGPSNavi];
        [self.naviInfoView showInView:_containerView];
        _calculateRouteSucces = YES;
        _startNaviButton.selected = YES;
    }

//    if (self.delegate &&
//        [self.delegate respondsToSelector:@selector(didReceiveNaviRoutes:)]) {
//
////        NSDictionary
//        [self.delegate didReceiveNaviRoutes:driveManager.naviRoutes];
//    }
//
//    //禁行信息if (driveManager.naviRoute.forbiddenInfo.count) {
//    for (AMapNaviRouteForbiddenInfo *info in driveManager.naviRoute.forbiddenInfo) {
//        NSLog(@"禁行信息：类型：%ld，车型：%@，道路名：%@，禁行时间段：%@，经纬度：%@",(long)info.type,info.vehicleType,info.roadName,info.timeDescription,info.coordinate);
//    }
//
//    //限行设施
//    if (driveManager.naviRoute.roadFacilityInfo.count) {
//        for (AMapNaviRoadFacilityInfo *info in driveManager.naviRoute.roadFacilityInfo) {
//            if (info.type == AMapNaviRoadFacilityTypeTruckHeightLimit || info.type == AMapNaviRoadFacilityTypeTruckWidthLimit || info.type == AMapNaviRoadFacilityTypeTruckWeightLimit) {
//                NSLog(@"限行信息：类型：%ld，道路名：%@，经纬度：%@",(long)info.type,info.roadName,info.coordinate);
//            }
//        }
//    }
//
//    if (_isEmulatorNavi) {
//        //算路成功后进行模拟导航
//        [[AMapNaviDriveManager sharedInstance] startEmulatorNavi];
//    }
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error {
    GGLog(@"❌ onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
    self.startNaviButton.selected = NO;
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi");
}

/* 出现偏航需要重新计算路径时的回调函数.偏航后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理. */
- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager {
    NSLog(@"needRecalculateRouteForYaw");
}

/* 前方遇到拥堵需要重新计算路径时的回调函数.拥堵后将自动重新路径规划,该方法将在自动重新路径规划前通知您进行额外的处理. */
- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager {
    NSLog(@"needRecalculateRouteForTrafficJam");
}

/* 导航到达某个途经点的回调函数 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex {
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);

//    NSString *soundString = nil;
//
//    if (_needArriveDepot == YES) {
//        wayPointIndex -= 1;
//    }
//    else {
//        soundString = [NSString stringWithFormat:@"您已到达第%ld个配送点，别忘记打点", (long)wayPointIndex];
//    }
//
//    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

/* GPS导航到达目的地后的回调函数 */
- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager {
    NSLog(@"onArrivedDestination");
}

/* 开发者请根据实际情况返回是否正在播报语音，如果正在播报语音，请返回YES, 如果没有在播报语音，请返回NO */
- (BOOL)driveManagerIsNaviSoundPlaying:(AMapNaviDriveManager *)driveManager {
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}

/* 导航播报信息回调函数,此回调函数需要和driveManagerIsNaviSoundPlaying:配合使用 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);

    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

/* 模拟导航到达目的地后的回调函数 */
- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager {
    NSLog(@"didEndEmulatorNavi");
}



#pragma mark - AMapNaviDriveDataRepresentable

- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviRoute:(nullable AMapNaviRoute *)naviRoute
{
    NSLog(@"updateNaviRoute");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo
{
    // 展示AMapNaviInfo类中的导航诱导信息，更多详细说明参考类 AMapNaviInfo 注释。

    // 转向剩余距离
    [self.naviInfoView setRemainDistance:[NSString stringWithFormat:@"%ld米", (long)naviInfo.segmentRemainDistance]];
    [self.naviInfoView setTurnImageWithIndex:naviInfo.iconType];

    // 道路信息
    [self.naviInfoView setCurrentRoadName:naviInfo.currentRoadName];
    [self.naviInfoView setNextRoadName:naviInfo.nextRoadName];

    // 路径剩余信息
//    NSString *routeStr = [NSString stringWithFormat:@"剩余距离:%@ 剩余时间:%@", [self normalizedRemainDistance:naviInfo.routeRemainDistance], [self normalizedRemainTime:naviInfo.routeRemainTime]];
//    [self.routeRemainInfoLabel setText:routeStr];
}

/* 自车位置更新回调 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation {
//    APPDELEGATE.mlatitude = naviLocation.coordinate.latitude;
//    APPDELEGATE.mlongitude = naviLocation.coordinate.longitude;
}


/* 显示路口放大图 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager showCrossImage:(UIImage *)crossImage {
    NSLog(@"showCrossImage");

    //显示路口放大图
    [self.crossImageView setImage:crossImage];
}

/* 隐藏路口放大图 */
- (void)driveManagerHideCrossImage:(AMapNaviDriveManager *)driveManager {
    NSLog(@"hideCrossImage");

    //隐藏路口放大图
    [self.crossImageView setImage:nil];
}

/* 显示车道前景信息 */
- (void)driveManager:(AMapNaviDriveManager *)driveManager showLaneBackInfo:(NSString *)laneBackInfo laneSelectInfo:(NSString *)laneSelectInfo {
    NSLog(@"showLaneInfo");

    //根据车道信息生成车道信息Image
    UIImage *laneInfoImage = CreateLaneInfoImageWithLaneInfo(laneBackInfo, laneSelectInfo);

    //显示车道信息
    [self.laneInfoView setImage:laneInfoImage];
    [self.laneInfoView setBounds:CGRectMake(0, 0, laneInfoImage.size.width, laneInfoImage.size.height)];
}

/* 隐藏车道前景信息 */
- (void)driveManagerHideLaneInfo:(AMapNaviDriveManager *)driveManager {
    NSLog(@"hideLaneInfo");

    //隐藏车道信息
    [self.laneInfoView setImage:nil];
}




#pragma mark - 导航相关

// 小车导航  - 配置车辆信息类
- (void)naviCarWithVehicleId:(NSString *)vehicleId
                  startPoint:(AMapNaviPoint *)startPoint
              startPointName:(NSString *)startPointName
                    endPoint:(AMapNaviPoint *)endPoint
                endPointName:(NSString *)endPointName
                   wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
               wayPointNames:(NSArray<NSString *> *)wayPointNames {

    if (startPoint == nil) {
        return;
    }

    if (endPoint == nil) {
        return;
    }

    NSMutableArray *points = [NSMutableArray array];
    [points addObject:startPoint];
    [points addObject:endPoint];
    if (wayPoints != nil &&
        wayPoints.count > 0) {
        [points addObjectsFromArray:wayPoints];
    }

    // 导航时添加 annotation
    for (int i = 0; i < points.count; i++) {
        AMapNaviPoint *point = points[i];
        AMapNaviCompositeCustomAnnotation *anno = [[AMapNaviCompositeCustomAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);

//        if (i == 0) {
//            anno.title = @"起";
//        }
//        else if (i == points.count - 1) {
//            anno.title = @"收";
//        }
//        else {
//            anno.title = @"收";
//        }
        [self.compositeManager addAnnotation:anno];
    }

    [self presentCarRoutePlanVCWithVehicleId:vehicleId startPoint:startPoint wayPoints:wayPoints endPoint:endPoint];
}

- (void)presentCarRoutePlanVCWithVehicleId:(NSString *)vehicleId
                                startPoint:(AMapNaviPoint *)startPoint
                                 wayPoints:(NSArray<AMapNaviPoint *> *)wayPoints
                                  endPoint:(AMapNaviPoint *)endPoint {
    AMapNaviVehicleInfo *vehicleInfo = [[AMapNaviVehicleInfo alloc] init];
    //设置车牌号
    vehicleInfo.vehicleId = vehicleId;
    //设置车辆类型,0:小车; 1:货车. 默认0(小车).
    vehicleInfo.type = VehicleTypeCar;

    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    [config setVehicleInfo:vehicleInfo];
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:startPoint.latitude longitude:startPoint.longitude] name:nil POIId:nil];
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:endPoint.latitude longitude:endPoint.longitude] name:nil POIId:nil];

    for (int i = 0; i < wayPoints.count; i++) {
        AMapNaviPoint *waypoint = wayPoints[i];

//        NSString *waypointName = @"暂无名称";
//        if (i < wayPointNames.count) {
//            waypointName = wayPointNames[i];
//        }
        [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeWay location:[AMapNaviPoint locationWithLatitude:waypoint.latitude longitude:waypoint.longitude] name:nil POIId:nil];
    }

    [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
}



/// 1. 卡车导航 - 配置车辆信息类
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
                 wayPointNames:(NSArray<NSString *> *)wayPointNames {

    if (startPoint == nil) {
        return;
    }

    if (endPoint == nil) {
        return;
    }

    NSMutableArray *points = [NSMutableArray array];
    [points addObject:startPoint];
    [points addObject:endPoint];
    if (wayPoints != nil &&
        wayPoints.count > 0) {
        [points addObjectsFromArray:wayPoints];
    }

    // 导航时添加 annotation
    for (int i = 0; i < points.count; i++) {
        AMapNaviPoint *point = points[i];
        AMapNaviCompositeCustomAnnotation *anno = [[AMapNaviCompositeCustomAnnotation alloc] init];
        anno.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);

        if (i == 0) {
            anno.title = @"起";
        }
        else if (i == points.count - 1) {
            anno.title = @"收";
        }
        else {
            anno.title = @"收";
        }
        [self.compositeManager addAnnotation:anno];
    }


    // 配置车辆信息
    AMapNaviVehicleInfo *vehicleInfo = [self generateTruckInfoWithVehicleId:vehicleId size:size width:width height:height length:length weight:weight load:load axisNums:axisNums];
#warning fix: Car Type for AMap Navi
    vehicleInfo.type = VehicleTypeTruck;

    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    [config setVehicleInfo:vehicleInfo];
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:startPoint.latitude longitude:startPoint.longitude] name:startPointName POIId:nil];
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:endPoint.latitude longitude:endPoint.longitude] name:endPointName POIId:nil];

    for (int i = 0; i < wayPoints.count; i++) {
        AMapNaviPoint *waypoint = wayPoints[i];

        NSString *waypointName = @"暂无名称";
        if (i < wayPointNames.count) {
            waypointName = wayPointNames[i];
        }
        [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeWay location:[AMapNaviPoint locationWithLatitude:waypoint.latitude longitude:waypoint.longitude] name:waypointName POIId:nil];
    }

    [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
}



#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked {
    [self.moreMenu dismissWithCompletion:^{

    }];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType {
    //    [self.driveView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode {
    //    [self.driveView setTrackingMode:trackingMode];
}




#pragma mark - Config AMapNaviVehicleInfo

- (AMapNaviVehicleInfo *)generateTruckInfoWithVehicleId:(NSString *)vehicleId
                                                   size:(CGFloat)size
                                                  width:(CGFloat)width
                                                 height:(CGFloat)height
                                                 length:(CGFloat)length
                                                 weight:(CGFloat)weight
                                                   load:(CGFloat)load
                                               axisNums:(CGFloat)axisNums {
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

    return vehicleInfo;
}


@end
