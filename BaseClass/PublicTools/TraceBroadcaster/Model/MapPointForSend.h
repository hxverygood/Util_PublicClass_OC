//
//  MapPointForSend.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/9.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

//#import "JSONModel.h"
#import <Foundation/Foundation.h>

//@interface MapPointForSend : JSONModel
@interface MapPointForSend : NSObject

@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *latitude;

@end
