//
//  HSHttpSessionManager.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/1/16.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSHttpSessionManager.h"

@implementation HSHttpSessionManager

+ (instancetype)sharedSessionManager {
    static HSHttpSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HSHttpSessionManager alloc] init];
//        instance.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return instance;
}

@end
