//
//  AlipayOrderModel.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/15.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "JSONModel.h"

@interface AlipayOrderModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *alipay_sdk;
@property (nonatomic, copy) NSString<Optional> *app_id;
@property (nonatomic, copy) NSString<Optional> *biz_content;
@property (nonatomic, copy) NSString<Optional> *charset;
@property (nonatomic, copy) NSString<Optional> *format;
@property (nonatomic, copy) NSString<Optional> *method;
@property (nonatomic, copy) NSString<Optional> *notify_url;
@property (nonatomic, copy) NSString<Optional> *sign;
@property (nonatomic, copy) NSString<Optional> *sign_type;
@property (nonatomic, copy) NSString<Optional> *timestamp;
@property (nonatomic, copy) NSString<Optional> *version;

@end
