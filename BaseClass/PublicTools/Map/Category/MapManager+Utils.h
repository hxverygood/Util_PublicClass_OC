//
//  MapManager+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager.h"

@interface MapManager (Utils)

/// 计算2点间的直线距离
+ (double)distanceBetweenPoint:(CLLocationCoordinate2D)one
                  anotherPoint:(CLLocationCoordinate2D)two;

@end
