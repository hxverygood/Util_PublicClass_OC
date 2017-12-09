//
//  HXAlertView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/6.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXAlertView : UIView

+ (instancetype)alertViewWithImageName:(NSString *)imageName
                               content:(NSString *)content;

- (void)show;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end
