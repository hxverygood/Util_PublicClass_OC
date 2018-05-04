//
//  HSCrawlerWebPageManager.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/3/28.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HSCrawlerWebPageManager.h"
#import "HSGCDTimerManager.h"
#import "HSCrawlerWebPageModel.h"
#import "HSInterface+Other.h"

static NSString *const HSCrawlerWebPageManagerFileName = @"crawlerWebPage";
//static NSInteger timerCount = 60.0;

@interface HSCrawlerWebPageManager () <HSGCDTimerManagerDelegate>

@property (nonatomic, strong) HSGCDTimerManager *timer;

@property (nonatomic, copy) NSString *vcname;
@property (nonatomic, copy) NSString *phone;

@end

@implementation HSCrawlerWebPageManager

+ (HSCrawlerWebPageManager *)shared
{
    static HSCrawlerWebPageManager *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[HSCrawlerWebPageManager alloc] init];
    });
    return handle;
}

/// 保存webpage打开时的model
- (void)saveWebPageModelWithViewControllerName:(NSString *)vcname
                                         phone:(NSString *)phone {
    if ([self isBlankString:vcname] ||
        [self isBlankString:phone]) {
        return;
    }
    
    self.vcname = vcname;
    self.phone  = phone;
    
    NSString *path = [self pathForName:HSCrawlerWebPageManagerFileName];
    NSString *currentTimeStamp = [NSString getCurrentTimeStamp];
    
    HSCrawlerWebPageModel *model = [[HSCrawlerWebPageModel alloc] init];
    model.viewControllerName = vcname;
    model.startTime = currentTimeStamp;
    model.phone = phone;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
    
//    self.timer = [[HSGCDTimerManager alloc] initWithgcdTimerManagerWithTimerCount:timerCount withTimeInterval:1.0];
//    [self.timer startTimerCompletion:nil];
}

/// 获取保存的model
- (nullable HSCrawlerWebPageModel *)savedWebPageModel {
    NSString *path = [self pathForName:HSCrawlerWebPageManagerFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[HSCrawlerWebPageModel class]]) {
        return obj;
    } else {
        return nil;
    }
}

//- (BOOL)isTimeout {
//    HSCrawlerWebPageModel *model = [self savedWebPageModel];
//    NSString *startTime = model.startTime;
//    NSString *currentTimeStamp = [NSString getCurrentTimeStamp];
//
//}

/// 删除保存的文件
- (void)removeSavedWebPageModel {
//    self.timer = nil;
    
    NSString *path = [self pathForName:HSCrawlerWebPageManagerFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        // 调用关闭链接接口
        [self api_closeWebPageWithCompletion:^(BOOL apiSuccess) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer stopTimer];
        self.timer = nil;
    }
}

///// 获取保存的model
//+ (nullable HSCrawlerWebPageModel *)savedLoginInfo {
//    NSString *path = [self pathForName:HSCrawlerWebPageManagerFileName];
//    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//    if ([obj isKindOfClass:[HSCrawlerWebPageModel class]]) {
//        return obj;
//    } else {
//        return nil;
//    }
//}


#pragma mark - HSGCDTimerManagerDelegate

- (void)timerStop:(HSGCDTimerManager *)timer {
    
}



#pragma mark - API

- (void)api_closeWebPageWithCompletion:(void (^)(BOOL apiSuccess))completion {
    NSString *phone = [self savedWebPageModel].phone;
    if ([NSString isBlankString:phone]) {
        NSLog(@"手机号为空，无法关闭webpage");
        return;
    }
    
    [HSInterface crawlerCloseWebpageWithPhone:phone completion:^(BOOL success, NSString *message, id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                if (completion) {
                    completion(YES);
                }
            } else {
                if (completion) {
                    completion(NO);
                }
                if (![NSString isBlankString:message]) {
                    return;
                }
                [SVProgressHUD dismiss];
            }
        });
    }];
}



#pragma mark - func

- (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array[0] stringByAppendingPathComponent:name];
}

/// 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark - View Controller

/// 获取当前VC
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [HSCrawlerWebPageManager findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

- (BOOL)existViewControllerWithName:(NSString *)vcname {
    Class cls = NSClassFromString(vcname);
    UIViewController *currentVC = [HSCrawlerWebPageManager currentViewController];
    NSArray *childControllers = [[currentVC.navigationController.childViewControllers reverseObjectEnumerator] allObjects];
    for (UIViewController *vc in childControllers) {
        if ([vc isKindOfClass: cls]) {
            return YES;
        }
    }
    return NO;
}

@end
