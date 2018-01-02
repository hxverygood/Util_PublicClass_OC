//
//  UIViewController+CustomController.h
//  Baili
//
//  Created by 韩啸 on 15/12/24.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (CustomController)<BackButtonHandlerProtocol>

/// 设置下一个退出界面的返回图标
- (void)backBarButtonItemWithImageName:(NSString *)imageName;
/// 设置当前VC的返回按钮
//- (void)currentVCBackBarButtonItemWithName:(NSString *)imageName;

/// 获取当前VC
+ (UIViewController *)currentViewController;

/// 获取当前UIViewController的导航栏高度，透明时为0。
- (CGFloat)naviHeight;



/**
 设置navigationbar 上的一些颜色属性（这里指的都是系统控件的颜色）

 @param backItemColor 返回箭头的颜色
 @param titleColor 标题颜色
 @param backgroundColor 背景颜色
 */
-(void)configNavigationBarByBackItemColor:(UIColor*)backItemColor TitleColor:(UIColor*)titleColor
                   NaviBarBackgroundColor:(UIColor*)backgroundColor;

/**
 设置状态栏的风格

 @param style 系统的枚举
 */
-(void)configStatusBarStyle:(UIStatusBarStyle)style;

/// 从导航栈中移除某个UIViewController
- (void)removeViewControllerFromNavigationStackWith:(Class)viewControllerClass;

/// 跳转至某个UIViewController，如果找不到该Controller则什么也不做
- (BOOL)jumpToViewControllerWith:(Class)viewControllerClass;
/// 跳转至某个UIViewController，从数组中查找，找到第1个就跳转，如果找不到该则什么也不做
- (BOOL)jumpToViewControllerWithClasses:(NSArray<Class> *)viewControllerClasses;

/// 从导航栈中移除fromViewControllerClasses 到[self class]之间的VC
- (void)removeViewControllerFromNavigationStackWithStartControllerClasses:(NSArray *)startClasses;

/// 从导航栈中移除fromViewControllerClass 到 toViewControllerClass之间的VC
- (BOOL)canRemoveViewControllerFromNavigationStackFrom:(Class)fromClass
                                                    to:(Class)toClass;

/// 跳转至某之前的第一个相同的UIViewController（返回YES），如果找不到该Controller则什么也不做，返回NO
- (BOOL)popToFirstSameViewControllerWith:(Class)viewControllerClass;

/// pop次数
- (void)popToViewControllerWithPopCount:(NSInteger)count;

@end
