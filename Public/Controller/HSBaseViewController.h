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

@property (nonatomic, assign) BOOL navbarIsTrans;
@property (nonatomic, assign) BOOL navbarIsTranslucent;
@property (nonatomic, assign) BOOL navbarIsDark;


/**
 是否使用 isUseNavbarIsTrans 个别界面使用
 */
@property(nonatomic,assign) BOOL isUseNavbarIsTrans;

// 用户信息
@property(nonatomic,strong)HSUser * userInfo;


- (void)changeNavigationBar ;

@end
