//
//  AlipayResultModel.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/15.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "JSONModel.h"

@interface AlipayResponse : JSONModel

@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *msg;
@property (nonatomic, copy) NSString<Optional> *app_id;
@property (nonatomic, copy) NSString<Optional> *out_trade_no;
@property (nonatomic, copy) NSString<Optional> *trade_no;
@property (nonatomic, copy) NSString<Optional> *total_amount;
@property (nonatomic, copy) NSString<Optional> *seller_id;
@property (nonatomic, copy) NSString<Optional> *charset;
@property (nonatomic, copy) NSString<Optional> *timestamp;

@end

@protocol AlipayResponse;



@interface AlipayPaymentResult : JSONModel

@property (nonatomic, copy) NSString<Optional> *sign_type;
@property (nonatomic, copy) NSString<Optional> *sign;
@property (nonatomic, copy) AlipayResponse<Optional, AlipayResponse> *alipay_trade_app_pay_response;

@end

@protocol AlipayPaymentResult;



@interface AlipayResultModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *memo;
@property (nonatomic, copy) AlipayPaymentResult<Optional, AlipayPaymentResult> *result;
@property (nonatomic, copy) NSNumber<Optional> *resultStatus;

@end

/*
{
    "memo" : "xxxxx",
    "result" : "{
        \"alipay_trade_app_pay_response\":{
            \"code\":\"10000\",
            \"msg\":\"Success\",
            \"app_id\":\"2014072300007148\",
            \"out_trade_no\":\"081622560194853\",
            \"trade_no\":\"2016081621001004400236957647\",
            \"total_amount\":\"0.01\",
            \"seller_id\":\"2088702849871851\",
            \"charset\":\"utf-8\",
            \"timestamp\":\"2016-10-11 17:43:36\"
        },
        \"sign\":\"NGfStJf3i3ooWBuCDIQSumOpaGBcQz+aoAqyGh3W6EqA/gmyPYwLJ2REFijY9XPTApI9YglZyMw+ZMhd3kb0mh4RAXMrb6mekX4Zu8Nf6geOwIa9kLOnw0IMCjxi4abDIfXhxrXyj********\",
        \"sign_type\":\"RSA2\"
    }",
    "resultStatus" : "9000"
}
 */
