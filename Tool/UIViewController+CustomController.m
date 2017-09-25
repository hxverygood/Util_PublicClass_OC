//
//  UIViewController+CustomController.m
//  Baili
//
//  Created by 韩啸 on 15/12/24.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import "UIViewController+CustomController.h"

@implementation UIViewController (CustomController)

//+ (instancetype)backBarButtonItemWithImageName:(NSString *)imageName {
//    return [[UIViewController alloc] initBackBarButtonItemWithImageName:imageName];
//}

/// 设置下一个push界面的返回按钮图标
- (void)backBarButtonItemWithImageName:(NSString *)imageName {
    if (self) {
        UIImage *backButtonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        id appearance = nil;
        if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
            appearance = [UIBarButtonItem appearanceWhenContainedIn:[self.navigationController class], nil];
        } else {
            appearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self.navigationController class]]];
        }
        
        [appearance setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self.navigationController action:nil];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
        self.navigationItem.backBarButtonItem.title = @"";
        self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    }
}


/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (CGFloat)naviHeight
{
    BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
    CGFloat heightDiff = navIsTranlucent ? 0.0 : 64.0;
    return heightDiff;
}
-(void)configNavigationBarByBackItemColor:(UIColor*)backItemColor TitleColor:(UIColor*)titleColor
                   NaviBarBackgroundColor:(UIColor*)backgroundColor
{
    //返回键的颜色
//    [[UINavigationBar appearance] setTintColor:backItemColor];
    //title的颜色
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:titleColor}];
    //背景颜色
    [[UINavigationBar appearance] setBarTintColor:backgroundColor];
}

/// 配置状态栏样式
-(void)configStatusBarStyle:(UIStatusBarStyle)style
{
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
}

/// 从导航栈中移除某个UIViewController
- (void)removeViewControllerFromNavigationStackWith:(Class)viewControllerClass {
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.childViewControllers];
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:viewControllerClass]) {
            [viewControllers removeObject:vc];
        }
    }
    
    self.navigationController.viewControllers = viewControllers;
    
//    NSArray* tempVCA = [self.navigationController viewControllers];
//    
//    for(UIViewController *tempVC in tempVCA)
//    {
//        if([tempVC isKindOfClass:viewControllerClass])
//        {
//            [tempVC removeFromParentViewController];
//        }
//    }
}

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC
- (void)removeViewControllerFromNavigationStackWithStartControllerClasses:(NSArray *)startClasses {
    for (int i = 0; i < startClasses.count; i++) {
        Class startClass = startClasses[i];
        BOOL flag;
        flag = [self canRemoveViewControllerFromNavigationStackFrom:startClass to: [self class]];
        if (flag) {
            break;
        }
    }
}

/// 从导航栈中移除fromViewControllerClass 到 toViewControllerClass之间的VC
- (BOOL)canRemoveViewControllerFromNavigationStackFrom:(Class)fromClass
                                                    to:(Class)toClass {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    // 将要删除的VC放到该数组中
    NSMutableArray *removedVCs = [NSMutableArray array];
    
    NSInteger fromIndex = -1;
    NSInteger toIndex = -1;
    /// 是否发现起始VC
    BOOL flag = NO;
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:fromClass]) {
            fromIndex = i;
            flag = YES;
        } else if ([vc isKindOfClass:toClass]) {
            toIndex = i;
        }
        
        // 如果已发现起始VC，并且viewController不为要删除的VC时，记录到要删除的数组中
        if (flag == YES &&
            i != fromIndex &&
            i != toIndex) {
            [removedVCs addObject:vc];
        }
    }
    
    if (flag == NO &&
        fromIndex == -1 &&
        toIndex == -1 &&
        fromIndex >= toIndex) {
        return NO;
    }
    
    for (UIViewController *vc in removedVCs) {
        [viewControllers removeObject:vc];
    }
    
    self.navigationController.viewControllers = viewControllers;
    return YES;
}

/// 跳转至某个UIViewController，如果找不到该Controller则什么也不做
- (BOOL)jumpToViewControllerWith:(Class)viewControllerClass {
    if (!self) {
        return NO;
    }
    
    BOOL flag = NO;
    UIViewController *destController = nil;
    NSArray *childControllers = self.navigationController.childViewControllers;
    for (UIViewController *vc in childControllers) {
        if ([vc isKindOfClass: viewControllerClass]) {
            flag = YES;
            destController = vc;
            break;
        }
    }
    
    if (flag == YES) {
        [self.navigationController popToViewController:destController animated:YES];
    }
    return flag;
}

/// 跳转至某之前的第一个相同的UIViewController（返回YES），如果找不到该Controller则什么也不做，返回NO
- (BOOL)popToFirstSameViewControllerWith:(Class)viewControllerClass {
    if (!self) {
        return NO;
    }
    
    NSMutableArray *lastSomeVCArray = [NSMutableArray array];
    NSArray *childControllers = self.navigationController.childViewControllers;
    for (UIViewController *vc in childControllers) {
        if ([vc isKindOfClass: viewControllerClass]) {
            [lastSomeVCArray addObject:vc];
        }
    }
    if (lastSomeVCArray.count > 0) {
        [self.navigationController popToViewController:[lastSomeVCArray firstObject] animated:YES];
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - Private Func

- (BOOL)containViewControllerWith:(Class)viewControllerClass {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    BOOL flag = NO;
    
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *vc = viewControllers[i];
        if ([vc isKindOfClass:viewControllerClass]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

@end
