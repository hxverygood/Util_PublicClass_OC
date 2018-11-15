//
//  ShareManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/10.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h> 
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

typedef NS_ENUM(NSInteger, ShareState) {
    ShareStateUnknow,
    ShareStateBegin,
    ShareStateSuccess,
    ShareStateFail,
    ShareStateCancel,
    ShareStateUpload
};



@interface ShareManager : NSObject

+ (ShareManager *)shared;
- (void)registerPlatforms;


/**
 分享的方法

 @param platform 平台类型
 @param text 文字
 @param imageNames 图片数组
 @param url 链接
 @param title 标题
 @param completion 回调（分享的app是否安装, 分享是否成功）
 */
- (void)shareWithPlatform:(SSDKPlatformType)platform
                     text:(NSString *)text
               imageNames:(NSArray<NSString *> *)imageNames
                      url:(NSURL *)url
                    title:(NSString *)title
               completion:(void (^)(BOOL isPlatformInstall, ShareState shareState))completion;

@end
