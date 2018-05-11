//
//  DeviceAuthorizationHelper.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/5/10.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "DeviceAuthorizationHelper.h"
#import "DeviceAuthorization.h"

@implementation DeviceAuthorizationHelper

+ (BOOL)cameraIsNotAuthorizedAndShowAlert {
    BOOL cameraIsAuthorized = [DeviceAuthorization cameraIsAuthorized];
    if (cameraIsAuthorized == NO) {
        NSString *message = @"请打开相机访问权限";
        NSString *confirmTitle = @"设置";
        
        [ConfirmAlertController showAlertWithTitle:@"提示"
                                           message:message
                                      confirmTitle:confirmTitle
                                       cancelTitle:nil
                                       actionStyle:UIAlertActionStyleDefault
                                       actionBlock:^(NSInteger confirmIndex, UIAlertAction * _Nullable cancelAction) {
            if (confirmIndex >= 0) {
                NSURL *url = nil;
                                               
                if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                    // app名称
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", [HSConfig shared].kBundleID]];
                    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    }];
                }
            }
        }
        }];
    }
    
    return !cameraIsAuthorized;
}

@end
