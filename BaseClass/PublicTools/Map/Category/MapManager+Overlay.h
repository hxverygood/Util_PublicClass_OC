//
//  MapManager+Overlay.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/21.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager.h"
//#import <MAMapKit/MAPolyline.h>

@interface MapManager (Overlay)

///// 添加单一数据折线
//- (void)category_addSinglePolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates;

/// 添加多数据折线
- (void)category_addPolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count;

@end
