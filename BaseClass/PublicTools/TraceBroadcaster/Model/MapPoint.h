//
//  MapPoint.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPoint : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *latitude;
@property (nonatomic, copy) NSString *timestamp;

@end


