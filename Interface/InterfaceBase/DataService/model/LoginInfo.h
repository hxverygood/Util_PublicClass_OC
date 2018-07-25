//
//  HSLoginInfo.h
//  Hoomsun
//
//  Created by Hans on 16/1/11.
//  Copyright © 2016年 Hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LDUser;
@class LDUserBasicInfoModel;

#pragma mark - 登录信息的保存、读取、删除
// 登录信息
@interface LoginInfo : NSObject

/// 判断是否登录
+ (BOOL)judgeLoginStatus;

/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull LDUser *)model;

/// 登录后，保存用户信息
+ (nullable LDUser *)savedLoginInfo;
/// 删除保存的用户信息
+ (void)removeSavedLoginInfo;



#pragma mark - 用户基本信息保存、修改、删除（视每个项目的情况而定）
/// 保存用户基本信息
+ (void)saveBasicInfo:(nonnull LDUserBasicInfoModel *)model;

/// 获取保存的用户基本信息
+ (nullable LDUserBasicInfoModel *)savedBasicInfo;

/// 删除保存的用户基本信息
+ (void)removeSavedBasicInfo;



#pragma mark - Others

#pragma mark 语音播报状态
/// 保存语音播报状态信息
+ (void)saveVoiceBroadcastState:(BOOL)needVoiceBroadcast;
/// 读取语音播报状态信息
+ (BOOL)savedVoiceBroadcastState;
/// 重置语音播报状态为YES
+ (void)ResetVoiceBroadcastState;


//#pragma mark 极光推送
///// 保存极光推送用到的RegistrationID
//+ (void)saveRegistrationID:(nonnull NSString *)registrationID;
///// 读取保存的推送ID
//+ (nullable NSString *)savedRegistrationID;
///// 删除保存的推送ID
//+ (void)removeRegistrationID;


//#pragma mark - 弹出是否显示的数据存储
//
//+ (void)limitAlertStateWithTitle:(NSString *_Nullable)title
//                      limitValid:(BOOL)limitValid
//                      completion:(void (^_Nullable)(NSInteger state))completion;
//
//+ (void)updateLimitAlertDataWith:(NSString *_Nullable)title
//                      limitValid:(BOOL)limitValid
//                      completion:(void (^_Nullable)(BOOL insertSuccess))completion;
//
//+ (void)readSavedLimitAlertDataWithTitle:(NSString *_Nullable)title
//                              completion:(void (^_Nullable)(NSArray * _Nullable results))completion;
//
//+ (void)deleteLimitAlertDataWithCompletion:(void (^_Nullable)(BOOL deleteSuccess))completion;

/// 设置和获取session id
/// 仅供BLWDataService类内部使用
//+ (void)saveSessionID:(NSString * __nonnull)sessionID;
//+ (nonnull NSString *)savedSessionID;


@end
