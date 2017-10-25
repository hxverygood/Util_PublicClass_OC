//
//  DataServiceResponseModel.m
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataServiceResponseModel.h"

@implementation DataServiceResponseModel

// 接口返回结果的model列表
- (nonnull __kindof NSArray *)modelsWithClass:(nonnull Class)cls
{
    if ([self.dataArray isKindOfClass:[NSArray class]]) {
        NSError *error = nil;
        NSArray *objs = [cls arrayOfModelsFromDictionaries:self.dataArray error:&error];
        if (objs) {
            return objs;
        }
    }
    return [[NSArray alloc] init];
}

/// 接口返回结果的对象
- (nullable __kindof id)modelWithClass:(nonnull Class)cls
{
    if ([self.dataDictionary isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        id obj = [[cls alloc] initWithDictionary:self.dataDictionary error:&error];
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
        if (obj) {
            return obj;
        }
    }
    return nil;
}

@end
