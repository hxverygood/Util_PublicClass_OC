//
//  ReceiveMessage.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "JSONModel.h"

@interface ReceiveMessageResult : JSONModel

@property (nullable, nonatomic, copy) NSNumber<Optional> *sequence;

@end

@protocol ReceiveMessageResult
@end



@interface ReceiveMessage : JSONModel

@property (nullable, nonatomic, copy) NSNumber<Optional> *errcode;
@property (nullable, nonatomic, copy) NSString<Optional> *message;
@property (nullable, nonatomic, copy) ReceiveMessageResult<Optional, ReceiveMessageResult> *result;

@property (nullable, nonatomic, copy) NSString<Optional> *type;


@end
