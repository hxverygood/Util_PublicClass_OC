//
//  BaseViewController.m
//
//  Created by hans on 2017/8/10.
//  Copyright © 2017年. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+HSImage.h"

static CGFloat naviFontSize = 18.0;

@interface BaseViewController ()

@property (nonatomic, assign) BOOL navbarIsTrans;

@end



@implementation BaseViewController

#pragma mark - Getter

- (LDUser *)user {
    return [LoginInfo savedLoginInfo];
}

- (LDUserBasicInfoModel *)basicInfo {
    return [LoginInfo savedBasicInfo];
}



#pragma mark - UI

- (instancetype)init {
    
    self = [super init];
    if (self)
    {
        self.isUseNavbarIsTrans = YES;
    }
    return self;
}

//- (HSUser*)userInfo
//{
//    return [HSLoginInfo savedLoginInfo];
//}

//- (LocationManager*)locationManager
//{
//   return [LocationManager sharedManager];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self adapterForIOSVersion];
    [self changeNavigationBar];
    [self hideNavigationBarShadowImage:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navbarIsTrans = _navbarIsTranslucent;
//    // 背景色
//    self.view.backgroundColor = BackgroudColor;
}



#pragma mark - Private Func

- (void)changeNavigationBar {
    
    if (_navbarIsDark) {
        self.navigationController.navigationBar.hidden = NO;
        
        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        // 返回按钮
        [self backBarButtonItemWithImageName:@"ic_back"];
        
        //[self backBarButtonItemWithImageName:@""];
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:naviFontSize],
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
        self.navigationController.navigationBar.hidden = NO;

        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

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
        @{NSFontAttributeName:[UIFont systemFontOfSize:naviFontSize],
          NSForegroundColorAttributeName:[UIColor whiteColor]};

        // 返回按钮
        [self backBarButtonItemWithImageName:@"ic_back"];
        
    }
    else {
        self.navigationController.navigationBar.hidden = NO;

        // 状态栏样式
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //[self backBarButtonItemWithImageName:@""];
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.edgesForExtendedLayout = UIRectEdgeTop;
        // navbar title的颜色
        self.navigationController.navigationBar.titleTextAttributes = \
        @{NSFontAttributeName:[UIFont systemFontOfSize:naviFontSize],
          NSForegroundColorAttributeName:[UIColor whiteColor]};
        // navbar背景颜色
        self.navigationController.navigationBar.barTintColor = MainColor;

        // 返回按钮
        [self backBarButtonItemWithImageName:@"ic_back"];
        
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


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/// 是否隐藏导航栏下的分隔线
- (void)hideNavigationBarShadowImage:(BOOL)hide {
    if (self.navigationController.navigationBar.translucent) {
        // translucent = YES
        if (self.navigationController.navigationBar.subviews.count > 0 &&
            self.navigationController.navigationBar.subviews[0].subviews.count > 1) {
            self.navigationController.navigationBar.subviews[0].subviews[1].hidden = hide;
        }
    } else {
        // translucent = NO
        if (self.navigationController.navigationBar.subviews.count > 0 &&
            self.navigationController.navigationBar.subviews[0].subviews.count > 0) {
            self.navigationController.navigationBar.subviews[0].subviews[0].hidden = hide;
        }
    }
}


#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
