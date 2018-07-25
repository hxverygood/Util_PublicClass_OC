//
//  CustomAnnotation.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/20.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <MAMapKit/MAPointAnnotation.h>

typedef NS_ENUM(NSInteger, CustomAnnotationStyle) {
    CustomAnnotationStyleDefault,                   // 默认anno
    CustomAnnotationStyleMapCenter,                 // 地图中心anno
    CustomAnnotationStyleUserLocation,              // 用户定位anno
    CustomAnnotationStyleAnimation,                 // 点平滑移动
    CustomAnnotationStyleNaviStartPoint,            // 导航起始点
    CustomAnnotationStyleNaviEndPoint,              // 导航终点
    CustomAnnotationStyleNaviWayPoints,             // 导航途经点
    CustomAnnotationStyleCustom,                    // 用户自定义anno
};


@protocol CustomAnnotation <NSObject>

@optional
@property (nonatomic, assign) CustomAnnotationStyle style;
@property (nonatomic, copy) NSString *imageName;

@end



@interface CustomAnnotation : MAPointAnnotation <MAAnnotation, CustomAnnotation>

@property (nonatomic, assign) CustomAnnotationStyle style;
@property (nonatomic, copy) NSString *imageName;

@end
