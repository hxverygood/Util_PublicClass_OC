//
//  RadarWaveLayer.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/21.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface RadarWaveLayer : CALayer

- (instancetype)initWithDiameter:(CGFloat)diameter
                           color:(UIColor *)color;

@end
