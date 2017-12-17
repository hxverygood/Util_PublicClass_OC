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
            params:(nonnull id)params
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
    
    if (newParams) {
        NSLog(@"\n%@\n%@", urlString, newParams);
    } else {
        NSLog(@"\n%@\n%@", urlString, params);
    }
   

    HSHttpSessionManager *manager = [HSHttpSessionManager sharedSessionManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    if ([self needJsonBodyForAPIName:apiName])
    {
        if ([apiName isEqualToString:@"personalcontact/addcontacterinfo.do"])
        {
            // 添加联系人
            params = [params objectForKey:@"contactFinal"];

        }
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        req.timeoutInterval = timeoutInterval;

        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];

        if (jsonError) {
            NSLog(@"json转data时出错: %@", jsonError.userInfo);
            return;
        }
        [req setHTTPBody:jsonData];
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            [self apiCompletionWithIP:ip mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:error completion:^(DataServiceCompletionModel * _Nullable model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(model);
                });
            }];
        }] resume];
        return;
    }
    else {
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Content-Type"];
    }
    
    // 设置网络访问超时时间
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    if ([self excludeSignInHttpHeaderForAPIName:apiName] == YES) {
        NSString *sign = [HSLoginInfo savedLoginInfo].sign;
        if (![NSString isBlankString:sign]) {
            [manager.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];
        }
    }
    
    NSURLSessionDataTask *dataTask = [manager POST:urlString parameters:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self apiCompletionWithIP:ip mainDirectory:mainDirectory apiName:apiName params:params responseObject:responseObject error:nil completion:^(DataServiceCompletionModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(model);
            });
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(compModel);
        });
    }];
    
    [dataTask resume];
}


- (void)apiCompletionWithIP:(nonnull NSString *)ip
              mainDirectory:(nullable NSString *)mainDirectory
                    apiName:(nonnull NSString *)apiName
                     params:(nonnull id)params
             responseObject:(id  _Nullable)responseObject
                      error:(NSError * _Nullable)error
                 completion:(void (^ __nullable)(DataServiceCompletionModel * __nullable model))completion {
    NSError *err = nil;
    if (!error) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        
#ifdef DEBUG
        NSLog(@"\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>> api return >>>>>>>>>>>>>>>>>>>>>>>>>>>\n\
%@/\n%@\n%@\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n\n\
              _", mainDirectory, apiName, json);
        //        NSLog(@"apiName：%@", apiName);
        //        NSLog(@"json: %@", json);
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
        
        completion(compModel);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(compModel);
//        });
    } else {
        DataServiceCompletionModel *compModel = [self errorHandleWithApiName:apiName error:error];
        completion(compModel);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completion(compModel);
//        });
    }
}



#pragma mark - Func

/// 将请求参数组合起来
- (NSDictionary *)combinePostParamBodyWithAPIName:(NSString *)apiName params:(id)params
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
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
    NSArray *includeItems = @[@"register.do", @"findpwd", @"updatepwd", @"validation.do", @"homepage/getcheck.do", @"homePage/getGradePro", @"Repayment/checkpwd", @"activity/Dopostconfirm",@"activity/getDetail.do", @"msg/getdatamsg", @"PersonMesg/getMsg", @"addapply/addApply.do",@"getDetials",@"getDetailAccount",@"tabLogin.html", @"queryCredit.html"];
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

/// 接口是否需要传json而不是字典
- (BOOL)needJsonBodyForAPIName:(NSString *)apiName {
    NSArray *includeItmes = @[@"borrower/addborrowerinfo.do",@"carrear/addcarrearinfo.do",@"personalcontact/addcontacterinfo.do"];
    if ([includeItmes containsObject:apiName]) {
        return YES;
    }
    return NO;
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
