//
//  CustomAnimtatedAnnotation.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/21.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotation.h"

@interface CustomAnimtatedAnnotation : MAAnimatedAnnotation <CustomAnnotation>

@property (nonatomic, assign) CustomAnnotationStyle style;
@property (nonatomic, copy) NSString *imageName;

/// 获取所有未完成的移动动画, 返回数组内为MAAnnotationMoveAnimation对象
- (NSArray<MAAnnotationMoveAnimation*> *)allWillMovedAnimations;

/// 取消未完成的动画
- (void)cancelAnimation;

@end
