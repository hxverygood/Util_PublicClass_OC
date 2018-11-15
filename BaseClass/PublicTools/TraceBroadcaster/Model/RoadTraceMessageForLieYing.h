//
//  RoadTraceMessageForLieYing.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/23.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LieYingTrackModel.h"

@interface RoadTraceMessageForLieYing : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) LieYingTrackModel *body;

@end
