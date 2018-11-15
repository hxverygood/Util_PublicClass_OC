//
//  Transport.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transport : NSObject <NSCopying, NSCoding>

//@property (nonatomic, copy) NSString<Optional> *transportId;
//@property (nonatomic, copy) NSString<Optional> *trackId;
//@property (nonatomic, copy) NSString<Optional> *state;
//@property (nonatomic, copy) NSString<Optional> *address;

@property (nonatomic, copy) NSString *transportId;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *address;

@end
