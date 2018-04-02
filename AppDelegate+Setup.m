//
//  AppDelegate+Setup.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "AppDelegate+Setup.h"
#import "MZGuidePages.h"                // 引导页
#import "HSSignMessageListViewController.h"                 // 签约列表VC
#import "HSMessageConterViewController.h"                   // 消息中心

#if DEBUG
#import "FLEXManager.h"
#elif PREPRODUCTION
#import "FLEXManager.h"
#endif

//#import "HSHomeViewController.h"
//
//#import "HSInterface+HSUserInfo.h"
//#import "HSUserInfoModel.h"
//#import "HSMobileBelongModel.h"

//#import "HSInterface+Main.h"            // 首页API
//#import "HSHomeDataModel.h"             // 首页数据模型
//#import "HSHomeDetailViewController.h"            // 申请借款VC
//
//#import "HSCertificateViewController.h"             // 实名认证VC
//#import "HSCareerViewController.h"                  // 工作单位信息认证VC
//#import "HSZhimaWebViewController.h"
//#import "HSCallRecordsChinaMobileFirstViewContro ller.h"
//#import "HSCallRecordsChinaUnicornFirstViewController.h"
//#import "HSCallRecordsChinaTelecomVC.h"
//#import "HSContactInfoViewController.h"             // 联系人信息认证VC
//#import "HSCreditInvestigationViewController.h"     // 征信认证VC
//#import "HSInfoAuthViewController.h"                // 认证VC
//#import "HSTaobaoWebViewController.h"                  // 淘宝VC
//#import "HSAccumulationFundAndSocialSecurityTableVC.h"  // 社保、公积金VC
//#import "HSCHSIAccountRegistrationViewController.h"     // 学信网认证

//#include <CommonCrypto/CommonCrypto.h>
//#include <zlib.h>



//这里的参数均为JPush推送的数据字段

//static NSString *jpushAppKey = @"68ca2234b457b574920ab1c8";

//#warning fix: JPush App Key
//// 极光推送 - 应用名称：红上金服_2017.11.14
//static NSString *jpushAppKey = @"e445e606b80a30deef7f8a98";
//static NSString *channel = @"App Store";
//#ifdef DEBUG
//static BOOL isProduction = NO;
//#else
//static BOOL isProduction = YES;
//#endif



@implementation AppDelegate (Setup)

#pragma mark - 基本配置
/// 一些基本的配置
- (void)config {
    // 导航栏透明度
    [[UINavigationBar appearance] setTranslucent:NO];
    //返回键的颜色
//    [UINavigationBar appearance].tintColor  = [UIColor whiteColor];
    //title的颜色
    UIColor *titleColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:titleColor}];
    //背景颜色
//    [[UINavigationBar appearance] setBarTintColor:Blue];
    
    // 配置SVProgressHUD
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.85f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:12.0f];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:0.8];
    [SVProgressHUD setMinimumSize:CGSizeMake(60.0f, 60.0f)];
    
//    // 配置MJRrefresh图片
//    UIImage *oneImage = [UIImage imageNamed:@"refresh"];
//    UIImage *twoImage = [UIImage imageNamed:@"refresh"];
//    UIImage *threeImage = [UIImage imageNamed:@"refresh"];
//    UIImage *fourImage = [UIImage imageNamed:@"refresh"];
//    NSArray *images = @[oneImage,twoImage,threeImage,fourImage];
//    NSArray *successImage = @[threeImage,fourImage];
////
//    // 刷新用到的动图
//    [HSHelper sharedHelper].imagesForIdleState = images;
//    [HSHelper sharedHelper].imagesForPullingState = images;
//    [HSHelper sharedHelper].imagesForRefreshingState = successImage;
    
#if DEBUG
//    [[FLEXManager sharedManager] showExplorer];
#elif PREPRODUCTION
    [[FLEXManager sharedManager] showExplorer];
#endif
}


//#pragma mark - 极光推送
//
//-(void)setupNotificationMessageWithOptions:(NSDictionary *)launchOptions {
//    // Required
//    // notice: 3.0.0及以后版本注册可以这样写，也可以继续旧的注册方式
//    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加 定义categories
//        //NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    // Required
//    // init Push
//    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
//    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions
//                           appKey:jpushAppKey
//                          channel:channel
//                 apsForProduction:isProduction
//            advertisingIdentifier:nil];
//
//
//    // apn 内容获取：
//    __unused NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
//}
//
//- (void)registerDeviceWithToken:(NSData *)deviceToken {
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//    /// 获取registrationID并上传到服务器
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if(resCode == 0){
//            if (!registrationID) {
//                return;
//            }
//            [HSLoginInfo saveRegistrationID:registrationID];
//        }
//    }];
//}
//
//
//
//#pragma mark APNs通知回调方法
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    // 收到推送的请求
//    UNNotificationRequest *request = notification.request;
//    // 收到推送的消息内容
//    //    UNNotificationContent *content = request.content;
//
//    if([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            // 程序运行时收到通知，不会通过通知栏及声音进行提醒，所以可以弹出自定义消息View
//            //            [self getPushMessageAtStateActive:userInfo];
//            NSLog(@"++++++ app在前台收到推送通知 willPresentNotification ++++++");
//            //            [self pushToViewControllerWhenClickPushMessageWith:userInfo];
//        }
//        else {
//            // 程序在后台运行或者已经关闭的情况
//            [self pushToViewControllerWhenClickPushMessageWith:userInfo];
//        }
//    }
//
//    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//            // 程序运行时收到通知，不会通过通知栏及声音进行提醒，所以可以弹出自定义消息View
//            //            [self getPushMessageAtStateActive:userInfo];
//            NSLog(@"++++++ app在前台收到推送通知 didReceiveNotificationResponse ++++++");
//            [self pushToViewControllerWhenClickPushMessageWith:userInfo];
//        }
//        else {
//            // 程序在后台运行或者已经关闭的情况
//            [self pushToViewControllerWhenClickPushMessageWith:userInfo];
//        }
//    }
//    completionHandler();  // 系统要求执行这个方法
//}
//
//- (void)didReceiveRemoteNotificationForIOS7:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//}
//
//- (void)didReceiveRemoteNotificationLessThanIOS7:(NSDictionary *)userInfo {
//    [JPUSHService handleRemoteNotification:userInfo];
//}



#pragma mark - Func

//#pragma mark 程序运行时收到通知
//- (void)getPushMessageAtStateActive:(NSDictionary *)pushMessageDic {
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[[pushMessageDic objectForKey:@"aps"]objectForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self pushToViewControllerWhenClickPushMessageWith:pushMessageDic];
//    }];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    
//    [alertController addAction:confirmAction];
//    [alertController addAction:cancelAction];
//    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//}
//
//- (void)pushToViewControllerWhenClickPushMessageWith:(NSDictionary*)msgDic {
//    //判断是否登录，如果没有登录则跳转至登录界面
//    if (![HSLoginInfo judgeLoginStatus]) {
//        UIViewController *currentVC = [UIViewController currentViewController];
//        if ([currentVC isKindOfClass:[HSRegisterOneStepViewController class]]) {
//            return;
//        }
//        
//        HSRegisterOneStepViewController *vc = [[HSRegisterOneStepViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//        
//        [currentVC presentViewController:navi animated:YES completion:nil];
//        return;
//    }
//    
//    HSMessageConterViewController *vc = [[HSMessageConterViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    UIViewController *currentVC = [UIViewController currentViewController];
//    [currentVC.navigationController pushViewController:vc animated:YES];
//    
////    NSString *flag = [msgDic ac_stringForKey:@"flag"];
////    NSLog(@"推送附加字段flag: %@", flag);
////
////    if (!flag || [NSString isBlankString:flag]) {
////        return;
////    }
////
////    // 系统消息
////    if ([flag isEqualToString:@"1"]) {
////        UIViewController *currentVC = [UIViewController currentViewController];
////        HSUser *user = [HSLoginInfo savedLoginInfo];
////
////        // 如果currentVC不存在或者未登录，则不跳转界面
////        if (!currentVC && !user) {
////            return;
////        }
////
//////        HSMessageViewController *messageVC = [[HSMessageViewController alloc] init];
//////        messageVC.selectedIndex = 1;
//////        messageVC.hidesBottomBarWhenPushed = YES;
//////        [currentVC.navigationController pushViewController:messageVC animated:YES];
////    } else if ([flag isEqualToString:@"2"]) {
////        UIViewController *currentVC = [UIViewController currentViewController];
////        HSUser *user = [HSLoginInfo savedLoginInfo];
////
////        // 如果currentVC不存在或者未登录，则不跳转界面
////        if (!currentVC && !user) {
////            return;
////        }
////
////        currentVC.navigationController.tabBarController.selectedIndex = 3;
////    }
//}

#pragma mark 欢迎页

-(void)setWelcomeView {
    
    //应用程序的第一次启动界面
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        //数据源
        //#warning fix: Welcome Images
        NSArray *imageArray = @[@"引导页1", @"引导页2",@"引导页3",@"引导页4"];
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        //  初始化方法1
        MZGuidePages *mzgpc = [[MZGuidePages alloc] init];
        mzgpc.imageDatas = imageArray;
        __weak typeof(MZGuidePages) *weakMZ = mzgpc;
        //点击回调
        mzgpc.buttonAction = ^{
            //引导页，点击之后加载UI，进行登录判断
            //            [weakSelf createNeed];
            
            [UIView animateWithDuration:0.8
                             animations:^{
                                 weakMZ.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 //移除引导页，记录程序打开状态
                                 [weakMZ removeFromSuperview];
                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                             }];
        };
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:mzgpc];
        
    }
}


//#pragma mark FLEX
//
//- (void)handleSixFingerQuadrupleTap:(UITapGestureRecognizer *)tapRecognizer
//{
//#if DEBUG
//    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
//        // This could also live in a handler for a keyboard shortcut, debug menu item, etc.
//        [[FLEXManager sharedManager] showExplorer];
//    }
//#endif
//}

@end
