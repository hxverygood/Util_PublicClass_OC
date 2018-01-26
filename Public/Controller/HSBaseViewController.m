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


@end

@implementation HSBaseViewController

#pragma mark - UI

-(instancetype)init{
    
    self  =[super init];
    if (self)
    {
        self.isUseNavbarIsTrans = YES;
    }
    return self;
}

-(HSUser*)userInfo
{
    return [HSLoginInfo savedLoginInfo];
}

-(LocationManager*)locationManager
{
   return [LocationManager sharedManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self adapterForIOSVersion];
    [self changeNavigationBar];
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
      
    if (!_isUseNavbarIsTrans)
    {
        return;
    }
    
    if (_navbarIsTrans) {
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

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
        
    } else
    {
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        // 返回按钮
        [self backBarButtonItemWithImageName:@"button_back_white"];
        //[self backBarButtonItemWithImageName:@""];
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.edgesForExtendedLayout = UIRectEdgeTop;
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
          NSForegroundColorAttributeName:[UIColor whiteColor]};
        // navbar背景颜色
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        
//        // 状态栏样式
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//
//        // 返回按钮
//        [self backBarButtonItemWithImageName:@"button_back_white"];
//
//        // navbar title的颜色
//        self.navigationController.navigationBar.titleTextAttributes = \
//        @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],
//          NSForegroundColorAttributeName:[UIColor whiteColor]};
//        // navbar背景颜色
//        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38/255.0 green:41/255.0 blue:48/255.0 alpha:1.0];
        
        return;
    }
}

/// 对不同的iOS版本进行适配
- (void)adapterForIOSVersion {
    if (@available(iOS 11.0, *)) {
//        self.additionalSafeAreaInsets = UIEdgeInsetsMake(0.0, 0.0, 34.0, 0.0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
