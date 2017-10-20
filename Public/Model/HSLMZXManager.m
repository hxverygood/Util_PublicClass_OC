//
//  HSLMZXManager.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/1.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSLMZXManager.h"
//#include <CommonCrypto/CommonCrypto.h>

@interface HSLMZXManager ()

//@property (nonatomic,strong) LMZXSDK *lmzxSDK;
//@property (nonatomic,assign) NSString *handerResuleString;

@end

@implementation HSLMZXManager

//static HSLMZXManager * _instance = nil;
//
//+ (instancetype)manager {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
//        [_instance initComponent];
//    }) ;
//    
//    return _instance;
//}
//
//- (void)initComponent {
//    _lmzxSDK = [LMZXSDK lmzxSDKWithApikey:API_KEY uid:[HSLoginInfo savedLoginInfo].ID callBackUrl:[NSString stringWithFormat:@"%@/credit_app/views/Limu/socialSecurity.do",kAPIBaseURL1]];//kAPIBaseURL1  //  http://113.200.203.114:8199/credit_app/views/Limu/socialSecurity.do
//    // 设置调试地址
//    _lmzxSDK.lmzxTestURL = lm_url;
//    _lmzxSDK.lmzxThemeColor = [UIColor whiteColor];
//    _lmzxSDK.lmzxTitleColor = [UIColor blackColor];
//    _lmzxSDK.lmzxSubmitBtnColor = Red;
//}
//
//-(void)getLMsdkFunction:(LMZXSDKFunction)sdkfunction and:(NSString *)handerResultString {
//    
//    __weak typeof(self) wself = self;
//    // 启动服务，授权查询
//    [_lmzxSDK startFunction:sdkfunction authCallBack:^(NSString *authInfo) {
//        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//#pragma mark -- 这里是从服务器调取的签名信息
//        NSString *singString = [wself sign:authInfo];
//        
//        // 将服务端加签好的signString发送给SDK
//        [[LMZXSDK shared] sendReqWithSign:singString];
//    }];
//    [wself handleResult:wself.handerResuleString];
//}
//
//
//#pragma mark - 监听结果回调
//- (void)handleResult:(NSString *)functionType {
//    
////    __block typeof(self) weakSelf = self;
//    _lmzxSDK.lmzxResultBlock = ^(NSInteger code, LMZXSDKFunction function, id obj, NSString * token){
//        NSLog(@"SDK结果回调:%ld,%d,%@,%@",(long)code,function,obj,token);
//        if (code == 0 ||code == 2) {//查询成功
//            [SVProgressHUD showInfoWithStatus:@"查询成功"];
//            // 建议APP从商户服务端获取查询结果数据!
//            //            LMResultShowVC *resultVc = [[LMResultShowVC alloc] init];
//            //            resultVc.function = function;
//            //            resultVc.token = token;
//            //            resultVc.bizType = weakSelf.handerResuleString;
//            //            LMNavigationController *navResultVC = [[LMNavigationController alloc]
//            //                                                   initWithRootViewController:resultVc];
//            //
//            //            [weakSelf presentViewController:navResultVC
//            //                                   animated:YES
//            //                                 completion:nil];
//        } else if(code == 1) { //查询中
//            
//        } else { // 失败
//            
//        }
//        
//    };
//    
//    
//}
//#pragma mark 可分别自定义不同功能的回调地址,协议名称,协议 URL,业务模式以及UI
//// 如果单独设置某一个
//-(void)setCustomSDKWithFunction:(LMZXSDKFunction)function{
//    // 获取最新的 UID:
//    _lmzxSDK.lmzxUid = @"666";
//    
//    if (function == LMZXSDKFunctionMobileCarrie){ // 运营商的 回调地址,业务模式, UI 和其余的功能不同
//        // 回调地址
//        _lmzxSDK.lmzxCallBackUrl    = @"www.mobilecarrie.com";
//        // 业务模式
//        _lmzxSDK.lmzxQuitOnSuccess  = NO;
//        // 导航条颜色
//        _lmzxSDK.lmzxThemeColor =  [UIColor whiteColor];
//        // 协议 URL
//        _lmzxSDK.lmzxProtocolUrl = @"自主协议";
//    }else{
//        // 回调地址
//        _lmzxSDK.lmzxCallBackUrl    = @"默认 URL";
//        // 业务模式
//        _lmzxSDK.lmzxQuitOnSuccess  = YES;
//        // 导航条颜色
//        _lmzxSDK.lmzxThemeColor =  RGBCOLOR(48, 113, 242);
//        // 协议 URL
//        _lmzxSDK.lmzxProtocolUrl = @"默认协议";
//    }
//}
//
//#pragma mark - 签名
//#pragma mark - 模拟服务端签名
////签名算法如下：
////1. 将立木回调参数 authInfo 和 APISECRET 直接拼接；
////2. 将上述拼接后的字符串进行SHA-1计算，并转换成16进制编码；
////3. 将上述字符串转换为全小写形式后即获得签名串
//- (NSString *)sign:(NSString*)string
//{
//    NSString *sign = [string stringByAppendingString:API_SECRET];
//    NSMutableString *mString = [NSMutableString stringWithString:sign];
//    NSString *newsign ;
//    // 3、对该字符串进行SHA-1计算，得到签名，并转换成16进制小写编码,得到签名串
//    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
//    NSData *stringBytes = [mString dataUsingEncoding: NSUTF8StringEncoding];
//    
//    if (CC_SHA1([stringBytes bytes], (unsigned int)[stringBytes length], digest)) {
//        NSMutableString *digestString = [NSMutableString stringWithCapacity:
//                                         CC_SHA1_DIGEST_LENGTH];
//        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
//            unsigned char aChar = digest[i];
//            [digestString appendFormat:@"%02X", aChar];
//        }
//        newsign =[digestString lowercaseString];
//        
//    }
//    NSLog(@"====2.newsign:%@",newsign);
//    return newsign;
//    
//}

@end
