//
//  PublicFunction.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicFunction : NSObject

// 获得应用自定义名称
+ (NSString *)appDisplayName;
+ (NSString *)bundleName;
+ (NSString *)bundleID;
/// 获取App的版本号
+ (NSString *)appVersion;

/// 屏幕常亮
+ (void)screenAlwaysOn:(BOOL)turnOn;

/// 计算整个Cache目录大小
+ (float)cacheFolderSize;
/// 清理Cache目录缓存
+ (void)clearCacheFolderWithCompletion:(void (^)(BOOL finished))completion;

@end
