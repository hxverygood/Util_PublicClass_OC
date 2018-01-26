//
//  BLInterface.m
//  Baili
//
//  Created by Meng on 15/12/8.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import "HSInterface.h"
#import <UIKit/UIKit.h>
#import "DataServiceInternal.h"

@interface HSInterface ()
@property (nonatomic, strong) XAlertView *alertView;
@end

@implementation HSInterface



///请求数据接口
+ (void)HS_POSTWithIP:(NSString *)ip
          mainApiName:(NSString *)mainApiName
                 name:(NSString *)apiName
                 params:(id)params
             complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation
{
    [[DataService sharedDataService] sendWithIP:ip mainDirectory:mainApiName apiName:apiName params:params data:nil completion:^(DataServiceCompletionModel * _Nullable model) {
        if (complation) {
            id data = nil;
            id errInfo ;
            if (model.apiModel.dataDictionary != nil) {
                data = model.apiModel.dataDictionary;
            } else if (model.apiModel.dataArray != nil) {
                data = model.apiModel.dataArray;
            }else{
                data = model.data ;
            }
            errInfo = model.apiModel.errorInfo ;
            
            switch (model.localErrorCode) {
                case kDataServiceStatusNetworkError:
                    errInfo = @"网络连接异常，请稍候再试";
                    break;
                case kDataServiceStatusRequestFaild:
                    errInfo = @"网络请求异常，请稍候再试";
                    break;
                case kDataServiceStatusRequestParamsBadFormat:
                    errInfo = @"请求参数错误，请稍候再试";
                    break;
                case kDataServiceStatusResponseBadFormat:
                    errInfo = @"获取数据格式错误，请稍候再试";
                    break;
                case kDataServiceStatusResponseServerError: {
                    NSString *newErrorDesc = [model.localErrorDescription stringByReplacingOccurrencesOfString:@"。" withString:@""];
                    errInfo = newErrorDesc;
                    break;
                }
                    
                default:
                    break;
            }
            
//            if (model.localErrorCode == kDataServiceStatusNetworkError ) {
//                errInfo = @"网络请求超时";
//            }
//
//            if (model.localErrorCode == kDataServiceStatusResponseServerError ) {
//                errInfo = @"网络请求超时";
//            }
            
            // 如果登录失效，则不显示错误信息
            if (model.apiModel.errorCode.integerValue == 1003) {
                complation(model.apiModel.errorCode.integerValue, nil, data, nil, model.localErrorCode, model.success);
            } else {
                // 其它情况正常显示错误信息
                complation(model.apiModel.errorCode.integerValue, errInfo, data, nil, model.localErrorCode, model.success);
            }
            
//#warning fix: login invalid
            // 登录过期，删除登录信息，弹出提示框
            if (model.apiModel.errorCode.integerValue == 1003) {
                [HSLoginInfo removeSavedLoginInfo];
//                [HSLoginInfo removeRegistrationID];
                // 删除手势、指纹密码
                [SCSecureHelper openGesture:NO];
                [SCSecureHelper touchIDOpen:NO];
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                app.loginInvalid = YES;
            }
        }
    }];

//    [[DataService sharedDataService] sendWithMainApiName:mainApiName apiName:apiName params:params data:nil completion:^(DataServiceCompletionModel * _Nullable model) {
//        
//    }];
}

/////上传文件接口
//+ (void)HS_UploadWithName:(NSString *)apiName
//                   params:(NSDictionary *)params
//                     data:(NSArray *)data
//                 mimeType:(NSString *)mimeType
//               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation
//{
//    [[DataService sharedDataService] uploadWithApiName:apiName parameters:params data:data mimeType:mimeType completion:^(DataServiceCompletionModel * _Nullable model) {
//        if (complation) {
//            id data = nil;
//            id errInfo ;
//            if (model.apiModel.dataDictionary != nil) {
//                data = model.apiModel.dataDictionary;
//            } else if (model.apiModel.dataArray != nil) {
//                data = model.apiModel.dataArray;
//            }else{
//                data = model.data ;
//            }
//            errInfo = model.apiModel.errorInfo;
//            
//            switch (model.localErrorCode) {
//                case kDataServiceStatusNetworkError:
//                    errInfo = @"网络连接异常";
//                    break;
//                case kDataServiceStatusRequestFaild:
//                    errInfo = @"网络请求异常";
//                    break;
//                case kDataServiceStatusRequestParamsBadFormat:
//                    errInfo = @"请求参数错误";
//                    break;
//                case kDataServiceStatusResponseBadFormat:
//                    errInfo = @"获取数据格式错误";
//                    break;
//                case kDataServiceStatusResponseServerError: {
//                    NSString *newErrorDesc = [model.localErrorDescription stringByReplacingOccurrencesOfString:@"。" withString:@""];
//                    errInfo = newErrorDesc;
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//            
//            complation(model.apiModel.errorCode.integerValue, errInfo, data, nil, model.localErrorCode, model.success);
//        }
//    }];
//}
//
///**
// *  上传单个文件接口
// */
//+ (void)HS_UploadWithName:(NSString *)apiName
//                   params:(NSDictionary *)params
//                 fileData:(NSData *)fileData
//                 fileName:(NSString *)fileName
//                 mimeType:(NSString *)mimeType
//               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation {
//    [[DataService sharedDataService] uploadWithApiName:apiName parameters:params fileData:fileData fileName:fileName mimeType:mimeType completion:^(DataServiceCompletionModel * _Nullable model) {
//        if (complation) {
//            id data = nil;
//            id errInfo ;
//            if (model.apiModel.dataDictionary != nil) {
//                data = model.apiModel.dataDictionary;
//            } else if (model.apiModel.dataArray != nil) {
//                data = model.apiModel.dataArray;
//            }else{
//                data = model.data ;
//            }
//            errInfo = model.apiModel.errorInfo;
//            
//            switch (model.localErrorCode) {
//                case kDataServiceStatusNetworkError:
//                    errInfo = @"网络连接异常";
//                    break;
//                case kDataServiceStatusRequestFaild:
//                    errInfo = @"网络请求异常";
//                    break;
//                case kDataServiceStatusRequestParamsBadFormat:
//                    errInfo = @"请求参数错误";
//                    break;
//                case kDataServiceStatusResponseBadFormat:
//                    errInfo = @"获取数据格式错误";
//                    break;
//                case kDataServiceStatusResponseServerError: {
//                    NSString *newErrorDesc = [model.localErrorDescription stringByReplacingOccurrencesOfString:@"。" withString:@""];
//                    errInfo = newErrorDesc;
//                    break;
//                }
//                    
//                default:
//                    break;
//            }
//            
//            complation(model.apiModel.errorCode.integerValue, errInfo, data, nil, model.localErrorCode, model.success);
//        }
//    }];
//}

@end
