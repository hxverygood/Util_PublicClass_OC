//
//  WeixinOrderModel.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/19.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "JSONModel.h"

@interface WeixinOrderModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *appid;
@property (nonatomic, copy) NSString<Optional> *noncestr;
@property (nonatomic, copy) NSString<Optional> *package;
@property (nonatomic, copy) NSString<Optional> *partnerid;
@property (nonatomic, copy) NSString<Optional> *prepayid;
@property (nonatomic, copy) NSString<Optional> *sign;
@property (nonatomic, copy) NSNumber<Optional> *timestamp;

@end
