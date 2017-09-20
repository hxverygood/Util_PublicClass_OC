//
//  HSAuthCompletionView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/10.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAuthCompletionView : UIView

+ (instancetype)alertSuccessViewWithLimit:(NSString *)limit
                       buttonPressedBlock:(void (^)(BOOL applyButtonPressed, BOOL promptLimitButtonPressed))buttonPressedBlock;

- (void)show;

@end
