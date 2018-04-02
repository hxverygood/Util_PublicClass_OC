//
//  AppDelegate.m
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/7.
//  Copyright © 2016年 hoomsun. All rights reserved.
//


#import "AppDelegate.h"
#import "AppDelegate+Setup.h"

#import <Contacts/Contacts.h>

#import "HSMainViewController.h"
#import "HSPublicFunc.h"
#import "LocationManager.h"             // 获取经纬度
#import "ConfirmAlertController.h"

#import "HSInterface+Main.h"
#import "XAlertView.h"                  // 提示框
//#import "JANALYTICSService.h"           // 引入JAnalytics功能所需头文件
#import "HSVersionInfoModel.h"          // 版本信息model

#import <objc/runtime.h>

// 崩溃报告
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>

#import "HSBackGroundTools.h"
#import <Bugly/Bugly.h>
#import "HSCrawlerWebPageManager.h"
#import "HSInterface+Other.h"
#import "NSString+HXDate.h"
#import "HSCallRecordsChinaMobileFirstViewController.h"
#import "HSCallRecordsChinaMobileSecondViewController.h"
//这里是分享的数据信息
static NSString *qqAppid = @"";
static NSString *qqSecret = @"";

static NSString *weChatAppid = @"wx152ebde59fd99fb5";
static NSString *weChatSecret = @"1f3a0de5ae138ad6fa8f3db030af8947";

static NSString *sinaAppKey = @"";
static NSString *sinaSecret = @"";
static NSString *sinaReditectUrl = @"";


@interface AppDelegate ()
{
    NSDate * bgStartDate;
}

@property (nonatomic,strong) CNPhoneNumber *phoneNumber;
@property (nonatomic,strong)NSMutableArray *dataMuArray;
@property (nonatomic,strong)NSData *jsonData;
@property (nonatomic, strong) XAlertView *alertView;
@property (nonatomic, strong) LocationManager *manager;
@property (nonatomic, strong) HSVersionInfoModel *versionModel;
/// 是否包含线下门店产品
@property (nonatomic, assign) BOOL isOfflineProduct;
/// 是否需要银行卡3要素验证
@property (nonatomic, assign) BOOL needBankCardVerification;
/// 是否需要人法网失信认证（实名认证时）
@property (nonatomic, assign) BOOL needRenfa;
@property (nonatomic, strong) NSString *dateStr;

// 背景任务
@property(nonatomic,strong)HSBackGroundTools * bgTools;

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;

@property (nonatomic, strong) NSTimer *timer;

@end



@implementation AppDelegate

#pragma mark - Getter / Setter

- (NSMutableArray *)dataMuArray {
    if (!_dataMuArray) {
        _dataMuArray = [NSMutableArray array];
    }
    return _dataMuArray;
}
- (HSVersionInfoModel *)versionModel
{
    if (!_versionModel) {
        _versionModel = [[HSVersionInfoModel alloc] init];
    }
    return _versionModel;
}

-(HSBackGroundTools*)bgTools
{
    if (!_bgTools)
    {
        HSBackGroundTools * tl = [HSBackGroundTools shareTools];
        _bgTools = tl;
    }
    return _bgTools;
}

/// 是否跳转至首页
- (void)setJumpToMainVC:(BOOL)jumpToMainVC {
    _jumpToMainVC = jumpToMainVC;

    if (jumpToMainVC) {
        UIViewController *vc = [UIViewController currentViewController];
        if (vc) {
            [vc.navigationController popToRootViewControllerAnimated:NO];
        }
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarVC = (UITabBarController *)self.window.rootViewController;
            tabbarVC.selectedIndex = 0;
            
            // 跳转至首页后，tableView滑动到最顶端
            UIViewController *currentVC = [UIViewController currentViewController];
            NSArray *subViews = currentVC.view.subviews;
            for (UIView *v in subViews) {
                if ([v isKindOfClass:[UITableView class]]) {
                    UITableView *tv = (UITableView *)v;
                    [tv scrollToTopAnimated:NO]; 
                }
            }
        }
    }
}

/// 登录是否无效
- (void)setLoginInvalid:(BOOL)loginInvalid {
    _loginInvalid = loginInvalid;

    if (_loginInvalid == YES) {
        UIViewController *currentVC = [UIViewController currentViewController];
        
        if (!_alertView &&
            ![currentVC isKindOfClass:[HSRegisterOneStepViewController class]] &&
            ![currentVC isKindOfClass:[HSRegisterTwoStepViewController class]]) {
            XAlertView *alertView = [[XAlertView alloc] initWithTitle:@"登录失效" content:@"对不起，您的账号可能已在其它设备登录，请重新登录后再进行操作"];
            alertView.btn2.hidden = YES;
            alertView.btn3.hidden = YES;
            [alertView.btn1 addTarget:self action:@selector(invalidLoginAlertButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            self.alertView = alertView;
            [self.alertView show];
        }
    }
}

- (void)invalidLoginAlertButtonPressed:(UIButton *)sender {
    [self.alertView dissmiss];
    self.alertView = nil;
    
    HSRegisterOneStepViewController *vc = [[HSRegisterOneStepViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC presentViewController:navi animated:YES completion:nil];
    
    self.loginInvalid = NO;
}

- (BOOL)containOfflineProduct {
    return self.isOfflineProduct;
}

- (BOOL)needBankCardVerify {
    return self.needBankCardVerification;
}



#pragma mark - Application

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    HSMainViewController *mainVC = [[HSMainViewController alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    self.window.rootViewController = mainVC;
    [self.window makeKeyAndVisible];
    _manager = [LocationManager sharedManager];

#warning fix >>> offline product switch
    
#if DEVELOPMENT
    self.isOfflineProduct = YES;
#else
    self.isOfflineProduct = YES;
#endif
    
#warning fix >>> bankcard verification switch
    
#if DEVELOPMENT
    // 验证银行卡3要素
    self.needBankCardVerification = YES;//
    // 运营商认证测试
    self.mobileTest = NO;
    /// 是否需要借款前的黑名单验证
    self.needBlackListVerify = YES;
    self.needRenfa = NO;
#else
    #if PREPRODUCTION
        // 运营商认证测试
        self.mobileTest = NO;
        self.needBankCardVerification = YES;
    #else
        // 运营商认证测试
        self.mobileTest = NO;
        self.needBankCardVerification = YES;
    #endif
    
    
    /// 是否需要借款前的黑名单验证
    self.needBlackListVerify = YES;
    /// 需要人法网失信认证
    self.needRenfa = YES;
#endif
    
    self.isLocationOrTestLine = YES;
    
    
    // 做一些基本的配置工作
    [self config];

    //欢迎界面的首次展示
    [self setWelcomeView];

    // 检查app版本是否为最新
    [self checkAppVerison];

    // 极光统计分析
//    [self setupJAnalytics];

//    // 极光推送
//    [self setupNotificationMessageWithOptions:launchOptions];

    // 请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
//    // 上传通讯录
    [HSPublicFunc uploadContacts];
    
    //立木征信社保/公积金查询注册SDK
//    [LMZXSDK registerLMZXSDK];
    
    //打开SDK日志，默认为关闭
//    [[LMZXSDK shared] unlockLog];

    //初始化shareSDK模块
    [self initShareSDK];
    
    // 崩溃报告
//    [Fabric with:@[[Crashlytics class]]];
//    [self logUser];
    
    // 设备名称
    NSLog(@"设备名称：%@", [[UIDevice currentDevice] name]);
    
    // IDFV 给供应商的IDFV
    NSLog(@"IDFV: %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [self setBugly];

    
    return YES;
}


#pragma mark --
#pragma mark -- 设置buggly

-(void)setBugly
{
    BuglyConfig *config =  [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.viewControllerTrackingEnable = YES;
    [Bugly startWithAppId:@"615d80c208" config:config];
}


/// 通讯录授权情况
//- (void)addressBookAuthorization {
//    //1. 获取授权状态
//    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
//    //2. 创建 AddrssBook
//    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
//    //3. 没有授权时就授权
//    if (status == kABAuthorizationStatusNotDetermined) {
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//            //3.1 判断是否出错
//            if (error) {
//                return;
//            }
//            //3.2 判断是否授权
//            if (granted) {
//                CFRelease(addressBook);
//            }
//        });
//    }
//    CFRelease(addressBook);
//}


//#pragma mark - 极光统计分析
/// 极光统计分析
//- (void)setupJAnalytics {
//    JANALYTICSLaunchConfig *config = [[JANALYTICSLaunchConfig alloc] init];
//    config.appKey = jpushAppKey;
//    config.channel = channel;
//    [JANALYTICSService setupWithConfig: config];
//    [JANALYTICSService crashLogON];
//}


/// 极光推送 - 获取deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
//    [self registerDeviceWithToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
//    [self didReceiveRemoteNotificationForIOS7:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
//    [self didReceiveRemoteNotificationLessThanIOS7:userInfo];
}



#pragma mark - 其它
/**
 app被挂起 锁屏
 
 @param application <#application description#>
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"+++挂起app+++");
    
    [[HSCrawlerWebPageManager shared] removeSavedWebPageModel];
}


/**
 app复原

 @param application <#application description#>
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
     NSLog(@"+++复原app+++");
    // 获取用户当前所在的经纬度
    [[LocationManager sharedManager] findCurrentLocation];

}


/**
 app进入前台

 @param application <#application description#>
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // App角标置0
//    [JPUSHService resetBadge];
//    application.applicationIconBadgeNumber = 0;
    // 检查app版本是否为最新
    [self checkAppVerison];

    
    UIViewController *currentVC = [UIViewController currentViewController];
    if ([currentVC isKindOfClass:[HSCallRecordsChinaMobileFirstViewController class]]) {
        [currentVC.navigationController popViewControllerAnimated:YES];
    }else if ([currentVC isKindOfClass:[HSCallRecordsChinaMobileSecondViewController class]]) {
        [currentVC popToViewControllerWithPopCount:2];
    }
    
    
}


/**
  app进入后台 杀掉进程方法

 @param application <#application description#>
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{

    [[HSCrawlerWebPageManager shared] removeSavedWebPageModel];
    
    UIViewController *currentVC = [UIViewController currentViewController];
    if ([currentVC isKindOfClass:[HSCallRecordsChinaMobileFirstViewController class]]) {
        [currentVC.navigationController popViewControllerAnimated:YES];
    }else if ([currentVC isKindOfClass:[HSCallRecordsChinaMobileSecondViewController class]]) {
        [currentVC popToViewControllerWithPopCount:2];
    }
    
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//        
//        // 授权跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            // 解析 auth code
//            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
//            if (result.length>0) {
//                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                for (NSString *subResult in resultArr) {
//                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                        break;
//                    }
//                }
//            }
//            NSLog(@"授权结果 authCode = %@", authCode?:@"");
//        }];
//    }
    return YES;
}
////禁止用户使用第三方输入法
//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
//{
//    return NO;
//}

#pragma mark - ShareSDK

//shareSDK初始化信息
-(void)initShareSDK {
    NSArray *shareArray = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
    [ShareSDK registerActivePlatforms:shareArray
                             onImport:^(SSDKPlatformType platformType) {
         switch (platformType) {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
                 //                                    case SSDKPlatformTypeQQ:
                 //                                          [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 //                                         break;
                 //                                    case SSDKPlatformTypeSinaWeibo:
                 //                                         [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 //                                         break;
             default:
                 break;
         }
     }
    onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
      switch (platformType)
      {
              //                              case SSDKPlatformTypeSinaWeibo:
              //                                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
              //                                  [appInfo SSDKSetupSinaWeiboByAppKey:sinaAppKey
              //                                                            appSecret:sinaSecret
              //                                                          redirectUri:sinaReditectUrl
              //                                                             authType:SSDKAuthTypeBoth];
              //                                  break;
          case SSDKPlatformTypeWechat:
              [appInfo SSDKSetupWeChatByAppId:weChatAppid
                                    appSecret:weChatSecret];
              break;
              //                              case SSDKPlatformTypeQQ:
              //                                  [appInfo SSDKSetupQQByAppId:qqAppid
              //                                                       appKey:qqSecret
              //                                                     authType:SSDKAuthTypeBoth];
              //                                  break;
              
          default:
              
              break;
      }
      
    }];
}



#pragma mark - Others

-(void)comeToBackgroundMode
{
    bgStartDate = [NSDate date];
    //初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前app在后台有任务处理，需要时间
    UIApplication*  app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    //开启定时器 不断向系统请求后台任务执行的时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)applyForMoreTime
{
    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
    //    NSLog(@"++++后台运行状态 %.2f++++",[UIApplication sharedApplication].backgroundTimeRemaining);
    
    if (![self compareData:bgStartDate])
    {
        if ([UIApplication sharedApplication].backgroundTimeRemaining < 60)
        {
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^
                           {
                               [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                               self.bgTask = UIBackgroundTaskInvalid;
                           }];
        }
    }
}

-(BOOL)compareData:(NSDate*)startData
{
    NSDate *nowDate = [NSDate date]; // 当前时间
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    //    NSDate *creat = [formatter dateFromString:creat_time];
    // 传入的时间
    NSDate * creat = startData;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:creat toDate:nowDate options:0];
    NSLog(@"year=%zd  month=%zd  day=%zd hour=%zd  minute=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute);
    
    if (compas.minute > 3)
    {
        return YES;
    }
    return NO;
}

//- (void)logUser {
//    HSUser *user = [HSLoginInfo savedLoginInfo];
//    if (user) {
//        [CrashlyticsKit setUserIdentifier:user.phone];
//        [CrashlyticsKit setUserName:user.name];
//    }
//}

#pragma mark - 检查App版本并提示
- (void)checkAppVerison {
    NSString *newVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    //    NSLog(@"newVersion___________________:%@",newVersion);
    //#warning fix: app version number
    //    newVersion = @"1.0.3";
    
    [HSInterface checkAppVersionWithType:@"ios" versionNumber:newVersion completion:^(BOOL success, NSInteger errorCode, NSString *message, id model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"app不需要升级");
            } else {
                NSDictionary *dict = (NSDictionary *)model;
                _versionModel = [[HSVersionInfoModel alloc] initWithDictionary:dict error:nil];
                NSString *title = _versionModel.number;
                title = [NSString stringWithFormat:@"新版 v%@ 可供使用", title] ?: @"有新版可供使用";
                NSString *desc = _versionModel.updatedes;
                desc = [desc stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                
                // 强制更新（不更新app不能使用）
                if (errorCode == 2001) {
                    desc = desc ?: @"有新版需要升级，否则将无法继续使用";
                    
                    XAlertView *alertView = [[XAlertView alloc] initWithTitle:title content:desc];
                    alertView.btn2.hidden = YES;
                    alertView.btn3.hidden = YES;
                    [alertView.btn1 addTarget:self action:@selector(jumpToAppStoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    self.alertView = alertView;
                    [self.alertView show];
                }
                // 可更新可不更新
                else if (errorCode == 2002)
                {
                    desc = desc ?: @"有新版需要升级";
                    
                    XAlertView *alertView = [[XAlertView alloc] initWithTitle:title content:desc];
                    alertView.btn1.hidden = YES;
                    [alertView.btn3 addTarget:self action:@selector(jumpToAppStoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    self.alertView = alertView;
                    [self.alertView show];
                }
                // 当前版本已经为最新版本
                else if (errorCode == 2003)
                {
                    return;
                }
                // 正在审核
                else if (errorCode == 0)
                {
                    return;
                }
                // 报错
                else if (errorCode == 1)
                {
                    return;
                }
            }
        });
    }];
}


// 跳进App Store更新
- (void)jumpToAppStoreButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrlStr]];
    [self.alertView dissmiss];
}

@end
