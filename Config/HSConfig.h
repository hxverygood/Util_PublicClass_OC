//
//  HSConfig.h
//  
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kAppStoreUrlStr;
FOUNDATION_EXPORT NSString *const kSystemPreferenceContact;
FOUNDATION_EXPORT NSInteger const authCodeQuantity;


/// 认证状态（未完成、认证中、已认证、认证失败、社保公积金没有全部完成）
typedef NS_ENUM(NSInteger, AuthStatusType) {
    AuthStatusTypeCompletion = 0,
    AuthStatusTypeNoCompletion,
    AuthStatusTypeFail,
    AuthStatusTypeProccessing,
    AuthStatusTypeAccumulationFundAndSocialSecurityNotAllFinish
};



@interface HSConfig : NSObject

// BundleName
@property (nonatomic, copy) NSString *kBundleName;
@property (nonatomic, copy) NSString *kBundleID;

+ (HSConfig *)shared;

@end
