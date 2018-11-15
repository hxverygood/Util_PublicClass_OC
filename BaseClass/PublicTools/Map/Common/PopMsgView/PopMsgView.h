//
//  PopMsgView.h
//  DevDemoNavi
//
//  Created by eidan on 2018/1/25.
//  Copyright © 2018年 Amap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopMsgView : UIView

- (void)showMsg:(NSString *)msg inThe:(UIView *)parentView;

@end

#pragma mark - TimerTarget

@interface TimerTarget : NSObject

@property (nonatomic, weak) id realTarget;

- (void)animationFade;

@end
