//
//  DataService+DataServiceInternal.h
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataService.h"

@class DataServiceCompletionModel;

/// 提交请求信息
/// 仅供BLWDataService类内部使用
@interface DataService (DataServiceInternal)

/// 接口api前缀
//- (nonnull NSString *)apiBaseURLString;

/** 提交请求信息
    @params ip 基准ip
    @params mainDirectory  主目录
    @params apiName 接口名称
    @params params 参数 没有参数传空字典
    @params completion 接口回调
 */
- (void)sendWithIP:(nonnull NSString *)ip
     mainDirectory:(nullable NSString *)mainDirectory
           apiName:(nonnull NSString *)apiName
            params:(nonnull id)params
              data:(NSArray * __nullable )fileData
        completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;


///**
// 上传文件(数组)
//
// @param apiName 接口名称
// @param params 参数 没有参数传空字典
// @param fileData 文件Data
// @param completion 接口回调
// */
//- (void)uploadWithApiName:(nonnull NSString *)apiName
//               parameters:(nonnull NSDictionary *)params
//                     data:(NSArray * __nullable)fileData
//                 mimeType:(NSString * __nullable)mimeType
//               completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;
//
///**
// *  上传单个文件
// *
// *  @param apiName    接口名称
// *  @param params     参数 没有参数传空字典
// *  @param fileData   文件Data 不能为空
// *  @param mimeType   mimeType类型
// *  @param fileName   文件名
// *  @param completion 接口回调
// */
//- (void)uploadWithApiName:(nonnull NSString *)apiName
//               parameters:(nonnull NSDictionary *)params
//                 fileData:(nonnull NSData *)fileData
//                 fileName:(nonnull NSString *)fileName
//                 mimeType:(nonnull NSString *)mimeType
//               completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;
//
///**
// *  上传单个文件，通过文件路径
// *
// *  @param apiName    接口名称
// *  @param params     参数 没有参数传空字典
// *  @param filePath   文件路径 不可以为空
// *  @param mimeType   mimeType类型 可空
// *  @param completion 接口回调
// */
//- (void)uploadWithApiName:(nonnull NSString *)apiName
//               parameters:(nullable NSDictionary *)params
//                 filePath:(nonnull NSString *)filePath
//                 mimeType:(nullable NSString *)mimeType
//               completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion;

@end
