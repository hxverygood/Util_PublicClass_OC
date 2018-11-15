//
//  PaymentManager.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/15.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class PaymentManager;

typedef void(^AlipayCompletionBlock)(NSDictionary *resultDic);
//typedef void(^AlipayCutomCompletion)(BOOL success, NSInteger errorCode, NSString *errorInfo);



@protocol PaymentManagerDelegate <NSObject>

/**
 支付成功时的delegate
 */
- (void)paymentSuccess;


/**
 支付后失败的代理方法

 @param errorCode 支付失败时的错误码
                  支付宝：4000、5000、6001(取消)、6002、6004、8000、9000（成功）
                  微信：0(成功)、-1、-2(取消)、-3、-4、-5
                  银联：-100(失败)、-200（取消）
 @param errorInfo 支付失败时错误提示信息
 */
- (void)paymentFailureWithErrorCode:(NSInteger)errorCode
                          errorInfo:(NSString *)errorInfo;

@end



@interface PaymentManager : NSObject

@property (nonatomic, weak) id<PaymentManagerDelegate> delegate;
/// 是否安装了微信
@property (nonatomic, assign) BOOL isWeixinInstalled;

#pragma mark - Initializer

+ (PaymentManager *)shared;



#pragma mark - Alipay


/**
 支付宝_支付订单

 @param orderString 服务器返回的订单数据jsonString
 @param callback 调起支付宝前的回调
 */
- (void)alipay_payOrder:(NSString *)orderString fromScheme:appScheme callback:(AlipayCompletionBlock)callback;

/// 支付宝_支付回调
- (void)alipay_processOrderWithPaymentResult:(NSURL *)resultUrl;


#pragma mark - Weixin

/// 向微信终端程序注册第三方应用
- (void)wx_registerWeixinSDK;


/**
 发起微信支付

 @param data 服务器返回的订单数据
 @param completion 调起微信前的回调
 */
- (void)wx_payWithOrderData:(id)data
                 completion:(void (^)(BOOL success, NSString *errorInfo))completion;

/// 微信支付结束后调用
- (void)wx_handleOpenURL:(NSURL *)url;



#pragma mark - UPPayment 银联支付


/**
 开始银联支付

 @param tn 流水号
 @param scheme app跳转scheme
 @param viewController 跳转至支付控件时的viewController
 @param completion 调起银联控件前的回调
 */
- (void)uppay_TN:(id)tn
          scheme:(NSString *)scheme
        viewController:(__kindof UIViewController *)viewController
      completion:(void (^)(BOOL success, NSString *errorInfo))completion;

/// 银联支付回调处理
- (void)uppay_handleOpenURL:(NSURL *)url;

@end
