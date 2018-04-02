
//  AppDelegate.h
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/7.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LMZXSDK.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/// 是否跳转至首页
@property (nonatomic, assign) BOOL jumpToMainVC;
/// 登录是否无效
@property (nonatomic, assign) BOOL loginInvalid;
/// 是否包含线下门店产品
@property (nonatomic, assign, readonly) BOOL containOfflineProduct;
/// 是否需要银行卡3要素验证
@property (nonatomic, assign, readonly) BOOL needBankCardVerify;

/// 判断是本地还是测试线 YES  本地 NO 测试线
@property (nonatomic, assign) BOOL isLocationOrTestLine;
/// 测试运营商认证
@property (nonatomic, assign) BOOL mobileTest;
/// 是否需要借款前的黑名单验证
@property (nonatomic, assign) BOOL needBlackListVerify;
/// 是否需要人法网失信认证（实名认证时）
@property (nonatomic, assign, readonly) BOOL needRenfa;

@end

