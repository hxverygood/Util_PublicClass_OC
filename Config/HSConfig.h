//
//  HSConfig.h
//  
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kAPIBaseURL;
FOUNDATION_EXPORT NSString *const kAPIBaseURL1;
FOUNDATION_EXPORT NSString *const kAPIBaseURL7;
FOUNDATION_EXPORT NSString *const kAPIBaseURL8;
FOUNDATION_EXPORT NSString *const kAPIBaseURL2;
FOUNDATION_EXPORT NSString *const kAPIBaseURL3;
FOUNDATION_EXPORT NSString *const kAPIBaseURL4;
FOUNDATION_EXPORT NSString *const kAPIBaseURL5;
FOUNDATION_EXPORT NSString *const kAPIBaseURL6;
FOUNDATION_EXPORT NSString *const kAPIBaseURL9;
FOUNDATION_EXPORT NSString *const kAPIBaseURLzs;
FOUNDATION_EXPORT NSString *const kAPIBaseURLSMRZ;
FOUNDATION_EXPORT NSString *const ScanIdCardMessage;
FOUNDATION_EXPORT NSString *const kAPIBaseURScan;
FOUNDATION_EXPORT NSString *const kAppStoreUrlStr;
FOUNDATION_EXPORT NSString *const kSystemPreferenceContact;
FOUNDATION_EXPORT NSInteger const authCodeQuantity;


//mainApiName
FOUNDATION_EXPORT NSString *const mainApiName;

//mainApiName
FOUNDATION_EXPORT NSString *const mainApiName_WEB;


// 认证类型
typedef NS_ENUM(NSInteger, AuthSuccessType) {
    AuthSuccessTypePersonMail,
    AuthSuccessTypeBusinessMail,
    AuthSuccessTypeZhima,
    AuthSuccessTypeTaobao,
    AuthSuccessTypeCreditCard
};

// 借款详情类型
typedef NS_ENUM(NSUInteger, BorrowDetailType) {
    BorrowDetailTypeOrigin,         // 用于原始的借款详情页面
    BorrowDetailTypeForSigning,     // 用于待签约界面
    BorrowDetailTypeForRepayment    // 用于还款界面
};

/// 信用卡登录类型
typedef NS_ENUM(NSInteger, CreditCardLoginType) {
    CreditCardLoginTypeUserName,
    CreditCardLoginTypeUserNameAndCodeAndDynamicPassword
};

// 申请记录类型
typedef NS_ENUM(NSInteger, QuotaManagementType) {
    QuotaManagementTypeAll,
    QuotaManagementTypeStore
};

/// 认证类型（产品1-4）
typedef NS_ENUM(NSInteger, AuthTipOption) {
    AuthTipOptionRealName,
    AuthTipOptionRequired,
    AuthTipOptionProduct1,
    AuthTipOptionProduct2,
    AuthTipOptionProduct3,
    AuthTipOptionProduct4
};

/// 产品类型（线上产品1-4，线下产品1-4）
typedef NS_ENUM(NSInteger, ProductOption) {
    ProductOption1,
    ProductOption2,
    ProductOption3,
    ProductOption4,
};

typedef NS_ENUM(NSInteger, OfflineProductOption) {
    OfflineProductOption1,
    OfflineProductOption2,
    OfflineProductOption3,
    OfflineProductOption4
};


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
