//
//  HSLoginInfo.m
//  Hoomsun
//
//  Created by Hans on 16/1/11.
//  Copyright © 2016年 Hoomsun. All rights reserved.
//

#import "LoginInfo.h"
#import "LDUser.h"
#import "LDUserBasicInfoModel.h"
#import "LDDriverAuthModel.h"
//#import "HSLimitAlertModel.h"

static NSString *const kLoginInfoFileName = @"info";
static NSString *const kBasicInfoFileName = @"basicInfo";
static NSString *const kVoiceBroadcast = @"voiceBroadcast";
static NSString *const kAcceptOrder = @"acceptOrder";
static NSString *const kRegistrationID = @"registrationID";


@interface LoginInfo ()

//@property (nonatomic, strong) NSArray *productNames;

@end



@implementation LoginInfo

#pragma mark - Login Status
/// 判断是否登录
+ (BOOL)judgeLoginStatus{
    if ([LoginInfo savedLoginInfo]) {
        return YES;
    }
    return NO;
}



#pragma mark - 登录信息的保存、读取、删除
/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull LDUser *)model {
    NSString *path = [self pathForName:kLoginInfoFileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
}

/// 获取保存的用户登录信息
+ (nullable LDUser *)savedLoginInfo {
    NSString *path = [self pathForName:kLoginInfoFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[LDUser class]]) {
        return obj;
    } else {
        return nil;
    }
}

/// 删除保存的登录信息
+ (void)removeSavedLoginInfo {
    NSString *path = [self pathForName:kLoginInfoFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
//    // 删除sessionId
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.xabaili.sessionid"];
}

#pragma mark - 用户基本信息保存、修改、删除（视每个项目的情况而定）

/// 保存用户基本信息
+ (void)saveBasicInfo:(nonnull LDUserBasicInfoModel *)model {
    NSString *path = [self pathForName:kBasicInfoFileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
}

/// 获取保存的用户基本信息
+ (nullable LDUserBasicInfoModel *)savedBasicInfo {
    NSString *path = [self pathForName:kBasicInfoFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[LDUserBasicInfoModel class]]) {
        return obj;
    } else {
        return nil;
    }
}

/// 删除保存的用户基本信息
+ (void)removeSavedBasicInfo {
    NSString *path = [self pathForName:kBasicInfoFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}



#pragma mark - Others

#pragma mark 语音播报状态

/// 保存语音播报状态信息
+ (void)saveVoiceBroadcastState:(BOOL)needVoiceBroadcast {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:needVoiceBroadcast forKey:kVoiceBroadcast];
    [userDefaults synchronize];
}

/// 读取语音播报状态信息
+ (BOOL)savedVoiceBroadcastState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL needVoiceBroadcast = [userDefaults boolForKey:kVoiceBroadcast];
    return needVoiceBroadcast;
}

/// 重置语音播报状态为YES
+ (void)resetVoiceBroadcastState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kVoiceBroadcast];
    [userDefaults synchronize];
}



#pragma mark 是否开启抢单（视每个项目的情况而定）
/// 保存是否开启抢单功能的状态
+ (void)saveAcceptOrderState:(BOOL)needAcceptOrder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:needAcceptOrder forKey:kAcceptOrder];
    [userDefaults synchronize];
}

/// 读取是否开启抢单功能的状态
+ (BOOL)savedAcceptOrderState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL needVoiceBroadcast = [userDefaults boolForKey:kAcceptOrder];
    return needVoiceBroadcast;
}

/// 重置语音播报状态为YES
+ (void)resetAcceptOrderState {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kAcceptOrder];
    [userDefaults synchronize];
}



#pragma mark - 重置及删除保存的信息

/// 删除所有本地归档的数据
+ (void)removeAllSavedInfo {
    [LoginInfo removeSavedBasicInfo];
    [LoginInfo removeSavedLoginInfo];
}

/// 重置UserDefault信息
+ (void)resetUserDefault {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:kVoiceBroadcast];
    [userDefaults setBool:NO forKey:kAcceptOrder];
    [userDefaults synchronize];
}


//#pragma mark 极光推送
///// 保存极光推送用到的RegistrationID
//+ (void)saveRegistrationID:(nonnull NSString *)registrationID {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:registrationID forKey:kRegistrationID];
//    [userDefaults synchronize];
//}
//
//
///// 读取保存的推送ID
//+ (nullable NSString *)savedRegistrationID {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *regID = [userDefaults stringForKey:kRegistrationID];
//    return regID;
//}
//
//
///// 删除保存的RegistrationID
//+ (void)removeRegistrationID {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:kRegistrationID];
//    [userDefaults synchronize];
//}



//#pragma mark - 弹出是否显示的数据存储
//
//
///**
// <#Description#>
//
// @param title <#title description#>
// @param limitValid YES  额度展界面使用 NO 提升额度界面使用
// @param completion <#completion description#>
// */
//+ (void)limitAlertStateWithTitle:(NSString *)title
//                      limitValid:(BOOL)limitValid
//                      completion:(void (^)(NSInteger state))completion {
//    
//    if ([NSString isBlankString:title]) {
//        NSLog(@"要查询的title字段为空");
//        return;
//    }
//    
//    [HSLoginInfo readSavedLimitAlertDataWithTitle:title completion:^(NSArray *results) {
//        if (results.count > 0) {
//            HSLimitAlertModel *alertModel = (HSLimitAlertModel *)results.firstObject;
//            if (completion) {
//                BOOL state = limitValid ? alertModel.neverShowLimitValid : alertModel.neverShowLimitInvalid;
//                completion(state ? 1 : 0);
//            }
//            return;
//        }
//        if (completion) {
//            completion(2);
//        }
//    }];
//}
//
//+ (void)updateLimitAlertDataWith:(NSString *)title
//                      limitValid:(BOOL)limitValid
//                      completion:(void (^)(BOOL insertSuccess))completion {
//    
//    if ([NSString isBlankString:title]) {
//        NSLog(@"要查询的title字段为空");
//        return;
//    }
//    
//    [HSLoginInfo readSavedLimitAlertDataWithTitle:title completion:^(NSArray *results) {
//        HSLimitAlertModel *alertModel = [[HSLimitAlertModel alloc] init];
//        if (results && results.count > 0) {
//            alertModel = (HSLimitAlertModel *)results.firstObject;
//        }
//        
//        alertModel.productName = title;
//        if (limitValid) {
//            alertModel.neverShowLimitValid = YES;
//        }
//        else {
//            alertModel.neverShowLimitInvalid = YES;
//        }
//        
//        [HSLimitAlertModel save:alertModel resBlock:^(BOOL res) {
//            if (completion) {
//                completion(res);
//            }
//        }];
//    }];
//}
//
//+ (void)readSavedLimitAlertDataWithTitle:(NSString *)title
//                              completion:(void (^)(NSArray *results))completion {
//    if ([NSString isBlankString:title]) {
//        NSLog(@"要查询的title字段为空");
//        return;
//    }
//    
//    NSLog(@"沙盒Document路径：%@", [NSString sandboxDocumentDirectoryPath]);
//    
//    NSString *where = [NSString stringWithFormat:@"productName = \"%@\"", title];
//    [HSLimitAlertModel selectWhere:where groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
//        if (completion) {
//            completion(selectResults);
//        }
//    }];
//}
//
//+ (void)deleteLimitAlertDataWithCompletion:(void (^)(BOOL deleteSuccess))completion {
//    [HSLimitAlertModel truncateTable:^(BOOL res) {
//        if (completion) {
//            completion(res);
//        }
//    }];
//}





#pragma mark - SessionID

///// 保存SessionID
//+ (void)saveSessionID:(NSString * __nonnull)sessionID
//{
//    // 如果sessionID为空，则不保存
//    if (sessionID == nil || [sessionID isEqualToString:@""]) {
//        return;
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:sessionID forKey:@"com.xabaili.sessionid"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
///// 获取保存的SessionID
//+ (nonnull NSString *)savedSessionID
//{
//    NSString *sessionID = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.xabaili.sessionid"];
//    
//    // 如果sessionID为空，则获取随机的UUID值作为sessionID
//    if (sessionID == nil || [sessionID isEqualToString:@""]) {
//        return [[NSUUID UUID] UUIDString];
//    }
//    
//    if (sessionID && [sessionID isKindOfClass:[NSString class]]) {
//        return sessionID;
//    }
//    return @"";
//}



#pragma mark - Func

+ (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array[0] stringByAppendingPathComponent:name];
}

@end
