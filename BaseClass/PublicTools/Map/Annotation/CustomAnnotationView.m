//
//  CustomAnnotationView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/19.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "CustomAnnotationView.h"

@interface CustomAnnotationView ()

@end



@implementation CustomAnnotationView

#pragma mark - Initializer

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self) {
        self.image = [UIImage imageNamed:@"ic_point"];
    }

    return self;
}



#pragma mark -

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }

    if (selected) {
        if (self.calloutView == nil) {
            /* Construct custom callout. */
            self.calloutView = [CustomCalloutView view];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }

        [self addSubview:self.calloutView];
    }
    else {
        [self.calloutView removeFromSuperview];
    }

    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected) {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }

    return inside;
}



#pragma mark - Action


@end
