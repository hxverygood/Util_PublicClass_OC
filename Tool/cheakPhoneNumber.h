//
//  cheakPhoneNumber.h
//  Hoomsundb
//
//  Created by hoomsun on 16/8/4.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cheakPhoneNumber : NSObject
//判断手机号码的数据
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)checkCardNo:(NSString*) cardNo;

@end
