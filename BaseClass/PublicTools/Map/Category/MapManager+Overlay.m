//
//  MapManager+Overlay.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/21.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager+Overlay.h"

static char *singleRouteArrayKey = "singleRouteArrayKey";
static char *routesMutableArrayKey = "routesMutableArrayKey";

#define PolylineStrokeColor [UIColor colorWithRed:0 green:1 blue:0 alpha:0.8]

@interface MapManager () <MAMapViewDelegate>

@property (nonatomic, strong) NSArray<MAPolyline *> *singleRoute;
@property (nonatomic, strong) NSMutableArray<MAPolyline *> *routes;

@end



@implementation MapManager (Overlay)

#pragma mark - Getter

- (void)setSingleRoute:(NSArray<MAPolyline *> *)singleRoute {
    objc_setAssociatedObject(self, singleRouteArrayKey, singleRoute, OBJC_ASSOCIATION_COPY);
}

- (NSArray<MAPolyline *> *)singleRoute {
    return objc_getAssociatedObject(self, singleRouteArrayKey);
}

- (void)setRoutes:(NSMutableArray<MAPolyline *> *)routes {
    objc_setAssociatedObject(self, routesMutableArrayKey, routes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<MAPolyline *> *)routes {
    return objc_getAssociatedObject(self, routesMutableArrayKey);
}



#pragma mark - Public Func

///// 添加单一数据折线
//- (void)category_addSinglePolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates {
//    MAPolyline *route = [MAPolyline polylineWithCoordinates:coordinates count:1];
//    [self.mapView addOverlay:route];
//
//    [self showMapRegionWithCoordinates:coordinates count:1];
//}

/// 添加多数据折线
- (void)category_addPolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    if (count == 0) {
        return;
    }

    MAPolyline *route = [MAPolyline polylineWithCoordinates:coordinates count:count];
    if (self.routes == nil) {
        self.routes = [NSMutableArray array];
    }
    else {
        [self.mapView removeOverlays:self.routes];
        [self.routes removeAllObjects];
    }
    [self.routes addObject:route];
    [self.mapView addOverlays:self.routes];

    [self showMapRegionWithCoordinates:coordinates count:count];
}



#pragma mark - MAMapView Delegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = PolylineStrokeColor;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;

        return polylineRenderer;
    }
    return nil;
}



#pragma mark - Private Func

/// 显示绘制的路径所组成的区域
- (void)showMapRegionWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count {
    /*
     计算坐标点所形成的矩形区域
     */
    // 维度数据数组
    NSMutableArray *latArray = [NSMutableArray arrayWithCapacity:count];
    // 经度数据数组
    NSMutableArray *lonArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CLLocationCoordinate2D coor = coordinates[i];
        [latArray addObject:[NSNumber numberWithDouble:coor.latitude]];
        [lonArray addObject:[NSNumber numberWithDouble:coor.longitude]];
    }

    // 使地图显示在路径范围
    NSArray *latResult = [self findMidValue:latArray];
    NSArray *lonResult = [self findMidValue:lonArray];
    CLLocationDegrees centerLat = [latResult[0] doubleValue];
    double centerLatSpan = [latResult[1] doubleValue];
    CLLocationDegrees centerLon = [lonResult[0] doubleValue];
    double centerLonSpan = [lonResult[1] doubleValue];

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(centerLat, centerLon);
    MACoordinateSpan span = MACoordinateSpanMake(centerLatSpan*2 + 0.01, centerLonSpan*2 + 0.01);
    [self.mapView setRegion:MACoordinateRegionMake(center, span) animated:YES];
}

- (NSArray *)findMidValue:(NSArray *)array {
    double min = [array[0] doubleValue];
    double max = [array[0] doubleValue];
    for (int i = 0; i < array.count; i++) {
        double tmp = [array[i] doubleValue];
        if (tmp < min) {
            min = tmp;
        }

        if (tmp > max) {
            max = tmp;
        }
    }

    return @[@((min + max)/2), @((max - min)/2)];
}

@end
