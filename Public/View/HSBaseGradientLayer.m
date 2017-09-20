//
//  HSBaseGradientLayer.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/26.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseGradientLayer.h"

@interface HSBaseGradientLayer ()

@property (nonatomic, strong) NSArray *defaultGradientColors;

@end



@implementation HSBaseGradientLayer

#pragma mark - Getter

- (NSArray<UIColor *> *)defaultGradientColors {
    if (!_defaultGradientColors) {
        NSArray<UIColor *> *colors = [NSArray arrayWithObjects:
                                      // left
                                      [UIColor colorWithRed:255/255.0 green:104/255.0 blue:44/255.0 alpha:1.0],
                                      // right
                                      [UIColor colorWithRed:255/255.0 green:6/255.0 blue:6/255.0 alpha:1.0],
                                      nil];
        _defaultGradientColors = colors;
    }
    return _defaultGradientColors;
}


#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                       colors:(NSArray<UIColor *> *)colors {
    self = [super init];
    if (self) {
        NSMutableArray *cgColorArray = [NSMutableArray array];
        if (colors) {
            for (UIColor *color in colors) {
                [cgColorArray addObject:(id)color.CGColor];
            }
        } else {
            for (UIColor *color in self.defaultGradientColors) {
                [cgColorArray addObject:(id)color.CGColor];
            }
        }
        self.colors = cgColorArray;
        self.startPoint = CGPointMake(0.5, 0.0);
        self.endPoint = CGPointMake(0.5, 1.0);
        self.frame = frame;
    }
    return self;
}

@end
