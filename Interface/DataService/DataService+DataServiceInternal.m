 //
//  DataService+DataServiceInternal.m
//  network-test
//
//  Created by hoomsun on 2016/11/30.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "DataService+DataServiceInternal.h"
#import "DataServiceInternal.h"


@implementation DataService (DataServiceInternal)

#pragma mark - Getter

- (nonnull NSString *)apiBaseURLString {
    return self.baseUrlString;
}


- (void)sendWithIP:(nonnull NSString *)ip
     mainDirectory:(nullable NSString *)mainDirectory
           apiName:(nonnull NSString *)apiName
            params:(nonnull NSDictionary *)params
              data:(NSArray * __nullable )fileData
        completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    
    /// 新方法
    NSString *urlString = nil;
    if (mainDirectory) {
        if (ip && mainDirectory) {
            mainDirectory = [NSString stringWithFormat:@"%@/%@", ip, mainDirectory];
        }
        else
        {
            mainDirectory = @"";
        }

    } else {
        mainDirectory = @"";
    }
    self.baseUrlString = mainDirectory;

    if ([mainDirectory isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@", apiName];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/%@", mainDirectory, apiName];
    }
    
    // 对请求参数进行组合
    NSDictionary *newParams = [self combinePostParamBodyWithAPIName:apiName params:params];
    NSLog(@"%@", urlString);
    NSLog(@"%@", newParams);

    HSHttpSessionManager *manager = [HSHttpSessionManager sharedSessionManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    // 设置网络访问超时时间
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    if ([self excludeSignInHttpHeaderForAPIName:apiName] == YES) {
        NSString *sign = [HSLoginInfo savedLoginInfo].sign;
        if (![NSString isBlankString:sign]) {
            [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
        }
    }
    
    NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        
#ifdef DEBUG
        NSLog(@"api return");
        NSLog(@"apiName：%@", apiName);
        NSLog(@"json: %@", json);
        if (err) {
            NSLog(@"err：%@", err);
        }
#endif

        DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
        compModel.apiName = apiName;
        if (!err) {
            NSError *error = nil;
            DataServiceResponseModel *respModel = [[DataServiceResponseModel alloc] initWithDictionary:json error:&error];
            if (error) {
                compModel.apiModel = nil;
                compModel.localErrorCode = kDataServiceStatusUnknown;
                compModel.localErrorDescription = error.localizedDescription;
                [compModel.errorArray addObject:err];
            } else {
                compModel.apiModel = respModel;
                compModel.localErrorCode = kDataServiceStatusOK;
                
                NSDictionary *resp = (NSDictionary *)json;
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    id obj = resp[@"data"];
                    if (!obj) {
                        obj = resp;
                    }
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        compModel.apiModel.dataArray = arr;
                    } else if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary *)obj;
                        compModel.apiModel.dataDictionary = dict;
                    }else{
                        compModel.data = obj;
                    }
                }
            }
        } else {
            compModel.apiModel = nil;
            compModel.localErrorCode = kDataServiceStatusUnknown;
            compModel.localErrorDescription = err.localizedDescription;
            [compModel.errorArray addObject:err];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];
    
    [dataTask resume];
}


/**
 上传文件(数组)
 
 @param apiName 接口名称
 @param params 参数 没有参数传空字典
 @param fileData 文件Data
 @param completion 接口回调
 */
- (void)uploadWithApiName:(nonnull NSString *)apiName
               parameters:(nonnull NSDictionary *)params
                     data:(NSArray * __nullable)fileData
                 mimeType:(NSString * __nullable)mimeType
                     completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    
    NSLog(@"%@", self.baseUrlString);
    NSLog(@"%@", apiName);
    NSLog(@"%@", params);
    
    /// 新方法
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kAPIBaseURL, apiName];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 40.f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        if (fileData.count > 0) {
            for (NSInteger i = 0; i < fileData.count; i++) {
                NSData *data = [fileData objectAtIndex:i];
                // 上传的参数名
                NSString *Name = [NSString stringWithFormat:@"files%ld", (long)i];
                
                
                if (mimeType == nil) {
                    // 上传filename
                    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", Name];
                    [formData appendPartWithFileData:data name:Name fileName:fileName mimeType:@"image/jpeg"];
                } else {
                    // 如果指定了mimeType
                    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", Name];
                    [formData appendPartWithFileData:data name:Name fileName:fileName mimeType:mimeType];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        id  json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        
        
#ifdef DEBUG
        NSLog(@"api return:");
        NSLog(@"%@", apiName);
        NSLog(@"%@", json);
        NSLog(@"%@", err);
#endif
        DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
        compModel.apiName = apiName;
        if (!err) {
            NSError *error = nil;
            DataServiceResponseModel *respModel = [[DataServiceResponseModel alloc] initWithDictionary:json error:&error];
            if (error) {
                compModel.apiModel = nil;
                compModel.localErrorCode = kDataServiceStatusUnknown;
                compModel.localErrorDescription = error.localizedDescription;
                [compModel.errorArray addObject:err];
            } else {
                compModel.apiModel = respModel;
                compModel.localErrorCode = kDataServiceStatusOK;
                
                NSDictionary *resp = (NSDictionary *)json;
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    id obj = resp[@"data"];
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        compModel.apiModel.dataArray = arr;
                    } else if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary *)obj;
                        compModel.apiModel.dataDictionary = dict;
                    }else{
                        compModel.data = obj ;
                    }
                }
            }
        } else {
            compModel.apiModel = nil;
            compModel.localErrorCode = kDataServiceStatusUnknown;
            compModel.localErrorDescription = err.localizedDescription;
            [compModel.errorArray addObject:err];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];
}


/**
 *  上传单个文件
 *
 *  @param apiName    接口名称
 *  @param params     参数 没有参数传空字典
 *  @param fileData   文件Data 不能为空
 *  @param mimeType   mimeType类型
 *  @param fileName   文件名
 *  @param completion 接口回调
 */
- (void)uploadWithApiName:(nonnull NSString *)apiName
               parameters:(nonnull NSDictionary *)params
                 fileData:(nonnull NSData *)fileData
                 fileName:(nonnull NSString *)fileName
                 mimeType:(nonnull NSString *)mimeType
               completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    
    NSLog(@"%@", self.baseUrlString);
    NSLog(@"%@", apiName);
    NSLog(@"%@", params);
    
    /// 新方法
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kAPIBaseURL, apiName];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    HSHttpSessionManager *manager = [HSHttpSessionManager sharedSessionManager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 40.f;
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
    {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            //self.progressView.progress = 1.0 *
        //            //uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        id  json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        
        
#ifdef DEBUG
        NSLog(@"api return:");
        NSLog(@"%@", apiName);
        NSLog(@"%@", json);
        NSLog(@"%@", err);
#endif
        DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
        compModel.apiName = apiName;
        if (!err) {
            NSError *error = nil;
            DataServiceResponseModel *respModel = [[DataServiceResponseModel alloc] initWithDictionary:json error:&error];
            if (error) {
                compModel.apiModel = nil;
                compModel.localErrorCode = kDataServiceStatusUnknown;
                compModel.localErrorDescription = error.localizedDescription;
                [compModel.errorArray addObject:err];
            } else {
                compModel.apiModel = respModel;
                compModel.localErrorCode = kDataServiceStatusOK;
                
                NSDictionary *resp = (NSDictionary *)json;
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    id obj = resp[@"data"];
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        compModel.apiModel.dataArray = arr;
                    } else if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary *)obj;
                        compModel.apiModel.dataDictionary = dict;
                    }else{
                        compModel.data = obj ;
                    }
                }
            }
        } else {
            compModel.apiModel = nil;
            compModel.localErrorCode = kDataServiceStatusUnknown;
            compModel.localErrorDescription = err.localizedDescription;
            [compModel.errorArray addObject:err];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];
}



/**
 *  上传单个文件，通过文件路径
 *
 *  @param apiName    接口名称
 *  @param params     参数 没有参数传空字典
 *  @param filePath   文件路径 不可以为空
 *  @param mimeType   mimeType类型 可空
 *  @param completion 接口回调
 */
- (void)uploadWithApiName:(nonnull NSString *)apiName
               parameters:(nullable NSDictionary *)params
                 filePath:(nonnull NSString *)filePath
                 mimeType:(nullable NSString *)mimeType
               completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    NSLog(@"%@", self.baseUrlString);
    NSLog(@"%@", apiName);
    NSLog(@"%@", params);
    
    /// 新方法
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", kAPIBaseURL, apiName];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 40.f;
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    NSURLSessionDataTask *task = [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 文件
        NSFileManager *fileManage = [NSFileManager defaultManager];
        BOOL fileExist = [fileManage fileExistsAtPath:filePath];
        if (!fileExist) {
            NSLog(@"保存在沙盒的通讯录文件不存在");
            return;
        }
        
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        NSError *error = nil;
//        NSString *fileName = [filePath]
        [formData appendPartWithFileURL:fileUrl name:@"contact.json" error:&error];
        if (error) {
            NSLog(@"%@", error.userInfo);
            return;
        }
        
        
        //        NSInputStream *inputStream = [NSInputStream inputStreamWithData:fileData];
        //        [formData appendPartWithInputStream:inputStream name:@"contact" fileName:@"contact" length:fileData.length mimeType:@"application/octet-stream"];
        
        //        [formData appendPartWithFormData:fileData name:Name];
        //        [formData appen]
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        id  json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        
#ifdef DEBUG
        NSLog(@"api return:");
        NSLog(@"%@", apiName);
        NSLog(@"%@", json);
        NSLog(@"%@", err);
#endif
        
        DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
        compModel.apiName = apiName;
        if (!err) {
            NSError *error = nil;
            DataServiceResponseModel *respModel = [[DataServiceResponseModel alloc] initWithDictionary:json error:&error];
            if (error) {
                compModel.apiModel = nil;
                compModel.localErrorCode = kDataServiceStatusUnknown;
                compModel.localErrorDescription = error.localizedDescription;
                [compModel.errorArray addObject:err];
            } else {
                compModel.apiModel = respModel;
                compModel.localErrorCode = kDataServiceStatusOK;
                
                NSDictionary *resp = (NSDictionary *)json;
                if ([resp isKindOfClass:[NSDictionary class]]) {
                    id obj = resp[@"data"];
                    if ([obj isKindOfClass:[NSArray class]]) {
                        NSArray *arr = (NSArray *)obj;
                        compModel.apiModel.dataArray = arr;
                    } else if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dict = (NSDictionary *)obj;
                        compModel.apiModel.dataDictionary = dict;
                    }else{
                        compModel.data = obj ;
                    }
                }
            }
        } else {
            compModel.apiModel = nil;
            compModel.localErrorCode = kDataServiceStatusUnknown;
            compModel.localErrorDescription = err.localizedDescription;
            [compModel.errorArray addObject:err];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];
    [task resume];
}



#pragma mark - Func

/// 将请求参数组合起来
- (NSDictionary *)combinePostParamBodyWithAPIName:(NSString *)apiName params:(NSDictionary *)params
{
    
    NSMutableDictionary *body = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    // 参数拼接
    if ([self shouldIncludeLoginInfoForAPIName:apiName]) {
        NSString *UUID = [HSLoginInfo fetchUUID];
//        body[@"idCard"] = user.PAPERID;
        body[@"UUID"] = UUID;
//        body[@"loginInfo"] = [HSLoginInfo loginInfo];
    }
    
//    NSLog(@"%@", self.baseUrlString);
//    NSLog(@"%@", apiName);
//    NSLog(@"%@", body);
    
    
    //    NSString *dataValue = [dataValueString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@""]];
    //    dataValue = [dataValue stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    //    NSLog(@"%@",dataValueString);
    //    NSString *body = [NSString stringWithFormat:@"data=%@", dataValue];
    
    return [body copy];
}

/// 请求参数是否包含loginfo
- (BOOL)shouldIncludeLoginInfoForAPIName:(NSString *)apiName
{
    // 使用loginfo作为参数的接口
    NSArray *includeItems = @[@"register.do", @"findpwd", @"updatepwd", @"validation.do", @"homepage/getcheck.do", @"homePage/getGradePro", @"Repayment/checkpwd", @"activity/Dopostconfirm",@"activity/getDetail.do", @"msg/getdatamsg", @"PersonMesg/getMsg", @"addapply/addApply.do"];
    if ([includeItems containsObject:apiName]) {
        return YES;
    }
    return NO;
}

/// 请求头不需要包含验签信息“字段sign”
- (BOOL)excludeSignInHttpHeaderForAPIName:(NSString *)apiName {
    // sign不作为请求头参数
    NSArray *includeItems = @[@"registerandlogin/isregister.do", @"product/product.do", @"banner/banner.do", @"notice/getNews.do", @"registerandlogin/login.do",@"person/AddressBook"];
    if ([includeItems containsObject:apiName]) {
        return NO;
    }
    return YES;
}


/**
 *  错误处理
 */
- (DataServiceCompletionModel *)errorHandleWithApiName:(nonnull NSString *)apiName error:(NSError * _Nonnull)error {
    DataServiceCompletionModel *compModel = [[DataServiceCompletionModel alloc] init];
    compModel.apiName = apiName;
    compModel.apiModel = nil;
    
    // 网络连接超时
    if ((error.code == -1001) ||
        (error.code == -1005) ||
        (error.code == -1009)) {
        compModel.localErrorCode = kDataServiceStatusNetworkError;
    }
    
    if (error.code == -1004) {
        compModel.localErrorCode = kDataServiceStatusResponseServerError;
    }
    
    if (error.code == -1011) {
        compModel.localErrorCode = kDataServiceStatusRequestFaild;
    }
    
    compModel.localErrorDescription = error.localizedDescription;
    [compModel.errorArray addObject:error];
    
    NSLog(@"错误: %@", error.localizedDescription);
    return compModel;
}

@end
