//
//  HSPublicFunc.m
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/29.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "HSPublicFunc.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "HSInterface+HSUploadFile.h"
#import "HSHomeViewController.h"                // 首页VC
#import "HSRepaymentViewController.h"           // 还款首页VC
#import "HSPersonCenterViewController.h"        // 个人中心首页
#import "HSIncreaseCreditLimitCollectionVC.h"   // 认证首页VC"
#import "HSRepaymentViewController.h"           // 还款首页

@interface HSPublicFunc ()
@property (nonatomic, strong) CNPhoneNumber *phoneNumber;
@property (nonatomic, strong) NSMutableArray *dataMuArray;
@property (nonatomic, strong) NSData *jsonData;
//@property (nonatomic, assign) NSInteger count;
@end

@implementation HSPublicFunc

#pragma mark - Getter

- (NSMutableArray *)dataMuArray {
    if (!_dataMuArray) {
        _dataMuArray = [NSMutableArray array];
    }
    return _dataMuArray;
}

- (BOOL)contactAuthoried {
    if (!_contactAuthoried) {
        if (iOS9_OR_LATER) {
            _contactAuthoried = ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized);
        } else {
            ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
            _contactAuthoried = (authStatus == kABAuthorizationStatusAuthorized);
        }
        
    }
    return _contactAuthoried;
}


#pragma mark - Setter

- (void)setJsonData:(NSData *)jsonData {
    _jsonData = jsonData;
    
    if (jsonData) {
//        [self uploadContact];
    }
}



#pragma mark - 获取通讯录是否授权的工厂方法

+ (BOOL)contactAuthoried {
    HSPublicFunc *func = [[HSPublicFunc alloc] init];
    return func.contactAuthoried;
}

/// 判断通讯录权限，如果没有授权则弹出alertView提示用户跳转至授权界面
+ (BOOL)contactAuthoriedAndShowAlert {
    BOOL contactAuthoried = [HSPublicFunc contactAuthoried];
    if (!contactAuthoried) {
        NSString *message = @"请打开通讯录访问权限";
        NSString *confirmTitle = @"设置";
        
        __weak UIViewController *currentVC = [UIViewController currentViewController];
//        __weak typeof(currentVC) weakVC = currentVC;
        [ConfirmAlertController actionSheetWithTitle:@"提示" message:message confirmTitle:confirmTitle cancelTitle:nil actionStyle:UIAlertActionStyleDestructive viewController:currentVC actionBlock:^(NSInteger confirmIndex, UIAlertAction * _Nullable cancelAction) {
            if (confirmIndex >= 0) {
                NSURL *url = nil;
                
                if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                    // app名称
                    url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", [HSConfig shared].kBundleID]];
                    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } else {
                    url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        }];
                    }
                }
            }
        }];
    }
    
    return contactAuthoried;
}





#pragma mark - 上传通讯录
/// 上传通讯录
+ (void)uploadContacts {
    HSPublicFunc *func = [[HSPublicFunc alloc] init];
    
    if ([func contactAuthoried]) {
        [func fetchContactPath];
    } else {
        NSLog(@"没有读取通讯录的权限");
    }
}

/// 获取通讯录保存在沙盒中的路径
- (void)fetchContactPath {
    // 判断是否登录，如果未登录则不上传通讯录
    NSString *idCard = [HSLoginInfo savedLoginInfo].paperid;
    if ([NSString isBlankString:idCard]) {
        return;
    }
    
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
        for (PPPersonModel *model in addressBookArray) {
            NSString *phoneNum = model.mobileArray.count>0 ? model.mobileArray.firstObject : @"0";
            NSDictionary *dict = @{@"name" : model.name,@"phoneNumbers":[phoneNum copy]};
            
            BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
            if (isYes) {
                [self.dataMuArray addObject:[dict copy]];
            } else {
                NSLog(@"通讯录JSON数据生成失败，请检查数据格式");
            }
        }
        
        NSDictionary *idCardDict = @{@"idCard": idCard};
        NSDictionary *contactsDict = @{@"contacts": self.dataMuArray};
        NSDictionary *rootDic = @{@"data": @[idCardDict, contactsDict]};
//        NSLog(@"通讯录信息：%@", rootDic);
        
        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic options:0 error:&jsonError];
////        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactsDict options:0 error:&jsonError];

        if (jsonError) {
            NSLog(@"json转data时出错: %@", jsonError.userInfo);
            return;
        }
        NSString *paramStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self uploadContactWithParams:paramStr];
        
    } authorizationFailure:^{
        NSLog(@"通讯录没有授权!");
    }];
    
    
//    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
//    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
//    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
//    CNContactStore *contactStore = [[CNContactStore alloc] init];
//    NSError *contactError = nil;
//    
//    // 判断是否登录，如果未登录则不上传通讯录
//    NSString *idCard = [HSLoginInfo savedLoginInfo].PAPERID;
//    if ([NSString isBlankString:idCard]) {
//        return nil;
//    }
//    
//    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&contactError usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
//        NSLog(@"-------------------------------------------------------");
//        self.phoneNumber = nil;
//        NSString *givenName = contact.givenName;
//        NSString *familyName = contact.familyName;
//        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
//        
//        
//        NSArray *phoneNumbers = contact.phoneNumbers;
//        //NSLog(@"%@%@",phoneNumbers[0],phoneNumbers[1]);
//        for (CNLabeledValue *labelValue in phoneNumbers) {
//            NSString *label = labelValue.label;
//            CNPhoneNumber *phoneNumber = labelValue.value;
//            self.phoneNumber = phoneNumber;
//            NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
//        }
//        if (givenName.length == 0) {
//            givenName = @"无";
//        }
//        
//        if (familyName.length == 0) {
//            familyName = @"无";
//        }
//        
//        if (self.phoneNumber == nil) {
//            CNPhoneNumber *phone = [[CNPhoneNumber alloc] initWithStringValue:@"0"];
//            self.phoneNumber = phone;
//        }
//        
//        NSDictionary *dict = @{@"givenName" : givenName, @"familyName" : familyName,@"phoneNumbers":[self.phoneNumber.stringValue copy]};
//        
//        BOOL isYes = [NSJSONSerialization isValidJSONObject:dict];
//        if (isYes) {
//            [self.dataMuArray addObject:[dict copy]];
//        } else {
//            NSLog(@"通讯录JSON数据生成失败，请检查数据格式");
//        }
//    }];
//    
//    if (contactError) {
//        NSLog(@"获取通讯录失败");
//        return nil;
//    }
//    
//    NSDictionary *idCardDict = @{@"idCard": idCard};
//    NSDictionary *contactsDict = @{@"contacts": self.dataMuArray};
//    NSDictionary *rootDic = @{@"data": @[idCardDict, contactsDict]};
//    
//    NSError *jsonError = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootDic options:0 error:&jsonError];
//    self.jsonData = jsonData;
//    
//    if (jsonError) {
//        NSLog(@"json转data时出错: %@", jsonError.userInfo);
//        return nil;
//    } else {
//        // 沙盒路径
//        NSArray *sandBoxPathArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//        NSString *filePath = [NSString stringWithFormat:@"%@/contact.json", sandBoxPathArray.lastObject];
//        
//        [jsonData writeToFile:filePath atomically:YES];
//        
//        return filePath;
//    }
}


/// 上传通讯录至服务器
- (void)uploadContactWithParams:(NSString *)params {
//    [HSInterface uploadContactWithData:self.jsonData completion:^(BOOL success, NSString *message, id model) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success) {
//                NSLog(@"通讯录上传成功");
//            } else {
//                NSLog(@"通讯录上传失败");
//            }
//        });
//    }];
    
    [HSInterface uploadContactWithJSONString:params completion:^(BOOL success, NSString *message, id model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"通讯录上传成功");
            } else {
                NSLog(@"通讯录上传失败");
            }
        });
    }];
    
//    /*
//     此段代码如果需要修改，可以调整的位置
//     1. 把upload.php改成网站开发人员告知的地址
//     2. 把file改成网站开发人员告知的字段名
//     */
//    
//    //AFN3.0+基于封住HTPPSession的句柄
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    
//    //#warning fix: 假数据
//    //    NSDictionary *dict = @{@"idCard":@"61052319910609847X"};
//    
//    // 先判断是否登录，如果未登录则不上传通讯录
//    NSString *idCard = [HSLoginInfo savedLoginInfo].PAPERID;
//    if ([NSString isBlankString:idCard]) {
//        return;
//    }
//    NSDictionary *dict = @{@"idCard":idCard};
//    
//    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
//    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", kAPIBaseURL, @"main/phoneBook.do"];
//    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:self.jsonData name:@"file" fileName:@"contact.json" mimeType:@"text/html; charset=gbk"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//        // 回到主队列刷新UI,用户自定义的进度条
////        dispatch_async(dispatch_get_main_queue(), ^{
////            //self.progressView.progress = 1.0 *
////            //uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
////        });
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"通讯录上传成功 %@", responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"通讯录上传失败 %@", error);
//    }];
}



#pragma mark - 流程走到第几步

/// 判断INS_CURRENTSTATUS表示在流程的第几步
- (NSInteger)workflowPositionWithCurrentStatus:(NSString *)currentStatus {
    NSArray *statusArray = @[@[@"申请登记", @"质检复核"],
                             @[@"反欺诈", @"初审", @"终审"],
                             @[@"协议拟制", @"协议签订"],
                             @[@"协议审批"],
                             @[@"结算"]];
    
    for (int i=0; i<statusArray.count; i++) {
        NSArray *tmpArray = statusArray[i];
        for (int j=0; j<tmpArray.count; j++) {
            if ([currentStatus isEqualToString:tmpArray[j]]) {
                return i;
            }
        }
    }
    return 0;
}


#pragma mark -
/// 获取指定的ViewControllerClass数组
+ (NSArray<Class> *)viewControllerClassArray {
    NSArray *vcClassArray = @[[HSHomeViewController class], [HSRepaymentViewController class], [HSIncreaseCreditLimitCollectionVC class]];
    return vcClassArray;
}

/// 获取指定的ViewControllerClass数组（首页、还款、个人中心首页）
+ (NSArray<Class> *)mainViewControllerClassArray {
    NSArray *vcClassArray = @[[HSHomeViewController class], [HSRepaymentViewController class], [HSPersonCenterViewController class]];
    return vcClassArray;
}



#pragma mark 是否实名认证

+ (BOOL)isRealName {
    // 是否实名认证
    NSString *errorCode = [HSLoginInfo savedLoginInfo].auth.errorCode;
    if (!errorCode || [errorCode isEqualToString:@"1"]) {
        return NO;
    } else {
        return YES;
    }
}


//#pragma mark - 倒计时

//- (void)startCountDown {
//    self.count = kCountDownTime;
//    //    __strong typeof(weakSelf) strongSelf = weakSelf;
////    [self setupCodeButtonIsEnabled:NO];
//    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
//}
//
//- (void)countDown:(NSTimer *)timer {
//    NSString *countingText = [NSString stringWithFormat:@"%ld秒后重新发送", (long)self.count];
////    self.countLabel.text = countingText;
//
//    if (self.count == 0) {
//        [timer invalidate];
//        timer = nil;
//        _count = kCountDownTime;
////        [self setupCodeButtonIsEnabled:YES];
//        return;
//    }
//    _count -= 1;
//}

@end
