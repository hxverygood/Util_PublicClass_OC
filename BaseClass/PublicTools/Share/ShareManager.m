//
//  ShareManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/10.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "ShareManager.h"


@implementation ShareManager

#pragma mark - Initializer

+ (ShareManager *)shared {
    static ShareManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[ShareManager alloc] init];
        }
    });
    return instance;
}



#pragma mark - Register Platform

- (void)registerPlatforms {
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //微信
        [platformsRegister setupWeChatWithAppId:@"wx5c7e55d73f30d263" appSecret:@"d1c1a71b4c9a1dbca9f7b951c18ba443"];

        //QQ
        [platformsRegister setupQQWithAppId:@"1107819996" appkey:@"ilHIz8l2fss8t81N"];
    }];

//    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
//                                        @(SSDKPlatformSubTypeWechatTimeline),
//                                        @(SSDKPlatformTypeQQ),
//                                        @(SSDKPlatformSubTypeQZone)]
//                             onImport:^(SSDKPlatformType platformType) {
//                                 switch (platformType) {
//                                     case SSDKPlatformTypeWechat:
//                                     case SSDKPlatformSubTypeWechatTimeline:
//                                         [ShareSDKConnector connectWeChat:[WXApi class]];
//                                         break;
//
//                                     case SSDKPlatformTypeQQ:
//                                     case SSDKPlatformSubTypeQZone:
//                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                                         break;
//
//                                     default:
//                                         break;
//                                 }
//                             }
//                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//                          switch (platformType) {
//                              case SSDKPlatformTypeWechat:
//                              case SSDKPlatformSubTypeWechatTimeline:
//                                  [appInfo SSDKSetupWeChatByAppId:@"wx5c7e55d73f30d263"
//                                                        appSecret:@"d1c1a71b4c9a1dbca9f7b951c18ba443"];
//                                  break;
//
//                              case SSDKPlatformTypeQQ:
//                              case SSDKPlatformSubTypeQZone:
//                                  [appInfo SSDKSetupQQByAppId:@"1107819996"
//                                                       appKey:@"ilHIz8l2fss8t81N"
//                                                     authType:SSDKAuthTypeBoth];
//                                  break;
//
//                              default:
//                                  break;
//                          }
//    }];
}



#pragma mark - Share Content

- (void)shareWithPlatform:(SSDKPlatformType)platform
                     text:(NSString *)text
               imageNames:(NSArray<NSString *> *)imageNames
                      url:(NSURL *)url
                    title:(NSString *)title
               completion:(void (^)(BOOL isPlatformInstall, ShareState shareState))completion {

    BOOL isPlatformInstalled = NO;

    switch (platform) {
        case SSDKPlatformSubTypeWechatSession:
            isPlatformInstalled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatSession];
            if (isPlatformInstalled == NO) {
                if (completion) {
                    completion(NO, NO);
                }
                return;
            }
            break;

        case SSDKPlatformSubTypeWechatTimeline:
            isPlatformInstalled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeWechatTimeline];
            if (isPlatformInstalled == NO) {
                if (completion) {
                    completion(NO, NO);
                }
                return;
            }
            break;

        case SSDKPlatformTypeQQ:
            isPlatformInstalled = [ShareSDK isClientInstalled:SSDKPlatformTypeQQ];
            if (isPlatformInstalled == NO) {
                if (completion) {
                    completion(NO, NO);
                }
                return;
            }
            break;

        case SSDKPlatformSubTypeQZone:
            isPlatformInstalled = [ShareSDK isClientInstalled:SSDKPlatformSubTypeQZone];
            if (isPlatformInstalled == NO) {
                if (completion) {
                    completion(NO, NO);
                }
                return;
            }
            break;

        default:
            break;
    }


    //1.创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imageNames
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];

    // 2.分享
    [ShareSDK share:platform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateBegin:
                if (completion) {
                    completion(YES, ShareStateBegin);
                }
                break;
            case SSDKResponseStateCancel:
                if (completion) {
                    completion(YES, ShareStateCancel);
                }
                break;

            case SSDKResponseStateFail:
                if (completion) {
                    completion(YES, ShareStateFail);
                }
                break;

            case SSDKResponseStateSuccess:
                if (completion) {
                    completion(YES, ShareStateSuccess);
                }
                break;

            case SSDKResponseStateUpload:
                if (completion) {
                    completion(YES, ShareStateUpload);
                }
                break;

            default:
                break;
        }
    }];
}


@end
