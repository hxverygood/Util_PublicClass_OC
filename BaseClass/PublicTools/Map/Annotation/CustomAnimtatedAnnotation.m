//
//  CustomAnimtatedAnnotation.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/21.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "CustomAnimtatedAnnotation.h"
#import <MAMapKit/MAAnimatedAnnotation.h>

@implementation CustomAnimtatedAnnotation

/// 获取所有未完成的移动动画, 返回数组内为MAAnnotationMoveAnimation对象
- (NSArray<MAAnnotationMoveAnimation*> *)allWillMovedAnimations {
    return [self allMoveAnimations];
}

/// 取消未完成的动画
- (void)cancelAnimation {
    for (MAAnnotationMoveAnimation *animation in [self allWillMovedAnimations]) {
        [animation cancel];
    }
}

@end
