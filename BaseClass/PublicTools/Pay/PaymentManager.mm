//
//  PaymentManager.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/15.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "PaymentManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrderModel.h"
#import "AlipayResultModel.h"

#import <WXApi.h>
#import "WeixinOrderModel.h"

#import "UPPaymentControl.h"


static NSString *const wx_appid = @"wx5c7e55d73f30d263";


@interface PaymentManager () <WXApiDelegate>

@property (nonatomic, copy) AlipayOrderModel *alipay_order;

@end



@implementation PaymentManager

#pragma mark - Getter

- (BOOL)isWeixinInstalled {
    return [WXApi isWXAppInstalled];
}


#pragma mark - Initializer

+ (PaymentManager *)shared {
//    static PaymentManager *instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (instance == nil) {
//            instance = [[PaymentManager alloc] init];
//        }
//    });
//    return instance;

    static __weak PaymentManager *instance;
    PaymentManager *strongInstance = instance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class] alloc] init];
            instance = strongInstance;
        }
    }
    return strongInstance;
}



#pragma mark - Alipay

/// 支付宝_支付订单
- (void)alipay_payOrder:(NSString *)orderString fromScheme:appScheme callback:(AlipayCompletionBlock)callback {
    _alipay_order = [self alipay_orderStringToModel:orderString];

    if (orderString) {
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if (resultDic) {
                [self alipay_handleResultWithResultCode:[resultDic ac_intForKey:@"resultStatus"]];
            }
        }];
    }
    else {
        if (callback) {
            callback(nil);
        }
    }
}

/// 将服务器返回的订单信息转换为模型
- (nullable AlipayOrderModel *)alipay_orderStringToModel:(NSString *)orderString {
    NSDictionary *dict = [self orderJsonStringToDictionary:orderString];

    if ([dict allKeys].count > 0) {
        NSError *jsonModelError = nil;
        AlipayOrderModel *model = [[AlipayOrderModel alloc] initWithDictionary:dict error:&jsonModelError];
        if (jsonModelError) {
            return nil;
        }
        return model;
    }
    return nil;
}

/// 支付宝_支付回调
- (void)alipay_processOrderWithPaymentResult:(NSURL *)resultUrl {
    if ([resultUrl.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:resultUrl standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);

            NSString *memo = [resultDic ac_stringForKey:@"memo"];
            NSString *result = [resultDic ac_stringForKey:@"result"];
            NSDictionary *resultDict = [result dictionaryWithJsonString];
            NSString *resultStatus = [resultDic ac_stringForKey:@"resultStatus"];

            NSMutableDictionary *mutResultDict = [NSMutableDictionary dictionary    ];
            if (memo != nil) {
                [mutResultDict setValue:memo forKey:@"memo"];
            }

            if (result != nil) {
                [mutResultDict setValue:resultDict forKey:@"result"];
            }

            if (resultStatus != nil) {
                [mutResultDict setValue:resultStatus forKey:@"resultStatus"];
            }

            NSError *jsonModelError = nil;
            AlipayResultModel *model = [[AlipayResultModel alloc] initWithDictionary:resultDic error:&jsonModelError];
            if (!jsonModelError) {
                NSInteger resultCode = model.resultStatus.integerValue;
                [self alipay_handleResultWithResultCode:resultCode];
            }
            else {
                // 手动解析NSDictionary
                if ([resultStatus convertToNumber]) {
                    NSInteger resultCode = resultStatus.integerValue;
                    [self alipay_handleResultWithResultCode:resultCode];
                }
                else {
//                    if (completion) {
//                        completion(NO, 0, @"支付结果未知，请稍后查询");
//                    }
                    [HUD showInfoWithStatus:@"支付结果未知，请稍后查询"];
                }
            }
        }];
    }
}

/// 支付宝 - 处理支付结果
- (void)alipay_handleResultWithResultCode:(NSInteger)resultCode {
    NSString *errorInfo = nil;

    switch (resultCode) {
        case 8000:
            errorInfo = @"支付正在处理，请稍后查询";
            break;

        case 4000:
            errorInfo = @"订单支付失败";
            break;

        case 5000:
            errorInfo = @"支付重复请求";
            break;

        case 6001:
            errorInfo = @"支付已取消";
            break;

        case 6002:
            errorInfo = @"支付时网络连接出错，请重新支付";
            break;

        case 6004:
            errorInfo = @"支付结果未知，请稍后查询";
            break;

        default:
            break;
    }

    if (resultCode == 9000) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(paymentSuccess)]) {
            [self.delegate paymentSuccess];
        }
    }
    else if (resultCode == 8000 ||
             resultCode == 4000 ||
             resultCode == 5000 ||
             resultCode == 6001 ||
             resultCode == 6002 ||
             resultCode == 6004
             ) {
//        if (completion) {
//            completion(NO, resultCode, errorInfo);
//        }

        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(paymentFailureWithErrorCode:errorInfo:)]) {
            [self.delegate paymentFailureWithErrorCode:resultCode errorInfo:errorInfo];
        }
    }
    else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(paymentFailureWithErrorCode:errorInfo:)]) {
            [self.delegate paymentFailureWithErrorCode:resultCode errorInfo:@"支付结果未知，请稍后查询"];
        }
    }
}



#pragma mark - Weixin

/// 向微信终端程序注册第三方应用
- (void)wx_registerWeixinSDK {
    [WXApi registerApp:wx_appid];
}

/// 发起微信支付
- (void)wx_payWithOrderData:(id)data
                 completion:(void (^)(BOOL success, NSString *errorInfo))completion {
    PayReq *req = [[PayReq alloc] init];

    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        WeixinOrderModel *order = [[WeixinOrderModel alloc] initWithDictionary:dict error:nil];
        if (order) {
            req.partnerId = order.partnerid;
            req.prepayId = order.prepayid;
            req.nonceStr = order.noncestr;
            req.package = order.package;
            req.sign = order.sign;
            req.timeStamp = order.timestamp.unsignedIntValue;
        }
    }
    else if ([data isKindOfClass:[NSString class]]) {
        req = [self wx_orderStringToModel:(NSString *)data];
    }

    if (!req || ([NSString isBlankString:req.partnerId] ||
        [NSString isBlankString:req.prepayId] ||
        [NSString isBlankString:req.nonceStr] ||
        [NSString isBlankString:req.package] ||
        [NSString isBlankString:req.sign] ||
        req.timeStamp == 0)) {
        if (completion) {
            completion(NO, @"微信支付参数错误，请联系客服");
        }
    }

    [WXApi sendReq:req];
}

/// 将服务器返回的订单信息转换为模型
- (nullable PayReq *)wx_orderStringToModel:(NSString *)orderString {
    NSDictionary *dict = [self orderJsonStringToDictionary:orderString];

    if ([dict allKeys].count > 0) {
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = [dict ac_stringForKey:@"partnerId"];
        request.prepayId = [dict ac_stringForKey:@"prepayId"];
        request.package = [dict ac_stringForKey:@"package"];
        request.nonceStr = [dict ac_stringForKey:@"nonceStr"];
        request.timeStamp = [[dict ac_stringForKey:@"timeStamp"] unsignedIntValue];
        request.sign = [dict ac_stringForKey:@"sign"];

        return request;
    }
    return nil;
}

/// 微信支付结束后调回
- (void)wx_handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

/// 微信支付完成后的回调函数
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        NSString *tips = nil;

        switch(response.errCode){
            case WXSuccess:
            {
                // 服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"微信支付 - 支付成功");
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(paymentSuccess)]) {
                    [self.delegate paymentSuccess];
                }
            }
                break;

            case WXErrCodeUserCancel:
            {
                
                NSLog(@"微信支付 - 用户取消");
                tips = @"微信支付 - 用户取消";
            }
                break;

            case WXErrCodeSentFail:
            {
                NSLog(@"微信支付 - 发送失败");
                tips = @"微信支付 - 发送失败";
//                [HUD showInfoWithStatus:@"发送失败"];
            }
                break;

            case WXErrCodeAuthDeny:
            {
                NSLog(@"微信支付 - 授权失败");
                tips = @"微信支付 - 授权失败";
//                [HUD showInfoWithStatus:@"微信支付 - 授权失败"];
            }
                break;

            case WXErrCodeUnsupport:
            {
                NSLog(@"微信支付 - 微信不支持");
                tips = @"微信支付 - 微信不支持";
//                [HUD showInfoWithStatus:@"微信不支持该功能"];
            }
                break;

            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                tips = [NSString stringWithFormat:@"微信支付失败: %@", resp.errStr];
//                [HUD showInfoWithStatus:resp.errStr];
                break;
        }

        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(paymentFailureWithErrorCode:errorInfo:)]) {
            [self.delegate paymentFailureWithErrorCode:response.errCode errorInfo:tips];
        }
    }
}



#pragma mark - UPPayment 银联支付

/// 银联支付
- (void)uppay_TN:(id)tn
          scheme:(NSString *)scheme
  viewController:(__weak __kindof UIViewController *)viewController
      completion:(void (^)(BOOL success, NSString *errorInfo))completion {

    __weak typeof(viewController) weakViewController = viewController;

    NSString *tnStr = nil;
    if ([tn isKindOfClass:[NSString class]]) {
        tnStr = (NSString *)tn;
    }
    if (tnStr && tnStr.length > 0) {

        // 01:测试环境，00:生产环境
        NSString *mode = nil;
#if DEBUG
        mode = @"00";
#else
        mode = @"00";
#endif

        if ([PaymentManager isBlankString:scheme]) {
            if (completion) {
                completion(NO, @"跳转Scheme为空");
            }
            return;
        }

        BOOL success = [[UPPaymentControl defaultControl] startPay:tnStr fromScheme:scheme mode:mode viewController:weakViewController];
        if (success == NO) {
            if (completion) {
                completion(NO, @"调起银联支付功能失败");
            }
        }
    }
    else {
        if (completion) {
            completion(NO, @"银联支付失败，请使用其它支付渠道");
        }
    }
}

/// 银联支付回调处理
- (void)uppay_handleOpenURL:(NSURL *)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSInteger errorCode = 0;
        NSString *tips = nil;
        if ([code isEqualToString:@"success"]) {
            //如果想对结果数据验签，可使用下面这段代码，但建议不验签，直接去商户后台查询交易结果
            if(data != nil){
//                //数据从NSDictionary转换为NSString
//                NSData *signData = [NSJSONSerialization dataWithJSONObject:data
//                                                                   options:0
//                                                                     error:nil];
//                NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];

                //此处的verify建议送去商户后台做验签，如要放在手机端验，则代码必须支持更新证书
//                if([self verify:sign]) {
//                    //验签成功
//                }
//                else {
//                    //验签失败
//                }
                if (self.delegate &&
                    [self.delegate respondsToSelector:@selector(paymentSuccess)]) {
                    [self.delegate paymentSuccess];
                }
            }

        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            errorCode = -100;
            tips = @"银联支付失败";
//            [HUD showInfoWithStatus:@"银联支付失败"];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            errorCode = -200;
//            [HUD dismiss];
        }

        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(paymentFailureWithErrorCode:errorInfo:)]) {
            [self.delegate paymentFailureWithErrorCode:errorCode errorInfo:tips];
        }

    }];
}




#pragma mark - Private Func

- (NSDictionary *)orderJsonStringToDictionary:(NSString *)orderString {
    NSArray *orderStringArray = [orderString componentsSeparatedByString:@"&"];

    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];

    for (int i = 0; i < orderStringArray.count; i++) {
        id obj = orderStringArray[i];

        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)obj;
            NSRange range = [str rangeOfString:@"="];
            if (range.location != NSNotFound &&
                range.length != 0) {
                NSString *key = [str substringToIndex:range.location];
                NSString *value = [str substringFromIndex:range.location + range.length];
                if (key && value) {
                    [mutDict setValue:value forKey:key];
                }
            }
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)obj;
            NSString *key = [dict allKeys].firstObject;
            NSString *value = [dict valueForKey:key];
            if (![PaymentManager isBlankString:key] &&
                ![PaymentManager isBlankString:value]) {

            }
            [mutDict setValue:value forKey:key];
        }
    }
    return [mutDict copy];
}

/// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark - Jump

//- (void)paySuccessAndPop {
//    NSString *tips = @"支付成功";
//    [HUD showSuccessWithStatus:tips];
//    CGFloat duration = [tips hudShowDuration];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kPayDepositSuccessNotificationName object:nil];
//        [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
//    });
//}

@end
