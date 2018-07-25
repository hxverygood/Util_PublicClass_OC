//
//  MapManager+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager+Utils.h"

@implementation MapManager (Utils)

/// 计算2点间的直线距离
+ (double)distanceBetweenPoint:(CLLocationCoordinate2D)one
                  anotherPoint:(CLLocationCoordinate2D)two {
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(one);
    MAMapPoint point2 = MAMapPointForCoordinate(two);

    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    return distance;
}

@end
