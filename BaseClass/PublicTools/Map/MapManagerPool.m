//
//  MapManagerPool.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/10.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManagerPool.h"
#import "MapManager.h"
#import "QSThreadSafeMutableDictionary.h"

@interface MapManagerPool ()

@property (nonatomic, strong) QSThreadSafeMutableDictionary *mapManagerDictPool;

@end



@implementation MapManagerPool

#pragma mark - Getter

- (QSThreadSafeMutableDictionary *)mapManagerDictPool {
    if (!_mapManagerDictPool) {
        _mapManagerDictPool = [QSThreadSafeMutableDictionary dictionary];
    }
    return _mapManagerDictPool;
}

//- (NSArray *)mapManagerList {
//    return [self.mapManagerDictPool copy];
//}



#pragma mark - Initializer

+ (MapManagerPool *)shared {
    static MapManagerPool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[MapManagerPool alloc] init];
        }
    });
    return instance;
}



#pragma mark - Func

/// 用viewController的className作为key，mapManager作为value存储在字典中
- (void)addMapManager:(MapManager *)mapManager viewControllerClass:(Class)cls {
    NSString *className = NSStringFromClass(cls);
    [self.mapManagerDictPool setObject:mapManager forKey:className];
    NSLog(@"addMapManager:");
}

/// 查找viewControllerName对应的mapManager，开启mapManager的定位
- (void)restartLocatingWithControllerName:(NSString *)controllerName {
    id obj = [self.mapManagerDictPool valueForKey:controllerName];
    if ([obj isKindOfClass:[MapManager class]]) {
        MapManager *mapManager = (MapManager *)obj;
        [mapManager restartBackgroudLocation];
        NSLog(@"重新开启后台定位");
    }
}

/// 查找controllerName对应的value(MapManager类型)，停止mapManager的定位
- (void)stopLocatingWithControllerName:(NSString *)controllerName {
    [self.mapManagerDictPool objectForKey:controllerName];
    NSLog(@"stopLocating");
}

/// 查找controllerName对应的mapManager，停止mapManager的定位并置为nil
- (void)stopLocatingAndRemoveMapManagerWithControllerName:(NSString *)controllerName {
    id obj = [self.mapManagerDictPool valueForKey:controllerName];
    if ([obj isKindOfClass:[MapManager class]]) {
        MapManager *mapManager = (MapManager *)obj;
        [mapManager stopUpdatingLocation];
        [self.mapManagerDictPool removeObjectForKey:controllerName];
        mapManager.mapView = nil;
        mapManager = nil;
        NSLog(@"stopLocatingAndRemoveMapManager:");
    }
}

/// 停止所有mapManager定位，并移除所有保存的mapManager，最后置为nil
- (void)stopLocatingAndRemoveAllManager {
    NSArray *keys = self.mapManagerDictPool.allKeys;

    int i = 0;
    for (; i < keys.count; i++) {
        id obj = [self.mapManagerDictPool valueForKey:keys[i]];
        if ([obj isKindOfClass:[MapManager class]]) {
            MapManager *mapManager = (MapManager *)obj;
            [mapManager stopUpdatingLocation];
            [self.mapManagerDictPool removeObjectForKey:keys[i]];
            mapManager = nil;
        }
    }

    if (i == keys.count) {
        NSLog(@"stopLocatingAndRemoveAllManager:");
    }
}


@end
