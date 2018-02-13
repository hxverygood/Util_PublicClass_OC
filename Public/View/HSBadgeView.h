//
//  HSBadgeView.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/2/2.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BadgeStyle) {
    BadgeStyleDot = 0       // 圆点角标
};

@interface HSBadgeView : UIView

@property (nonatomic, assign) BadgeStyle badgeStyle;
@property (nonatomic, strong) UIColor *badgeColor;

/// 初始化角标
- (instancetype)initWithFrame:(CGRect)frame
                   badgeStyle:(BadgeStyle)badgeStyle;

@end
