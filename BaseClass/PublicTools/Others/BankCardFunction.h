//
//  BankCardFunction.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/16.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardFunction : NSObject

/// 银行英文简称和名字对照表
+ (NSString *)getBankNameWithShortEnglish:(NSString *)shortEnglish;

/// 根据银行卡号前6位获取发卡行和卡片信息
+ (nullable NSString *)getBankNameWithCardNumber:(NSString *)cardNumber;

/// 转换金额（小数点后2位）
+ (nullable NSString*)getMoney:(NSString *)money;

@end
