//
//  MapManager+AMapSearch.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/20.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapManager (AMapSearch)

@property (nonatomic, copy) void (^reGeocodeSearchBlock)(NSError *error, AMapReGeocode *regeocode);

@end
