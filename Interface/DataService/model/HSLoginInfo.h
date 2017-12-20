//
//  HSLoginInfo.h
//  Hoomsun
//
//  Created by Hans on 16/1/11.
//  Copyright © 2016年 Hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BLUserEncryptDataModel.h"

//@class BLWStoreLoginDataModel;
@class HSUser;
@class HSLimitAlertModel;

// 登录信息
@interface HSLoginInfo : NSObject

/// 判断是否登录
+ (BOOL)judgeLoginStatus;

/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull HSUser *)model;
/// 获取保存的用户信息
+ (nullable HSUser *)savedLoginInfo;
/// 删除保存的用户信息
+ (void)removeSavedLoginInfo;

/// 接口自动使用此方法来获取保存的用户信息
+ (nonnull NSDictionary *)loginInfo;

/// 保存头像的链接地址
+ (void)saveAvatarImageURLStr:(nonnull NSString *)avatarImageURLStr;

/// 获取保存的UUID，如果没有则重新获取
+ (nonnull NSString *)fetchUUID;

/// 保存极光推送用到的RegistrationID
+ (void)saveRegistrationID:(nonnull NSString *)registrationID;
/// 读取保存的推送ID
+ (nullable NSString *)savedRegistrationID;
/// 删除保存的推送ID
+ (void)removeRegistrationID;


#pragma mark - 弹出是否显示的数据存储

+ (void)limitAlertStateWithTitle:(NSString *_Nullable)title
                      limitValid:(BOOL)limitValid
                      completion:(void (^_Nullable)(NSInteger state))completion;

+ (void)updateLimitAlertDataWith:(NSString *_Nullable)title
                      limitValid:(BOOL)limitValid
                      completion:(void (^_Nullable)(BOOL insertSuccess))completion;

+ (void)readSavedLimitAlertDataWithTitle:(NSString *_Nullable)title
                              completion:(void (^_Nullable)(NSArray * _Nullable results))completion;

+ (void)deleteLimitAlertDataWithCompletion:(void (^_Nullable)(BOOL deleteSuccess))completion;

/// 设置和获取session id
/// 仅供BLWDataService类内部使用
//+ (void)saveSessionID:(NSString * __nonnull)sessionID;
//+ (nonnull NSString *)savedSessionID;


@end
