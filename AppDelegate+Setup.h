//
//  AppDelegate+Setup.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "AppDelegate.h"

//@interface AppDelegate (Setup) <JPUSHRegisterDelegate>
@interface AppDelegate (Setup)

- (void)config;


//#pragma mark - 极光推送
//
//-(void)setupNotificationMessageWithOptions:(NSDictionary *)launchOptions;
///// JPush注册设备
//- (void)registerDeviceWithToken:(NSData *)deviceToken;
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler;
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler;
//
//- (void)didReceiveRemoteNotificationForIOS7:(NSDictionary *)userInfo;
//- (void)didReceiveRemoteNotificationLessThanIOS7:(NSDictionary *)userInfo;

#pragma mark - 欢迎页
-(void)setWelcomeView;

///// 跳转至认证界面，或展示认证alertView
//+ (void)jumpToAuthVC:(NSInteger)authIndex;
//
//+ (void)getGradeAndShowAuthSuccessView;

@end
