//
//  HSInterface.h
//  Baili
//
//  Created by Meng on 15/12/8.
//  Copyright © 2015年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
static CGFloat const timeoutInterval = 180.0;
#else
static CGFloat const timeoutInterval = 120.0;
#endif

@interface HSInterface : NSObject
///请求数据接口
+ (void)HS_POSTWithIP:(NSString *)ip
          mainApiName:(NSString *)mainApiName
                 name:(NSString *)apiName
               params:(NSDictionary *)params
           complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation;

///上传文件接口
+ (void)HS_UploadWithName:(NSString *)apiName
                   params:(NSDictionary *)params
                     data:(NSArray *)data
                 mimeType:(NSString *)mimeType
               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation;

/**
 *  上传单个文件接口
 */
+ (void)HS_UploadWithName:(NSString *)apiName
                   params:(NSDictionary *)params
                 fileData:(NSData *)fileData
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
               complation:(void (^)(NSInteger errorCode, NSString *errorInfo, id data, NSError *error, NSInteger localErrorStatus, BOOL allSuccess))complation;


@end
