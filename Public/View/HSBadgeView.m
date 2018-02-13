//
//  HSBadgeView.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/2/2.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HSBadgeView.h"



@interface HSBadgeView ()

@end



@implementation HSBadgeView

#pragma mark - Setter

- (void)setBadgeStyle:(BadgeStyle)badgeStyle {
    _badgeStyle = badgeStyle;
    
    switch (badgeStyle) {
        case BadgeStyleDot:
            self.layer.cornerRadius = self.frame.size.height/2;
            self.layer.masksToBounds = YES;
            break;
            
        default:
            break;
    }
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    _badgeColor = badgeColor;
    
    self.backgroundColor = badgeColor;
}


#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                   badgeStyle:(BadgeStyle)badgeStyle {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.cornerRadius = frame.size.height/2;
        self.layer.masksToBounds = YES;
        self.badgeStyle = badgeStyle;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}

@end
