//
//  HSBaseGradientLayer.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/26.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface HSBaseGradientLayer : CAGradientLayer

- (instancetype)initWithFrame:(CGRect)frame
                       colors:(NSArray<UIColor *> *)colors;

@end
