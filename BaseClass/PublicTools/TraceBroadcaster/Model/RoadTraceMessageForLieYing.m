//
//  RoadTraceMessageForLieYing.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/23.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "RoadTraceMessageForLieYing.h"

@implementation RoadTraceMessageForLieYing

- (NSString<Optional> *)token {
    return [LoginInfo savedLoginInfo].token;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    return [self modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self modelCopy];
}

- (NSUInteger)hash {
    return [self modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self modelIsEqual:object];
}

@end
