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
NSString *const kAppStoreUrlStr = @"";
NSString *const kSystemPreferenceContact = @"Privacy&path=CONTACTS";

#ifdef DEBUG

#pragma mark - 本地




#pragma mark - 外网


#else


#endif



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
