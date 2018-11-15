//
//  MapNaviInfoView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/25.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapNaviInfoView : UIView

+ (instancetype)view;
- (void)setRemainDistance:(NSString *)distance;
- (void)setTurnImageWithIndex:(NSInteger)index;
- (void)setCurrentRoadName:(NSString *)currentRoadName;
- (void)setNextRoadName:(NSString *)nextRoadName;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
