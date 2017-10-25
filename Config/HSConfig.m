//
//  HSConfig.m
//  
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "HSConfig.h"

NSInteger const authCodeQuantity = 6;

#warning fix: url of app in AppStore
NSString *const kAppStoreUrlStr = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1281895479";
NSString *const kSystemPreferenceContact = @"Privacy&path=CONTACTS";

#ifdef DEBUG

#pragma mark - 本地
// 朱洪郑
NSString *const kAPIBaseURL = @"http://192.168.3.210:8080";
// 栋梁192.168.3.39
NSString *const kAPIBaseURL1 = @"http://192.168.3.19:8080";
//NSString *const kAPIBaseURL1 = @"http://192.168.3.39:8080";
// 刘帅
NSString *const kAPIBaseURL7 = @"http://192.168.3.14:8080";
// 朱洪郑
NSString *const kAPIBaseURL2 = @"http://192.168.3.210:8080";
// 路党伟
NSString *const kAPIBaseURL4 = @"http://192.168.3.37:8080";
// 崔永娟
NSString *const kAPIBaseURL8 = @"http://192.168.3.38:8080";
// 浩敏
NSString *const kAPIBaseURL3 = @"http://192.168.3.16:8089";
// 刘斌
NSString *const kAPIBaseURL5 = @"http://192.168.3.210:8080";
// 招商银行1
NSString *const kAPIBaseURLzs = @"http://192.168.2.117:8066";
// 扫二维码信息
NSString *const kAPIBaseURScan = @"http://113.200.203.114:8070";
// 社保公积金
NSString *const kAPIBaseURL6 = @"http://192.168.3.19:8080";

NSString *const mainApiName = @"hsfs-web/web";
NSString *const mainApiName_WEB = @"hsfs-web";
// 第3方运营商认证
NSString *const kAPIBaseURL9 = @"http://192.168.3.4:8081";



#pragma mark - 外网
//// 朱洪郑
//NSString *const kAPIBaseURL = @"http://113.200.105.34:8086";
//// 栋梁
//NSString *const kAPIBaseURL1 = @"http://113.200.105.35:8085";
//// 刘帅
//NSString *const kAPIBaseURL7 = @"http://113.200.105.35:8085";
//// 朱洪郑
//NSString *const kAPIBaseURL2 = @"http://113.200.105.34:8086";
//// 路党伟
//NSString *const kAPIBaseURL4 = @"http://113.200.105.34:8086";
//// 崔永娟
//NSString *const kAPIBaseURL8 = @"http://113.200.105.34:8086";
//// 浩敏
//NSString *const kAPIBaseURL3 = @"http://113.200.105.37:8080";
//// 刘斌
//NSString *const kAPIBaseURL5 = @"http://113.200.105.34:8086";
//// 招商银行
//NSString *const kAPIBaseURLzs = @"http://113.200.105.34:8086";
//// 实名认证
//NSString *const kAPIBaseURScan = @"http://113.200.105.35:8085";
//
//// 社保公积金
//NSString *const kAPIBaseURL6 = @"http://113.200.105.35:8085";
//
//NSString *const mainApiName = @"web";
//NSString *const mainApiName_WEB = @"";



#else
// 朱洪郑
NSString *const kAPIBaseURL = @"http://113.200.105.34:8086";
// 栋梁
NSString *const kAPIBaseURL1 = @"http://113.200.105.35:8085";
// 刘帅
NSString *const kAPIBaseURL7 = @"http://113.200.105.35:8085";
// 朱洪郑
NSString *const kAPIBaseURL2 = @"http://113.200.105.34:8086";
// 路党伟
NSString *const kAPIBaseURL4 = @"http://113.200.105.34:8086";
// 崔永娟
NSString *const kAPIBaseURL8 = @"http://113.200.105.34:8086";
// 浩敏
NSString *const kAPIBaseURL3 = @"http://113.200.105.37:8080";
// 刘斌
NSString *const kAPIBaseURL5 = @"http://113.200.105.34:8086";

// 招商银行
NSString *const kAPIBaseURLzs = @"http://113.200.105.34:8086";
// 实名认证
NSString *const kAPIBaseURScan = @"http://113.200.105.35:8085";
// 社保公积金
NSString *const kAPIBaseURL6 = @"http://113.200.105.35:8085";
//// 第3方运营商认证
//NSString *const kAPIBaseURL9 = @"http://192.168.3.4:8081";

NSString *const mainApiName = @"web";
NSString *const mainApiName_WEB = @"";

#endif

//192.168.3.19:8080/hsfs-web/web/youdun/getvalue.do
NSString *const ScanIdCardMessage = @"http://124.89.33.70:8191/web/youdun/getvalue";



@interface HSConfig ()


@end



@implementation HSConfig

#pragma mark - Getter

- (NSString *)kBundleName {
    if (!_kBundleName) {
        _kBundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return _kBundleName;
}

- (NSString *)kBundleID {
    if (!_kBundleID) {
        _kBundleID = [[NSBundle mainBundle] bundleIdentifier];
    }
    return _kBundleID;
}

+ (HSConfig *)shared
{
    static HSConfig *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[HSConfig alloc] init];
    });
    return handle;
}

@end
