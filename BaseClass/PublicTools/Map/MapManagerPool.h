//
//  MapManagerPool.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/10.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapManager;

@interface MapManagerPool : NSObject

@property (nonatomic, strong, readonly) NSArray *mapManagerList;

/// 主要用于管理产生后台持续定位产生的MapManager
+ (MapManagerPool *)shared;

/// 用viewController的className作为key，mapManager作为value存储在字典中
- (void)addMapManager:(MapManager *)mapManager viewControllerClass:(Class)cls;

/// 查找viewControllerName对应的mapManager，开启mapManager的定位
- (void)restartLocatingWithControllerName:(NSString *)controllerName;

/// 查找viewControllerName对应的value(MapManager类型)，停止mapManager的定位
- (void)stopLocatingWithControllerName:(NSString *)controllerName;

/// 查找viewControllerName对应的mapManager，停止mapManager的定位并置为nil
- (void)stopLocatingAndRemoveMapManagerWithControllerName:(NSString *)controllerName;

/// 停止所有mapManager定位，并移除所有保存的mapManager，最后置为nil
- (void)stopLocatingAndRemoveAllManager;

@end
