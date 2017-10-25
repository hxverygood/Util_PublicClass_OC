//
//  HSLoginInfo.m
//  Hoomsun
//
//  Created by Hans on 16/1/11.
//  Copyright © 2016年 Hoomsun. All rights reserved.
//

#import "HSLoginInfo.h"
#import "HSUser.h"

static NSString *const HSLoginInfoFileName = @"info";
static NSString *const kRegistrationID = @"registrationID";

@implementation HSLoginInfo

#pragma mark - Login Status
/// 判断是否登录
+ (BOOL)judgeLoginStatus{
    if ([HSLoginInfo savedLoginInfo]) {
        return YES ;
    }
    return NO ;
}

#pragma mark - LoginToken
/// 登录后，保存用户信息
+ (void)saveLoginInfo:(nonnull HSUser *)model {
    NSString *path = [self pathForName:HSLoginInfoFileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data) {
        __unused BOOL success = [data writeToFile:path atomically:YES];
    }
}

/// 获取保存的用户登录信息
+ (nullable HSUser *)savedLoginInfo {
    NSString *path = [self pathForName:HSLoginInfoFileName];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([obj isKindOfClass:[HSUser class]]) {
        return obj;
    } else {
        return nil;
    }
}

/// 删除保存的登录信息
+ (void)removeSavedLoginInfo {
    NSString *path = [self pathForName:HSLoginInfoFileName];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
//    // 删除sessionId
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.xabaili.sessionid"];
}

/// 接口自动使用此方法来获取保存的用户信息
+ (nonnull NSDictionary *)loginInfo {
    HSUser *model = [self savedLoginInfo];
    if (model) {
        NSString *idCard = model.paperid;
        NSString *UUID = model.uuid;
        if (idCard && UUID) {
            return @{
                     @"idCard": idCard,
                     @"UUID": UUID
                     };
        }
    }
    return @{};
}


/// 保存头像的链接地址
+ (void)saveAvatarImageURLStr:(nonnull NSString *)avatarImageURLStr {
    if (avatarImageURLStr.length>0 && ![avatarImageURLStr isEqualToString:@" "]) {
        HSUser *user = [self savedLoginInfo];
        user.photopath = avatarImageURLStr;
        [self saveLoginInfo:user];
    }
}

/// 获取钥匙串中的UUID，如果没有则创建并保存
+ (nonnull NSString *)fetchUUID {
    HSUser *user = [self savedLoginInfo];
    
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    // 如果没有保存得到用户信息，则重新获取UUID
    if (!user) {
        return uuid;
    }

    // 如果用户信息存在，但没有UUID信息，则重新获取
    if ([NSString isBlankString:user.uuid]) {
        return uuid;
    }
    
    // 如果用户信息里保存有UUID则直接返回
    uuid = user.uuid;
    return uuid;
}


/// 保存极光推送用到的RegistrationID
+ (void)saveRegistrationID:(nonnull NSString *)registrationID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:registrationID forKey:kRegistrationID];
    [userDefaults synchronize];
}


/// 读取保存的推送ID
+ (nullable NSString *)savedRegistrationID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regID = [userDefaults stringForKey:kRegistrationID];
    return regID;
}


/// 删除保存的RegistrationID
+ (void)removeRegistrationID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kRegistrationID];
    [userDefaults synchronize];
}


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



#pragma mark - func

+ (NSString *)pathForName:(NSString *)name {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [array[0] stringByAppendingPathComponent:name];
}

@end
