//
//  MapManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/14.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>

//@class CLLocation;
//@class AMapLocationReGeocode;
//@class MAPointAnnotation;


typedef void (^LocationUpdateBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);

//typedef NS_ENUM(NSInteger, AnnotationViewStyle) {
//    AnnotationViewStyleDefault,             // 默认pin样式
//    AnnotationViewStyleCustom               // 用户自定义pin
//};


@protocol AnnotationViewDelegate <NSObject>

@optional
- (void)annotationViewSelectWithIndex:(NSInteger)index;

@end


@interface MapManager : NSObject

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, copy, readonly) CLLocation *currentLocation;
@property (nonatomic, copy, readonly) AMapLocationReGeocode *currentRegeocode;
@property (nonatomic, weak) id<AnnotationViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedAnnotationIndex;


//+ (MapManager *)sharedManager;
- (void)addMapInView:(UIView *)mapContainerView
               frame:(CGRect)frame;

/// 一次定位
- (void)startLocationOnceWithCompletion:(void (^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))completion;
/// 在回调存在的情况下 开始 后台/持续 定位
- (void)restartBackgroudLocation;

/// 开始 后台/持续 定位
- (void)startBackgroudLocationWithCompletion:(LocationUpdateBlock)completion;

/// 停止定位
- (void)stopUpdatingLocation;


/**
 添加一组点标记

 @param annotations 标记
 @param needRefreshAnnotations 是否需要删除原有标记
 */
- (void)addAnnotations:(NSArray *)annotations
    refreshAnnotations:(BOOL)needRefreshAnnotations;
/// 选择某个标记（标记变为选中样式）
- (void)selectSingleAnnotationWithIndex:(NSInteger)index;
/// 在地图上删除所有点标记（除了中心点）
- (void)removeAllAnnotations;
/// 将选中的仓库定位点重置为默认的仓库样式
- (void)resetDepotAnnotation;
/// 移除远程推送订单选中的仓库
- (void)removeRemoteSeletedAnnotation;

/// 重置选中参考的序号
- (void)resetSelectedAnnotationIndex;

/// 添加单一数据折线
//- (void)addSinglePolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates;
/// 添加多数据折线
- (void)addPolylineWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count;

@end
