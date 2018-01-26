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
    if (!self) {
        return;
    }
    
    UIImage *backButtonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self.navigationController action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
}

- (void)currentVCBackBarButtonItemWithName:(NSString *)imageName {
    
    if (!self) {
        return;
    }
    UIImage *backButtonImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
    [UINavigationBar appearance].backIndicatorImage = backButtonImage;

    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self.navigationController action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
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
    
    BOOL isIPhoneX = [[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f ? YES : NO;
    CGFloat navHeight = isIPhoneX ? 88.0 : 64.0;
    CGFloat heightDiff = navIsTranlucent ? 0.0 : navHeight;
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
        flag = [self canRemoveViewControllerFromNavigationStackFrom:startClass to:[self class]];
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
    
//    if (flag == NO &&
//        (fromIndex == -1 || toIndex == -1) ||
//        fromIndex >= toIndex) {
    if (flag == NO) {
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

/// 跳转至某个UIViewController，从数组中查找，找到第1个就跳转，如果找不到则什么也不做
- (BOOL)jumpToViewControllerWithClasses:(NSArray<Class> *)viewControllerClasses {
    if (!self) {
        return NO;
    }
    
    BOOL flag = NO;
    UIViewController *destController = nil;
    NSArray *childControllers = [[self.navigationController.childViewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *vc in childControllers) {
        for (Class cls in viewControllerClasses) {
            if ([vc isKindOfClass: cls]) {
                flag = YES;
                destController = vc;
                break;
            }
        }
        if (flag == YES) {
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

/// pop次数
- (void)popToViewControllerWithPopCount:(NSInteger)count {
    NSInteger naviStackCount = self.navigationController.viewControllers.count;
    if (naviStackCount-count > 0) {
        UIViewController *vc = (__kindof UIViewController *)self.navigationController.viewControllers[self.navigationController.viewControllers.count-count-1];
        [self.navigationController popToViewController:vc  animated:YES];
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
@implementation UINavigationController (ShouldPopOnBackButton)


- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count])
    {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)])
    {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end


