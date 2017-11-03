//
//  HSBaseViewController.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/10.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseViewController.h"
#import "UIImage+HSImage.h"

@interface HSBaseViewController ()

@property (nonatomic, assign) BOOL navbarIsTrans;

@end

@implementation HSBaseViewController

#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self changeNavigationBar];
    [self adapterForIOSVersion];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navbarIsTrans = _navbarIsTranslucent;
}



#pragma mark - Private Func

- (void)changeNavigationBar {
    
    if (_navbarIsDark) {
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        // 返回按钮
        [self backBarButtonItemWithImageName:@"button_back_white"];
        
        //[self backBarButtonItemWithImageName:@""];
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
          NSForegroundColorAttributeName:[UIColor whiteColor]};
        // navbar背景颜色
        //        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:53/255.0 green:57/255.0 blue:66/255.0 alpha:1.0];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38/255.0 green:41/255.0 blue:48/255.0 alpha:1.0];
        
        return;
    }
    
    if (_navbarIsTrans) {
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        // 返回按钮
        [self backBarButtonItemWithImageName:@"button_back_white"];
        //[self backBarButtonItemWithImageName:@"button_back"];
        
        self.navigationController.navigationBar.translucent = YES;
        // 导航栏背景透明
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        // navbar背景颜色
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        
        
        self.navigationController.edgesForExtendedLayout = UIRectEdgeTop;
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
          NSForegroundColorAttributeName:[UIColor whiteColor]};
        
    } else {
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        // 返回按钮
//        [self backBarButtonItemWithImageName:@"button_back"];
        [self backBarButtonItemWithImageName:@"button_back"];
        //[self backBarButtonItemWithImageName:@""];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.edgesForExtendedLayout = UIRectEdgeTop;
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
          NSForegroundColorAttributeName:[UIColor blackColor]};
        // navbar背景颜色
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
}

/// 对不同的iOS版本进行适配
- (void)adapterForIOSVersion {
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
