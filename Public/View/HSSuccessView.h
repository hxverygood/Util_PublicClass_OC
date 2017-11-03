//
//  HSSuccessView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSuccessView : UIView

+ (instancetype)showSucccessViewWithImageName:(NSString *)imageName
                                      content:(NSString *)content
                           closeButtonPressed:(void (^)(void))closelButtonPressedBlock;

@end
