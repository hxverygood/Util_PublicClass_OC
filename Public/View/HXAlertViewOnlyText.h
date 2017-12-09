//
//  HXAlertViewOnlyText.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/6.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXAlertViewOnlyText : UIView

+ (instancetype)alertViewWithContent:(NSString *)content;

- (void)showWithConfirmButtonPressed:(void (^)(void))confirmButtonPressed;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end
