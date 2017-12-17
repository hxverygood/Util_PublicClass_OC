//
//  HSTableFooterView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTableFooterView : UIView

@property (nonatomic, copy) void (^buttonAction)(void);

+ (instancetype)view;

- (void)setButtonTitle:(NSString *)title;

@end
