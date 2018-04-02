//
//  HSMainViewController.m
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/7.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "HSMainViewController.h"
#import "HSBorrowViewController.h"
//#import "HSHomeViewController.h"
#import "HSRepaymentViewController.h"
#import "HSPersonCenterViewController.h"
#import "HSNewsViewController.h"
#import "UITabBarItem+HSTabBarItem.h"
#import "XAlertView.h"
#import "HSInterface+Main.h"
#import "SCLoginVerifyViewController.h" //手势密码的验证
#import "SCLoginVerifyView.h"
#import "HSInstalmentMallViewController.h" // 分期商城
//#import "HSTotalRepayViewController.h" //总的差额还款界面
#import "HSRePaymentPlanListViewController.h"
#import "HSNewHomeViewCOntroller.h"
#import "HSRepayMoneyViewController.h"
#import "HSInterface+Repay.h"
#import "HSRepay.h"
#import "HSShareMainViewController.h"
@interface HSMainViewController ()
@property (nonatomic,strong)XAlertView *alertView;
@property (nonatomic,strong)NSArray *listArray;
@end

@implementation HSMainViewController

-(NSArray *)listArray {
    if (!_listArray) {
        _listArray = [NSArray array];
    }
    return _listArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setView];
}



- (void)setView
{
    HSNewHomeViewCOntroller *homeVC = [[HSNewHomeViewCOntroller alloc] init];
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNavi.tabBarItem = [UITabBarItem tabBarItemWithImageName:@"首页" selectedImage:@"首页_sel" title:@"首页"];
    
    UINavigationController *repayNavi;
    HSRepayMoneyViewController *repayMoneyVC = [[HSRepayMoneyViewController alloc]init];
    repayNavi = [[UINavigationController alloc]initWithRootViewController:repayMoneyVC];
    repayNavi.tabBarItem = [UITabBarItem tabBarItemWithImageName:@"还款" selectedImage:@"还款_sel" title:@"还款"];
    
//    HSInstalmentMallViewController *instalmentMallVC = [[HSInstalmentMallViewController alloc]init];
//    UINavigationController *instalmentNavi = [[UINavigationController alloc]initWithRootViewController:instalmentMallVC];
//    instalmentNavi.tabBarItem = [UITabBarItem tabBarItemWithImageName:@"分期商城" selectedImage:@"分期商城_sel" title:@"分期商城"];
    
    
    HSPersonCenterViewController *personCenterVC = [[HSPersonCenterViewController alloc]init];
//    personCenterVC.navbarIsTranslucent = YES;
    UINavigationController *personCenterNavi = [[UINavigationController alloc]initWithRootViewController:personCenterVC];
    personCenterNavi.tabBarItem = [UITabBarItem tabBarItemWithImageName:@"我" selectedImage:@"我_sel" title:@"我的"];
    
    HSShareMainViewController *shareVC = [[HSShareMainViewController alloc]init];
    UINavigationController *shareNavi = [[UINavigationController alloc]initWithRootViewController:shareVC];
    shareNavi.tabBarItem = [UITabBarItem tabBarItemWithImageName:@"share" selectedImage:@"share_sel" title:@"邀请"];
    
    self.viewControllers = @[homeNavi,repayNavi,shareNavi,personCenterNavi];
//    self.viewControllers = @[homeNavi, personCenterNavi];
    
    
    // 设置tabbar顶部分割线图片
    UIImage *img = [UIImage imageNamed:@"tabbar_底部阴影"];
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:img];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTranslucent:NO];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tabBar invalidateIntrinsicContentSize];
}


@end
