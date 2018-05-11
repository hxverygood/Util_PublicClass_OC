//
//  DeviceAuthorization.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/5/10.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "DeviceAuthorization.h"
#import <AVFoundation/AVFoundation.h>

@implementation DeviceAuthorization

+ (BOOL)cameraIsAuthorized {
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    else {
        return YES;
    }
}

@end
