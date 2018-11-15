//
//  MapManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/14.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager.h"
#import "MapManager+AMapSearch.h"
#import "MapManager+Overlay.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CustomAnnotation.h"
#import "CustomAnimtatedAnnotation.h"
#import "CustomAnnotationView.h"

#define kCalloutViewMargin          -8.0

@interface MapManager () <AMapLocationManagerDelegate, MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, weak) UIView *mapContainerView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
/// 定位回调，只用于持续定位或后台定位
@property (nonatomic, copy) void (^locationUpadteBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);
/// 用户当前位置
@property (nonatomic, strong) MAUserLocation *currentUserLocation;

/// 存储定位后的location和反地理信息
@property (nonatomic, copy) CLLocation *inner_currentLocation;
@property (nonatomic, copy) AMapLocationReGeocode *inner_currentRegeocode;

/// 点标记
@property (nonatomic, strong) NSMutableArray<CustomAnnotation *> *inner_annotations;
@property (nonatomic, strong) NSMutableArray<CustomAnnotation *> *order_annotations;
@property (nonatomic, strong) CustomAnnotation *centerAnnotation;
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation *> *pointArr;  /// 用户线路绘制
@property (nonatomic, strong) MAPolyline *routeLine;

/// 搜索
@property (nonatomic, strong) AMapSearchAPI *search;

@end



@implementation MapManager

#pragma mark - Getter

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.rotateCameraEnabled = NO;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 2.0;
    }
    return _locationManager;
}

- (NSMutableArray<CustomAnnotation *> *)inner_annotations {
    if (!_inner_annotations) {
        _inner_annotations = [NSMutableArray array];
    }
    return _inner_annotations;
}

- (NSMutableArray<CustomAnnotation *> *)order_annotations {
    if (!_order_annotations) {
        _order_annotations = [NSMutableArray array];
    }
    return _order_annotations;
}

- (CustomAnnotation *)centerAnnotation {
    if (!_centerAnnotation) {
        _centerAnnotation = [[CustomAnnotation alloc] init];
        _centerAnnotation.style = CustomAnnotationStyleMapCenter;
        _centerAnnotation.imageName = @"ic_point";
    }
    return _centerAnnotation;
}

- (NSMutableArray<MAPointAnnotation *> *)pointArr {
    if (_pointArr) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

- (AMapSearchAPI *)search {
    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

- (CLLocation *)currentLocation {
    return _inner_currentLocation;
}

- (AMapLocationReGeocode *)currentRegeocode {
    return _inner_currentRegeocode;
}

- (void)setSelectedAnnotationIndex:(NSInteger)selectedAnnotationIndex {
    _selectedAnnotationIndex = selectedAnnotationIndex;

    [self selectSingleAnnotationWithIndex:selectedAnnotationIndex];
}



#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        // 配置apiKey
        [AMapServices sharedServices].apiKey = kMapApiKey;
        [AMapServices sharedServices].enableHTTPS = YES;

        [self resetSelectedAnnotationIndex];
    }
    return self;
}

/// 重置选中的anno序号
- (void)resetSelectedAnnotationIndex {
    _selectedAnnotationIndex = -1;
}

//+ (MapManager *)sharedManager {
//    static MapManager *handle = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        handle = [[MapManager alloc] init];
//
//        // 配置apiKey
//        [AMapServices sharedServices].apiKey = kMapApiKey;
//        [AMapServices sharedServices].enableHTTPS = YES;
//    });
//    return handle;
//}

- (void)addMapInView:(UIView *)mapContainerView
               frame:(CGRect)frame {
    self.mapView.frame = frame;
    [mapContainerView addSubview:self.mapView];

    [self configMap];
}

- (void)configMap {
    if (!_mapView) {
        return;
    }

    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    _mapView.showsUserLocation = NO;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
//
//    // 定位蓝点
//    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
//    UIColor *alphaColor = [MainColor colorWithAlphaComponent:0.2];
//    r.fillColor = alphaColor;
//    r.strokeColor = alphaColor;
//    r.lineWidth = 1;
//    r.locationDotFillColor = MainColor;///定位点蓝色圆点颜色，不设置默认蓝色
//    [_mapView updateUserLocationRepresentation:r];
}



#pragma mark - Public Func
#pragma mark 定位
/// 一次定位
- (void)startLocationOnceWithCompletion:(void (^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))completion {

    // 定位超时（如果定位精度是kCLLocationAccuracyBest，则设置为10s）
    self.locationManager.locationTimeout = 3;
    // 逆地理请求超时时间，最低2s (如果定位精度是kCLLocationAccuracyBest，则设置为10s)
    self.locationManager.reGeocodeTimeout = 3;

    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        self.inner_currentLocation = location;
        self.inner_currentRegeocode = regeocode;

        if (completion) {
            completion(location, regeocode, error);
        }

        if (!error) {
            if (location) {
                APPDELEGATE.mlongitude = location.coordinate.longitude;
                APPDELEGATE.mlatitude = location.coordinate.latitude;

                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) animated:YES];
                [self.mapView setZoomLevel:11 animated:YES];

                // 添加定位后的大头针
                [self.mapView removeAnnotation:self.centerAnnotation];
                self.centerAnnotation = nil;
                self.centerAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
                [self.mapView addAnnotation:self.centerAnnotation];
                self.mapView.rotationDegree = 0.0;

                // 屏幕中心添加大头针
//                [self showCenterMark];
//                self.mapView.rotationDegree = 0.0;

                NSLog(@"\n(%f, %f)\n%@ %@ %@", location.coordinate.latitude, location.coordinate.longitude, regeocode.province, regeocode.city, regeocode.district);
            }
        }

//        if (error) {
//            NSLog(@"AMap locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                return;
//            }
//        }
//
//        NSLog(@"AMap location:%@", location);
//
//        if (regeocode)
//        {
//            NSLog(@"AMap reGeocode:%@", regeocode);
//        }
    }];
}

/// 开始 后台/持续 定位
- (void)startBackgroudLocationWithCompletion:(LocationUpdateBlock)completion {
    // 定位超时（如果定位精度是kCLLocationAccuracyBest，则设置为10s）
    self.locationManager.locationTimeout = 10;
    // 逆地理请求超时时间，最低2s (如果定位精度是kCLLocationAccuracyBest，则设置为10s)
    self.locationManager.reGeocodeTimeout = 10;

    if (@available(iOS 9.0, *)) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }
    else {
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
    }

    if (completion) {
        self.locationUpadteBlock = completion;
    }

    // 是否需要返回反地理编码
    [self.locationManager setLocatingWithReGeocode:YES];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}

/// 在回调存在的情况下 开始 后台/持续 定位
- (void)restartBackgroudLocation {
    if (self.locationUpadteBlock) {
        [self startBackgroudLocationWithCompletion:self.locationUpadteBlock];
    }
}

/// 停止定位
- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}


#pragma mark 点标记

//- (void)updateAnnotations:(NSArray *)annotaions {
//
//}

/// 添加一组点标记（删除已有的同类型标记）
//- (void)addAnnotations:(NSArray *)annotations style:(AnnotationViewStyle)style {
- (void)addAnnotations:(NSArray *)annotations
    refreshAnnotations:(BOOL)needRefreshAnnotations {
    if (self.mapView.superview == nil) {
        NSLog(@"请先使用 addMapInView:frame: 方法将地图添加至view");
        return;
    }

    if (annotations.count == 0) {
        return;
    }

    if (needRefreshAnnotations) {
        [self.inner_annotations removeAllObjects];
    }

    [self.inner_annotations addObjectsFromArray:annotations];


//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mapView addAnnotations:annotations];
//    });
    [self.mapView addAnnotations:annotations];
}

///// 选择某个标记
//- (void)selectAnnotationWithIndex:(NSInteger *)index {
//
//}


///// 给导航增加标记点
//- (void)addNaviAnnotations:(NSArray *)annotations {
//    if (self.mapView.superview == nil) {
//        NSLog(@"请先使用 addMapInView:frame: 方法将地图添加至view");
//        return;
//    }
//
//    if (annotations.count == 0) {
//        return;
//    }
//
////    CustomAnnotation *startAnnotation = annotations[0];
////    startAnnotation.style = CustomAnnotationStyleNaviStartPoint;
////
////    CustomAnnotation *endAnnotation = annotations[annotations.count - 1];
////    endAnnotation.style = CustomAnnotationStyleNaviEndPoint;
////
////    // 中间的途经点
////    NSMutableArray *pointMutArray = [NSMutableArray array];
////    for (int i = 1; i < annotations.count - 2; i++) {
////        CustomAnnotation *waypointAnnotation =
////        <#statements#>
////    }
//}

/// 单选annotation（作用：改变选择的anno样式，之前选择的改为默认样式）
- (void)selectSingleAnnotationWithIndex:(NSInteger)index {
    if (self.inner_annotations.count == 0) {
        return;
    }

     _selectedAnnotationIndex = index;

    // 找到地图上添加的点
    int flag = -1;
    for (int i = 0; i < self.inner_annotations.count; i++) {
        id <MAAnnotation, CustomAnnotation> addedAnno = self.inner_annotations[i];

        // 如果是之前选中的仓库点，则改为默认仓库标记，并记住当前的index
        if (addedAnno.style == CustomAnnotationStyleSelectedDepot &&
            i != index) {
            addedAnno.style = CustomAnnotationStyleDepot;
            flag = i;
        }

        // 如果是当前刚选择的index，则更改为选中标记
        if (i == index) {
            addedAnno.style = CustomAnnotationStyleSelectedDepot;
        }
    }

    if (index < 0) {
        NSLog(@"选择的仓库index: 0");
        return;
    }

    CustomAnnotation *selectedAnno = self.inner_annotations[index];

    // 如果没有找到之前选择的anno，则直接改变这次选择的anno样式
    if (flag == -1) {
        [self.mapView removeAnnotations:@[selectedAnno]];
        [self.mapView addAnnotations:@[selectedAnno]];
    }
    else {
        id <MAAnnotation, CustomAnnotation> addedSelectedDepotAnno = self.inner_annotations[flag];
        [self.mapView removeAnnotations:@[addedSelectedDepotAnno, selectedAnno]];
        [self.mapView addAnnotations:@[addedSelectedDepotAnno, selectedAnno]];
    }
}

/// 在地图上删除所有点标记（除了中心点）
- (void)removeAllAnnotations {
    NSMutableArray *needDeletedAnnotations = [NSMutableArray array];
    NSArray *annotations = self.mapView.annotations;

    for (int i = 0; i < annotations.count; i++) {
        CustomAnnotation *tmpAnno = (CustomAnnotation *)annotations[i];
        if (tmpAnno.style != CustomAnnotationStyleMapCenter) {
            [needDeletedAnnotations addObject:tmpAnno];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:needDeletedAnnotations];
    });
    [self resetSelectedAnnotationIndex];
}

/// 将选中的仓库定位点重置为默认的仓库样式
- (void)resetDepotAnnotation {
    for (int i = 0; i < self.inner_annotations.count; i++) {
        CustomAnnotation *anno = self.inner_annotations[i];
        if (anno.style == CustomAnnotationStyleSelectedDepot) {
            anno.style = CustomAnnotationStyleDepot;
            [self.mapView removeAnnotations:@[anno]];
            [self.mapView addAnnotations:@[anno]];
        }
        else if(anno.style == CustomAnnotationStyleRemoteDepot ||
                anno.style == CustomAnnotationStyleRemoteSeletedDepot) {
            // 删除远程推送订单对应的仓库点anno
            [self.mapView removeAnnotations:@[anno]];
        }
    }
}

/// 移除远程推送数据选中的仓库
- (void)removeRemoteSeletedAnnotation {
    NSArray *annotations = self.mapView.annotations;
    for (int i = 0; i < annotations.count; i++) {
        CustomAnnotation *anno = (CustomAnnotation *)annotations[i];
        if (anno.style == CustomAnnotationStyleRemoteSeletedDepot) {
            [self.mapView removeAnnotations:@[anno]];
            break;
        }
    }
}




#pragma mark 折线

/// 添加单一数据折线
//- (void)addSinglePolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates {
//    [self category_addSinglePolylineWithCoordinates:coordinates];
//}
/// 添加多数据折线
- (void)addPolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count{
    [self category_addPolylineWithCoordinates:coordinates count:count];
}



#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.locationUpadteBlock) {
        self.locationUpadteBlock(nil, nil, error);
    }
}


/*
 注意：如果实现了amapLocationManager:didUpdateLocation:reGeocode: 回调，将不会再回调amapLocationManager:didUpdateLocation: 方法。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (self.locationUpadteBlock) {
        self.locationUpadteBlock(location, nil, nil);
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"------ amapLocationManager：更新坐标 ------");
    if (self.locationUpadteBlock) {
        self.locationUpadteBlock(location, reGeocode, nil);
    }
    else {
        NSLog(@"locationUpadteBlock == nil");
    }
}

/// 是否显示设备朝向校准
- (BOOL)amapLocationManagerShouldDisplayHeadingCalibration:(AMapLocationManager *)manager {
    return YES;
}



#pragma mark - MAMapView Delegate
#pragma mark Map Locating

//当位置改变时候调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    //updatingLocation 标示是否是location数据更新, YES:location数据更新 NO:heading数据更新
    if (updatingLocation == YES) {
        NSLog(@"mapView 用户位置更新");

        APPDELEGATE.mlongitude = userLocation.location.coordinate.longitude;
        APPDELEGATE.mlatitude = userLocation.location.coordinate.latitude;

        //增加距离判断
        if (self.currentUserLocation) {
            CLLocationDistance distance = [userLocation.location distanceFromLocation:self.currentUserLocation.location];
            //判断当前点与之前点距离相差小于10米就不计入计算.
            if (distance < 10) {
                return;
            } else {
                self.currentUserLocation = userLocation;//设置当前位置
            }
        } else {
            self.currentUserLocation = userLocation;//设置当前位置
        }
        //手机位置信息
//        [self setPointArrWithCurrentUserLocation];
    }
}

//定位失败
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSString *errorString = @"";
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }

    NSLog(@"mapView 定位失败 ❌: %@", errorString);
}

- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
    NSLog(@"mapView 定位结束 ✅");
}


#pragma mark Region

- (void)mapViewRegionChanged:(MAMapView *)mapView {
    self.centerAnnotation.coordinate = mapView.centerCoordinate;
}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {

}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
//        self.centerAnnotation.coordinate = mapView.centerCoordinate;
        [self searchReGeocodeWithCoordinate:mapView.centerCoordinate];
    }
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

#pragma mark AnnotationView

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {

    static NSString *reuseIndentifier = nil;

    // 定位pin
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *anno = (CustomAnnotation *)annotation;

        switch (anno.style) {
            case CustomAnnotationStyleDefault:
            {
                reuseIndentifier = @"DefaultReuseIndentifier";

                MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.canShowCallout = YES;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.pinColor = MAPinAnnotationColorPurple;
                annotationView.annotation = annotation;

                if (anno.imageName) {
                    annotationView.image = [UIImage imageNamed:anno.imageName];
                }

                return annotationView;
            }
                break;

            case CustomAnnotationStyleMapCenter:
            {
                reuseIndentifier = @"MapCenterReuseIndentifier";

                MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 99;
                annotationView.canShowCallout = YES;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.pinColor = MAPinAnnotationColorRed;
//                annotationView.centerOffset = CGPointMake(0.0, -16.0);
                annotationView.annotation = annotation;

                if (anno.imageName) {
                    annotationView.image = [UIImage imageNamed:anno.imageName];
                }

                return annotationView;
            }
                break;

            case CustomAnnotationStyleDepot:
            {
                reuseIndentifier = @"DepotReuseIndentifier";

                CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 80;
                annotationView.canShowCallout = NO;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = NO;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.pinColor = MAPinAnnotationColorRed;
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"ic_point_normal"];
                annotationView.centerOffset = CGPointMake(0.0, -16.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleSelectedDepot:
            {
                reuseIndentifier = @"SelectedDepotReuseIndentifier";

                CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 90;
                annotationView.canShowCallout = NO;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = NO;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.pinColor = MAPinAnnotationColorRed;
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"ic_point_light"];
                annotationView.centerOffset = CGPointMake(0.0, -20.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleRemoteSeletedDepot:
            {
                reuseIndentifier = @"RemoteSeletedDepotReuseIndentifier";

                CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 91;
                annotationView.canShowCallout = NO;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = NO;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.pinColor = MAPinAnnotationColorRed;
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"ic_point_light"];
                annotationView.centerOffset = CGPointMake(0.0, -20.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleNaviStartPoint:
            {
                reuseIndentifier = @"NaviStartPointReuseIndentifier";
                CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 1;
                annotationView.canShowCallout = NO;     // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;          // 设置标注可以拖动，默认为NO
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"navi_point_begin"];
                annotationView.centerOffset = CGPointMake(0.0, -16.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleNaviWayPoints:
            {
                reuseIndentifier = @"NaviWayPointReuseIndentifier";
                CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 1;
                annotationView.canShowCallout = NO;     // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;          // 设置标注可以拖动，默认为NO
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"navi_point_finish"];
                annotationView.centerOffset = CGPointMake(0.0, -16.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleNaviEndPoint:
            {
                reuseIndentifier = @"NaviEndPointReuseIndentifier";
                CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 1;
                annotationView.canShowCallout = NO;     // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;          // 设置标注可以拖动，默认为NO
                annotationView.annotation = annotation;
                annotationView.image = [UIImage imageNamed:@"navi_point_finish"];
                annotationView.centerOffset = CGPointMake(0.0, -16.0);

                return annotationView;
            }
                break;

            case CustomAnnotationStyleCustom:
            {
                reuseIndentifier = @"CustomReuseIndentifier";
                CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 0;
                annotationView.canShowCallout = NO;    // 设置气泡可以弹出，默认为NO
                annotationView.animatesDrop = YES;      // 设置标注动画显示，默认为NO
                annotationView.draggable = NO;          // 设置标注可以拖动，默认为NO
                annotationView.annotation = annotation;
                if (anno.imageName) {
                    annotationView.image = [UIImage imageNamed:anno.imageName];
                }

                return annotationView;
            }
                break;

            default:
                break;
        }

    }
    else if ([annotation isKindOfClass:[CustomAnimtatedAnnotation class]]) {
        CustomAnimtatedAnnotation *anno = (CustomAnimtatedAnnotation *)annotation;
        switch (anno.style) {
            case CustomAnnotationStyleAnimation:
            {
                reuseIndentifier = @"AnimationReuseIndentifier";

                MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndentifier];
                if (annotationView == nil) {
                    annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndentifier];
                }
                annotationView.zIndex = 2;
                annotationView.canShowCallout = NO;    // 设置气泡可以弹出，默认为NO
                annotationView.draggable = NO;         // 设置标注可以拖动，默认为NO
                annotationView.centerOffset = CGPointMake(0.0, 0.0);
                UIImage *image = [UIImage imageNamed:@"car"];
                annotationView.image = image;
                annotationView.annotation = annotation;

                return annotationView;
            }
                break;

            default:
                break;
        }

    }

    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {

}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[CustomAnnotationView class]]) {

        /* 调整map的中心，以便完全展示callout */
//        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
//        CGRect cusViewFrame = cusView.calloutView.frame;
//        CGRect frame = [cusView convertRect:cusViewFrame toView:self.mapView];
//        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
//
//        CGRect mapViewBounds = self.mapView.bounds;
//        if (!CGRectContainsRect(mapViewBounds, frame)) {
//            /* Calculate the offset to make the callout view show up. */
//            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
//
//            CGPoint theCenter = self.mapView.center;
//            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
//
//            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
//
//            [self.mapView setCenterCoordinate:coordinate animated:YES];
//        }

        // 获取点击对应的annotation
        MAPointAnnotation *anno = (MAPointAnnotation *)view.annotation;
        // flag用于标记是否找到了对应的annotation，初始值为-1
        NSInteger flag = -1;
        for (int i = 0; i < self.inner_annotations.count; i++) {
            CustomAnnotation *annotation = (CustomAnnotation *)self.inner_annotations[i];
            if (annotation == anno) {
                flag = i;
                break;
            }
        }

        if (flag > -1) {
            // 如果当前选择的序号和之前的相同，则不更新地图上的标记，也不通知代理类进行更多操作
            if (flag == _selectedAnnotationIndex) {
                NSLog(@"点击了相同的仓库坐标");
                return;
            }

            NSLog(@"点击的仓库序号是: %ld", (long)flag);
            [self selectSingleAnnotationWithIndex:flag];

            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(annotationViewSelectWithIndex:)]) {
                [self.delegate annotationViewSelectWithIndex:flag];
//                [cusView.calloutView setContent:content];
            }
        }
    }

}



#pragma mark - Private Func

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect {
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;

    [self.search AMapReGoecodeSearch:regeo];
    //    __weak typeof(self) weakself = self;
    self.reGeocodeSearchBlock = ^(NSError *error, AMapReGeocode *regeocode) {
        //        AMapAddressComponent *addressComponent = regeocode.addressComponent;

        // aoi中的信息
        //        NSLog(@"当前中心点格式化地址：%@", regeocode.formattedAddress);

        //        NSLog(@"当前中心点信息地址：%@ %@ %@ %@ %@ %@", addressComponent.province, addressComponent.city, addressComponent.district, addressComponent.township, addressComponent.neighborhood, addressComponent.streetNumber.street);
    };
}
//- (void)showCenterMark {
//    if (_centerMark == nil) {
//        _centerMark = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 80.0)];
//        _centerMark.center = self.mapView.center;
//        _centerMark.image = [UIImage imageNamed:@"ic_point"];
//        _centerMark.contentMode = UIViewContentModeScaleAspectFit;
////        _centerMark.backgroundColor = [UIColor lightGrayColor];
//        [self.mapView addSubview:_centerMark];
//
//        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerMarkTapped:)];
//        [_centerMark addGestureRecognizer:gr];
//    }
//    else {
//        if (_centerMark.superview) {
//            _centerMark.center = self.mapView.center;
//        }
//    }
//}
//
//- (void)dismissCenterMark {
//    if (_centerMark == nil) {
//        return;
//    }
//    [_centerMark removeFromSuperview];
//    _centerMark = nil;
//}

/// 设置数组元素并且去执行画线操作
//- (void)setPointArrWithCurrentUserLocation {
//    //    NSLog(@"记录一个点");
//    //检查零点
//    if (_currentUserLocation.location.coordinate.latitude == 0.0f ||
//        _currentUserLocation.location.coordinate.longitude == 0.0f)
//        return;
//    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
//    point.coordinate = _currentUserLocation.location.coordinate;
//    [_pointArr addObject:point];
//    //画线
//    [self drawTrackingLine];
//}
//
///// 绘制路线
//- (void)drawTrackingLine {
//    MAMapPoint *pointArray = new MAMapPoint[_pointArr.count];//创建结构体数组
//    for(int index = 0; index < _pointArr.count; index++) {
//        MAPointAnnotation *locationUser = [[MAPointAnnotation alloc] init];
//        locationUser = [_pointArr objectAtIndex:index];
//        MAMapPoint point = MAMapPointForCoordinate(locationUser.coordinate);
//        pointArray[index] = point;
//    }
//    //在每次画出轨迹线的时候把之前的线删除掉.不然会多次添加.
//    if (self.routeLine) {
//        [self.mapView removeOverlay:self.routeLine];
//    }
//    self.routeLine = [MAPolyline polylineWithPoints:pointArray count:_pointArr.count];
//    if (nil != self.routeLine) {
//        //将折线绘制在地图底图标注和兴趣点图标之下
//        [self.mapView addOverlay:self.routeLine];
//    }
//    delete []pointArray;
//}



//#pragma mark - Action
//
//- (void)centerMarkTapped:(UITapGestureRecognizer *)gr {
//
//}



#pragma mark - Clear Mapview

- (void)clearMapView {
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.delegate = nil;
}


@end
