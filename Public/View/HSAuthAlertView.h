//
//  HSAuthAlertView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/9.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAuthAlertView : UIView

+ (instancetype)alertViewWithTitle:(NSString *)title
                      butttonTitle:(NSString *)buttonTitle
                buttonPressedBlock:(void (^)())buttonPressedBlock
               cancelButtonPressed:(void (^)())cancelButtonPressed;

- (void)show;

@end
