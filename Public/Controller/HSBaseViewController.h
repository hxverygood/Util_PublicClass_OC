//
//  HSBaseViewController.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/10.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BaseViewControllerStyle) {
    BaseViewControllerStyleDark
};



@interface HSBaseViewController : UIViewController

@property (nonatomic, assign) BOOL navbarIsTranslucent;
@property (nonatomic, assign) BOOL navbarIsDark;

@end
