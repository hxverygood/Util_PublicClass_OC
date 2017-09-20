//
//  RadarWaveLayer.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/21.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "RadarWaveLayer.h"

@interface RadarWaveLayer ()

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat diameter;

@end



@implementation RadarWaveLayer

- (instancetype)initWithDiameter:(CGFloat)diameter
                           color:(UIColor *)color {
    self = [super init];
    
    if (self) {
        self.diameter = diameter;
        self.color = color;
        
        [self setup];
    }
    return self;
}

- (void)setup {
    self.bounds = CGRectMake(0,0, _diameter, _diameter);
    self.cornerRadius = _diameter/2; //设置圆角变为圆形
    self.backgroundColor = [_color colorWithAlphaComponent:0.5].CGColor;
    
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.5;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 2.2;//动画持续时间
    
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.duration = 2.2;
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.repeatCount = INFINITY;//重复无限次
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = defaultCurve;
    animationGroup.duration = 2.2;
    //添加到动画组
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    
    [self addAnimation:animationGroup forKey:@"pulse"];
}

@end
