//
//  HSAuthFlowManager.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/16.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSAuthFlowManager.h"
#import "HSUser.h"

#import "HSInterface+HSUserInfo.h"
#import "HSUserInfoModel.h"
#import "HSMobileBelongModel.h"

#import "HSInterface+Main.h"                                // 首页API
#import "HSHomeDataModel.h"                                 // 首页数据模型
#import "HSHomeDetailViewController.h"                      // 申请借款VC

#import "HSCertificateViewController.h"                     // 实名认证VC
#import "HSCareerViewController.h"                          // 工作单位信息认证VC
#import "HSZhimaWebViewController.h"
#import "HSCallRecordsChinaMobileFirstViewController.h"
//#import "HSCallRecordsChinaMobileViewController.h"
#import "HSCallRecordsChinaMobileFirstViewController.h"     // 移动认证第1步
#import "HSCallRecordsChinaUnicornFirstViewController.h"
#import "HSCallRecordsChinaTelecomVC.h"
#import "HSContactInfoViewController.h"                     // 联系人信息认证VC
#import "HSCreditInvestigationViewController.h"             // 征信认证VC
#import "HSInfoAuthViewController.h"                        // 认证VC
#import "HSTaobaoWebViewController.h"                       // 淘宝VC

#import "HSAccumulationFundAndSocialSecurityTableVC.h"      // 社保、公积金VC
//#import "HSAccumulationFundViewController.h"              // 公积金VC
#import "HSNewAccumulationFundViewController.h"
//#import "HSSocialSecurityViewController.h"                // 社保VC
#import "HSNewSocialSecurityViewController.h"
#import "HSNewSocialSecurityViewController.h"
#import "HSCHSIAccountRegistrationViewController.h"         // 学信网认证
#import "HSAddBankCardBillViewController.h"                 // 信用卡列表

#import "HSAuthAlertView.h"                                 // 认证弹出框
#import "HSLimitActivationViewController.h"                 // 激活额度VC
#import "HSIncomeCertifyViewController.h"                   // 收入证明认证VC


#import "HSLoanListModel.h"

static HSAuthFlowManager *man;


@interface HSAuthFlowManager ()

@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, strong) NSArray *totalAuthNames;
@property (nonatomic, strong) NSArray *requiredAuthNames;
@property (nonatomic, strong) NSArray *requiredAuth1Names;
@property (nonatomic, strong) NSArray *requiredAuth2Names;
@property (nonatomic, strong) NSArray *product1AuthNames;
@property (nonatomic, strong) NSArray *product2AuthNames;
@property (nonatomic, strong) NSArray *product3AuthNames;
@property (nonatomic, strong) NSArray *product4AuthNames;
@property (nonatomic, strong) NSArray *offlineProduct1AuthNames;
@property (nonatomic, strong) NSArray *offlineProduct2AuthNames;
@property (nonatomic, strong) NSArray *offlineProduct3AuthNames;
@property (nonatomic, strong) NSArray *offlineProduct4AuthNames;

// 当前的认证模式
@property (nonatomic, assign) AuthTipOption currentAuthOption;

// 给借款界面传值
@property (nonatomic, strong) HSLoanListModel *loanListHomeModel;
@property (nonatomic, strong) HSLoanListModel *loanListModel;
@property (nonatomic, strong) HSHomeDataModel *homeDataModel;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) ProductOption productType;
@property (nonatomic, assign) BOOL isOfflineProduct;
//@property (nonatomic, assign) BOOL needJumpToBorrowVC;

@end



@implementation HSAuthFlowManager

#pragma mark - Getter

- (NSArray *)totalAuthNames {
    if (!_totalAuthNames) {
        _totalAuthNames = @[@"realName", @"callLog", @"career", @"contact", @"zhima", @"accumulationFund", @"socialSecurity", @"credit", @"chsi", @"taobao", @"bankBillFlow", @"income"];
    }
    return _totalAuthNames;
}

- (NSArray *)requiredAuthNames {
    if (!_requiredAuthNames) {
        _requiredAuthNames = @[@"realName", @"callLog", @"career", @"contact"];
    }
    return _requiredAuthNames;
}

- (NSArray *)requiredAuth1Names {
    if (!_requiredAuth1Names) {
        _requiredAuth1Names = @[@"realName", @"callLog"];
    }
    return _requiredAuth1Names;
}

- (NSArray *)requiredAuth2Names {
    if (!_requiredAuth2Names) {
        _requiredAuth2Names = @[@"career", @"contact"];
    }
    return _requiredAuth2Names;
}

- (NSArray *)product1AuthNames {
    if (!_product1AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:self.requiredAuthNames];
        [tmpArray addObjectsFromArray:@[@"bankBillFlow", @"zhima"]];
        _product1AuthNames = [tmpArray copy];
    }
    return _product1AuthNames;
}

- (NSArray *)product2AuthNames {
    if (!_product2AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:self.requiredAuthNames];
        [tmpArray addObjectsFromArray:@[@"accumulationFund", @"credit"]];
        _product2AuthNames = [tmpArray copy];
    }
    return _product2AuthNames;
}

- (NSArray *)product3AuthNames {
    if (!_product3AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:self.requiredAuthNames];
        [tmpArray addObjectsFromArray:@[@"chsi", @"credit"]];
        _product3AuthNames = [tmpArray copy];
    }
    return _product3AuthNames;
}

- (NSArray *)product4AuthNames {
    if (!_product4AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:self.requiredAuthNames];
        [tmpArray addObjectsFromArray:@[@"bankBillFlow", @"credit"]];
        _product4AuthNames = [tmpArray copy];
    }
    return _product4AuthNames;
}

/// 融易贷
- (NSArray *)offlineProduct1AuthNames {
    if (!_offlineProduct1AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:@[@"credit", @"accumulationFund", @"socialSecurity", @"income"]];
        _offlineProduct1AuthNames = [tmpArray copy];
    }
    return _offlineProduct1AuthNames;
}

/// 薪居贷
- (NSArray *)offlineProduct2AuthNames {
    if (!_offlineProduct2AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:@[@"credit", @"accumulationFund", @"socialSecurity"]];
        _offlineProduct2AuthNames = [tmpArray copy];
    }
    return _offlineProduct2AuthNames;
}


/// 开薪贷
- (NSArray *)offlineProduct3AuthNames {
    if (!_offlineProduct3AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:@[@"credit", @"accumulationFund", @"socialSecurity", @"income"]];
        _offlineProduct3AuthNames = [tmpArray copy];
    }
    return _offlineProduct3AuthNames;
}

/// 安居贷、微加贷
- (NSArray *)offlineProduct4AuthNames {
    if (!_offlineProduct4AuthNames) {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:@[@"credit"]];
        _offlineProduct4AuthNames = [tmpArray copy];
    }
    return _offlineProduct4AuthNames ;
}

- (AuthTipOption)authOption {
    return _currentAuthOption;
}

- (ProductOption)currentProductType {
    return _productType;
}



#pragma mark - Initializer

static HSAuthFlowManager * _instance = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    }) ;
    
    return _instance;
}

- (CGFloat)currentPercentInFlow {
    return _currentCount/(CGFloat)self.totalCount;
}

- (CGFloat)percentAfterCurrentFlowComplete {
    return (_currentCount+1)/(CGFloat)self.totalCount;
}

- (NSInteger)totalCount {
    return 4;
}


#pragma mark - 必须认证的4项

- (NSInteger)requriedAuthIsFinished {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.requiredAuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    }
    
    // 如果是部分认证
    //BOOL partialIsAuthed = NO;
    //for (int i = 0; i < authArray.count; i++) {
     //   if ([authArray[i] isEqualToString:@"0"]) {
     //       partialIsAuthed = YES;
     //   }
    //}
    
    //NSInteger result = (partialIsAuthed ? 1000 : 0) + authIndex;
    //return result;
    return authIndex;
}

- (NSInteger)requriedAuthIsInProccessing {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.requiredAuthNames];
    NSInteger authIndex = [self findInProccessingAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    }
    
    return authIndex;
}

- (BOOL)requriedAuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionRequired;
    NSInteger authIndex = [[HSAuthFlowManager manager] requriedAuthIsFinished];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >= 1000) {
        authIndex = authIndex % 1000;
    }
    
    if (authIndex == 0) {
        [self jumpWithAuthName:@"realName"];
    }
    else if (authIndex == 1) {
        [self jumpWithAuthName:@"callLog"];
    }
    else if (authIndex == 2) {
        [self jumpWithAuthName:@"career"];
    }
    else if (authIndex == 3) {
        [self jumpWithAuthName:@"contact"];
    }
    
    return YES;
}


#pragma mark - 必须认证的项目1

// 必须认证的完成情况
- (NSInteger)requriedAuth1IsFinished {
    
    NSArray *authArray = [self authedResultWithAuthNameArray:self.requiredAuth1Names];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    _currentCount = 0;
    for (int i = 0; i < authArray.count; i++) {
        if ([authArray[i] isEqualToString:@"0"]) {
            _currentCount += 1;
        }
    }
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    }
    
    // 如果是部分认证
    BOOL partialIsAuthed = NO;
    for (int i = 0; i < authArray.count; i++) {
        if ([authArray[i] isEqualToString:@"0"]) {
            partialIsAuthed = YES;
        }
    }
    
    partialIsAuthed = (partialIsAuthed ? 1000 : 0) + authIndex;
    return partialIsAuthed;
}

- (BOOL)requriedAuth1IsNotFinishedAndJump {
    NSInteger authIndex = [[HSAuthFlowManager manager] requriedAuth1IsFinished];
    
    if (authIndex == -100) {
        return NO;
    }
    if (authIndex == 0) {
        [self jumpWithAuthName:@"realName"];
    }
    
    if (authIndex == 1) {
        [self jumpWithAuthName:@"callLog"];
    }
    
    return YES;
}



#pragma mark - 必须认证的项目2

// 第2等必须认证的情况
- (NSInteger)requriedAuth2IsFinished {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.requiredAuth2Names];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return 100;
    }
    
    BOOL partialIsAuthed = NO;
    for (int i = 0; i < authArray.count; i++) {
        if ([authArray[i] isEqualToString:@"0"]) {
            partialIsAuthed = YES;
        }
    }
    
    partialIsAuthed = (partialIsAuthed ? -1000 : 0) - authIndex;
    return partialIsAuthed;
}

- (void)requriedAuth2IsFinishedAndJump {
    NSInteger authIndex = [[HSAuthFlowManager manager] requriedAuth1IsFinished];
    
    if (authIndex == -100) {
        return;
    }

    NSString *authName = nil;
    switch (authIndex) {
        case 0:
            authName = @"career";
            break;
        case 1:
            authName = @"contact";
            break;
        default:
            break;
    }
    [self jumpWithAuthName:authName];
}



#pragma mark - 是否实名认证

// 是否需要实名认证
- (BOOL)realNameIsAuthed {
    HSUser *user = [HSLoginInfo savedLoginInfo];
    
    // 是否实名认证
    NSString *isCert = user.auth.errorCode;
    if (!isCert) {
        isCert = @"1";
    }
    if ([isCert isEqualToString:@"1"]) {
        _currentAuthOption = AuthTipOptionRealName;
        [self jumpWithAuthName:@"realName"];
        return NO;
    }
    return YES;
}


#pragma mark - 芝麻秒贷
/************ 芝麻秒贷(芝麻认证、淘宝认证) ************/
- (NSInteger)authIsFinishedForFirstProduct {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.product1AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)product1AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProduct1;

    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFirstProduct];
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
//    if (authIndex == 0) {
//        [self jumpWithAuthName:@"realName"];
//    }
//    else if (authIndex == 1) {
//        [self jumpWithAuthName:@"callLog"];
//    }
//    else if (authIndex == 1) {
//        [self jumpWithAuthName:@"career"];
//    }
//    else if (authIndex == 1) {
//        [self jumpWithAuthName:@"contact"];
//    }
    
            
    [self jumpWithAuthName:self.product1AuthNames[authIndex]];
    
    return YES;
}



#pragma mark - 土豪贷
/************ 土豪贷(社保、公积金、征信) ************/
- (NSInteger)authIsFinishedForSecondProduct {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.product2AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)product2AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProduct2;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForSecondProduct];
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.product2AuthNames[authIndex]];
    
    return YES;
}



#pragma mark - 学霸贷
/************ 学霸贷(学历、淘宝) ************/
- (NSInteger)authIsFinishedForThirdProduct {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.product3AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)product3AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProduct3;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForThirdProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.product3AuthNames[authIndex]];
    
    return YES;
}


#pragma mark - 高富贷
/*********** 高富贷(信用卡/储蓄卡账单、征信) ************/
- (NSInteger)authIsFinishedForFourthProduct {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.product4AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)product4AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProduct4;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFourthProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.product4AuthNames[authIndex]];
    
//    if (authIndex == 4) {
//        [self jumpWithAuthName:@"chsi"];
//    }
//    else if (authIndex == 5) {
//        [self jumpWithAuthName:@"taobao"];
//    }
    
    return YES;
}

#pragma mark - 线下产品 融易贷

- (NSInteger)authIsFinishedForOfflineProduct1 {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.offlineProduct1AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)offlineProduct1AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProductOffline1;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFourthProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.offlineProduct1AuthNames[authIndex]];
    return YES;
}

#pragma mark - 线下产品 薪居贷

- (NSInteger)authIsFinishedForOfflineProduct2 {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.offlineProduct2AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)offlineProduct2AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProductOffline2;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFourthProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.offlineProduct2AuthNames[authIndex]];
    return YES;
}

#pragma mark - 线下产品 开薪贷

- (NSInteger)authIsFinishedForOfflineProduct3 {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.offlineProduct3AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)offlineProduct3AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProductOffline3;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFourthProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.offlineProduct3AuthNames[authIndex]];
    return YES;
}

#pragma mark - 线下产品 安居贷

- (NSInteger)authIsFinishedForOfflineProduct4 {
    NSArray *authArray = [self authedResultWithAuthNameArray:self.offlineProduct4AuthNames];
    NSInteger authIndex = [self findUnAuthedIndexWithArray:authArray];
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    if (authIndex == -1) {
        return -100;
    } else {
        return authIndex;
    }
}

- (BOOL)offlineProduct4AuthIsNotFinishedAndJump {
    self.currentAuthOption = AuthTipOptionProductOffline4;
    
    NSInteger authIndex = [[HSAuthFlowManager manager] authIsFinishedForFourthProduct];
    
    if (authIndex == -100) {
        return NO;
    }
    
    if (authIndex >=0 && authIndex < 4) {
        [self requriedAuthIsNotFinishedAndJump];
        return NO;
    }
    
    [self jumpWithAuthName:self.offlineProduct4AuthNames[authIndex]];
    return YES;
}




#pragma mark - Public Func

- (ProductOption)getAuthOptionWithName:(NSString *)name {
    ProductOption productType;
    if ([name containsString:@"秒贷"]) {
        productType = ProductOption1;
    }
    else if ([name containsString:@"土豪"]) {
        productType = ProductOption2;
    }
    else if ([name containsString:@"学霸"]) {
        productType = ProductOption3;
    }
    else {
        productType = ProductOption4;
    }
    return productType;
}

- (NSString *)convertAuthName:(NSString *)authName {
    if ([authName isEqualToString:@"realName"]) {
        return @"实名认证";
    }
    else if ([authName isEqualToString:@"addressBook"]) {
        return @"通讯录授权";
    }
    else if ([authName isEqualToString:@"callLog"]) {
        return @"运营商认证";
    }
    else if ([authName isEqualToString:@"career"]) {
        return @"单位信息认证";
    }
    else if ([authName isEqualToString:@"contact"]) {
        return @"联系人认证";
    }
    else if ([authName isEqualToString:@"zhima"]) {
        return @"芝麻分认证";
    }else if ([authName isEqualToString:@"accumulationFund"]) {
        return @"公积金认证";
    }
    else if ([authName isEqualToString:@"socialSecurity"]) {
        return @"社保认证";
    }
    else if ([authName isEqualToString:@"accumulationFundAndSocialSecurity"]) {
        return @"社保/公积金认证";
    }
    else if ([authName isEqualToString:@"credit"]) {
        return @"征信认证";
    }
    else if ([authName isEqualToString:@"chsi"]) {
        return @"学历学籍认证";
    }
    else if ([authName isEqualToString:@"taobao"]) {
        return @"淘宝认证";
    }
    else if ([authName isEqualToString:@"bankBillFlow"]) {
        return @"信用卡账单认证";
    }
    else if ([authName isEqualToString:@"income"]) {
        return @"收入认证";
    }
    return nil;
}



#pragma mark - Private Func

/// 查找没有进行认证的index
- (NSInteger)findUnAuthedIndexWithArray:(NSArray *)authArray {
    NSInteger authIndex = -1;
    
    for (int i = 0; i < authArray.count; i++) {
        NSString *string = authArray[i];
        if (![string isEqualToString:@"0"]) {
            authIndex = i;
            break;
        }
        
//        if (![string isEqualToString:@"0"]) {
//            if ([string isEqualToString:@"1"]) {
//                i += 10;
//            } else if ([string isEqualToString:@"2"]) {
//                i += 20;
//            } else if ([string isEqualToString:@"3"]) {
//                i += 30;
//            }
//            authIndex = i;
//            break;
//        }
    }
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    return authIndex;
}

/// 查找处于认证中的index
- (NSInteger)findInProccessingAuthedIndexWithArray:(NSArray *)authArray {
    NSInteger authIndex = -1;
    
    for (int i = 0; i < authArray.count; i++) {
        NSString *string = authArray[i];
        if ([string isEqualToString:@"3"]) {
            authIndex = i;
            break;
        }
    }
    
    // 如果authIndex没有标记，说明通过了所有必填认证，需弹出认证完成弹出框
    return authIndex;
}

/// 判断该字段是否已经认证
- (NSArray *)authedResultWithAuthNameArray:(NSArray *)keyArray  {
    NSMutableArray *authArray = [NSMutableArray array];
    HSUser *user = [HSLoginInfo savedLoginInfo];
    
    for (NSString *authName in keyArray) {
        NSString *isCert = nil;
        if ([authName isEqualToString:@"realName"]) {
            isCert = user.auth.errorCode;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"callLog"]) {
            isCert = user.auth.callLog;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"career"]) {
            isCert = user.auth.CareerCode;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"contact"]) {
            isCert = user.auth.ContacterCode;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"zhima"]) {
            isCert = user.auth.zhimaCode;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"taobao"]) {
            isCert = user.auth.taoBao;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"accumulationFund"]) {
            isCert = user.auth.accumulationFund;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"socialSecurity"]) {
            isCert = user.auth.socialSecurity;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"credit"]) {
            isCert = user.auth.creditInvestigation;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:isCert];
        }
        else if ([authName isEqualToString:@"chsi"]) {
            isCert = user.auth.CHSI;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"bankBillFlow"]) {
            isCert = user.auth.bankBillFlow;
            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
        else if ([authName isEqualToString:@"income"]) {
            NSString *incomeIsCert = user.auth.incomeCode;
            NSString *savingIsCert = user.auth.savings;
            
            // 未认证
            if ([incomeIsCert isEqualToString:@"1"] &&
                [savingIsCert isEqualToString:@"1"]) {
                isCert = @"1";
            }
            else if ([incomeIsCert isEqualToString:@"0"] ||
                     [savingIsCert isEqualToString:@"0"]) {
                // 已认证
                isCert = @"0";
            }
            else if ([incomeIsCert isEqualToString:@"2"] ||
                     [savingIsCert isEqualToString:@"2"]) {
                // 认证失败
                isCert = @"2";
            }
            else if ([incomeIsCert isEqualToString:@"3"] ||
                     [savingIsCert isEqualToString:@"3"]) {
                // 认证中
                isCert = @"3";
            }

            if (!isCert) {
                isCert = @"1";
            }
            [authArray addObject:[isCert copy]];
        }
    }
    
    return authArray;
}

- (NSArray<NSArray *> *)requiredAuthTitles {
    NSMutableArray *authFinishedArray = [NSMutableArray array];
    NSMutableArray *authUnFinishedArray = [NSMutableArray array];
    
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *isCert = user.auth.errorCode;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[0]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[0]];
    }
    
    isCert = user.auth.callLog;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[1]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[1]];
    }
    
    isCert = user.auth.CareerCode;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[2]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[2]];
    }
    
    isCert = user.auth.ContacterCode;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[3]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[3]];
    }
    
    NSMutableArray<NSMutableArray *> *resultArray = [NSMutableArray array];
    [resultArray addObject:authFinishedArray];
    [resultArray addObject:authUnFinishedArray];
    
    return [resultArray copy];
}

- (NSArray<NSArray *> *)product1AuthTitles {
    NSMutableArray *authFinishedArray = [NSMutableArray array];
    NSMutableArray *authUnFinishedArray = [NSMutableArray array];
    
    if ([self requiredAuthTitles][0].count > 0) {
        [authFinishedArray addObjectsFromArray:[self requiredAuthTitles][0]];
    }
    
    if ([self requiredAuthTitles][1].count > 0) {
        [authUnFinishedArray addObjectsFromArray:[self requiredAuthTitles][1]];
    }
    
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *isCert = user.auth.zhimaCode;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[4]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[4]];
    }
    
    isCert = user.auth.taoBao;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[9]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[9]];
    }
    
    
    NSMutableArray<NSMutableArray *> *resultArray = [NSMutableArray array];
    [resultArray addObject:authFinishedArray];
    [resultArray addObject:authUnFinishedArray];
    
    return [resultArray copy];
}

- (NSArray<NSArray *> *)product2AuthTitles {
    NSMutableArray *authFinishedArray = [NSMutableArray array];
    NSMutableArray *authUnFinishedArray = [NSMutableArray array];
    
    if ([self requiredAuthTitles][0].count > 0) {
        [authFinishedArray addObjectsFromArray:[self requiredAuthTitles][0]];
    }
    
    if ([self requiredAuthTitles][1].count > 0) {
        [authUnFinishedArray addObjectsFromArray:[self requiredAuthTitles][1]];
    }
    
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *isCert = user.auth.accumulationFund;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[5]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[5]];
    }
    
    isCert = user.auth.socialSecurity;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[6]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[6]];
    }
    
    isCert = user.auth.creditInvestigation;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[7]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[7]];
    }
    
    
    NSMutableArray<NSMutableArray *> *resultArray = [NSMutableArray array];
    [resultArray addObject:authFinishedArray];
    [resultArray addObject:authUnFinishedArray];
    
    return [resultArray copy];
}

- (NSArray<NSArray *> *)product3AuthTitles {
    NSMutableArray *authFinishedArray = [NSMutableArray array];
    NSMutableArray *authUnFinishedArray = [NSMutableArray array];
    
    if ([self requiredAuthTitles][0].count > 0) {
        [authFinishedArray addObjectsFromArray:[self requiredAuthTitles][0]];
    }
    
    if ([self requiredAuthTitles][1].count > 0) {
        [authUnFinishedArray addObjectsFromArray:[self requiredAuthTitles][1]];
    }
    
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *isCert = user.auth.CHSI;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[8]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[8]];
    }
    
    isCert = user.auth.taoBao;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[10]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[10]];
    }
    
    NSMutableArray<NSMutableArray *> *resultArray = [NSMutableArray array];
    [resultArray addObject:authFinishedArray];
    [resultArray addObject:authUnFinishedArray];
    
    return [resultArray copy];
}

- (NSArray<NSArray *> *)product4AuthTitles {
    NSMutableArray *authFinishedArray = [NSMutableArray array];
    NSMutableArray *authUnFinishedArray = [NSMutableArray array];
    
    if ([self requiredAuthTitles][0].count > 0) {
        [authFinishedArray addObjectsFromArray:[self requiredAuthTitles][0]];
    }
    
    if ([self requiredAuthTitles][1].count > 0) {
        [authUnFinishedArray addObjectsFromArray:[self requiredAuthTitles][1]];
    }
    
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *isCert = user.auth.bankBillFlow;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[10]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[10]];
    }
    
    isCert = user.auth.creditInvestigation;
    if (!isCert || [isCert isEqualToString:@"1"]) {
        [authUnFinishedArray addObject:self.totalAuthNames[7]];
    } else {
        [authFinishedArray addObject:self.totalAuthNames[7]];
    }
    
    NSMutableArray<NSMutableArray *> *resultArray = [NSMutableArray array];
    [resultArray addObject:authFinishedArray];
    [resultArray addObject:authUnFinishedArray];
    
    return [resultArray copy];
}

/// 保存当前选择的产品数据
- (void)saveCurrentLoanDataWith:(HSLoanListModel *)loanListHomeModel
                  loanListModel:(HSLoanListModel *)loanListModel
                  homeDataModel:(HSHomeDataModel *)homeDataModel
                      longitude:(CGFloat)longitude
                       latitude:(CGFloat)latitude {
    self.loanListHomeModel = loanListHomeModel;
    self.loanListModel = loanListModel;
    self.homeDataModel = homeDataModel;
    self.longitude = longitude;
    self.latitude = latitude;
}

/// 读取选择的产品数据
- (void)readCurrentLoanData:(void (^)(HSLoanListModel *loanListHomeModel, HSLoanListModel *loanListModel, HSHomeDataModel *homeDataModel, CGFloat longitude, CGFloat latitude))completion {
    completion(self.loanListHomeModel, self.loanListModel, self.homeDataModel, self.longitude, self.latitude);
}

/// 保存当前借款产品信息，可用于跳转至额度激活界面
- (void)saveCurrentProductWithType:(ProductOption)productType
                     loanListModel:(HSLoanListModel *)loanListModel
                     homeDataModel:(HSHomeDataModel *)homeDataModel
                  isOfflineProduct:(BOOL)isOfflineProduct {
    self.productType = productType;
    self.loanListModel = loanListModel;
    self.homeDataModel = homeDataModel;
    self.isOfflineProduct = isOfflineProduct;
//    self.needJumpToBorrowVC = YES;
}

- (void)removeCurrentLoanModel {
    self.loanListModel = nil;
    self.homeDataModel = nil;
}

/// 获取当前借款产品信息
- (void)getCurrentLoanData:(void (^)(ProductOption productType, HSLoanListModel *loanListModel, HSHomeDataModel *homeDataModel, BOOL isOfflineProduct))completion {
    completion(self.productType, self.loanListModel, self.homeDataModel, self.isOfflineProduct);
//    self.needJumpToBorrowVC = NO;
}

/// 跳转至激活额度VC
- (void)jumpToLimitActivationVC {
    // 调用
    [self fetchGradeCompletion:^() {
        NSNumber *minNum = [self.loanListModel.mixCreditAmt convertToNumber];
        if (!minNum) {
            UIViewController *currentVC = [UIViewController currentViewController];
            [currentVC jumpToViewControllerWith:[HSProductSchemaViewController class]];
            [currentVC jumpToViewControllerWith:[HSDataManagementViewController class]];
            [currentVC jumpToViewControllerWith:[HSLimitPromotionViewController class]];
            return;
        }
        
        CGFloat min = [minNum floatValue];
        if ([_homeDataModel.Amt integerValue] < min) {
            NSString *tips = [NSString stringWithFormat:@"您的可借额度不足%.f元，无法激活额度", min];
            [SVProgressHUD showInfoWithStatus:tips];
            
            CGFloat duration = [tips hudShowDuration];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *currentVC = [UIViewController currentViewController];
                if ([currentVC jumpToViewControllerWith:[HSLimitPromotionViewController class]] == NO) {
                    if ([currentVC jumpToViewControllerWith:[HSProductSchemaViewController class]] == NO) {
                        [currentVC jumpToViewControllerWith:[HSDataManagementViewController class]];
                    }
                }
            });
            return;
        }
        
        HSLimitActivationViewController *vc = [[HSLimitActivationViewController alloc] initWithloanListModel:_loanListModel homeDataModel:_homeDataModel];
        vc.navbarIsTranslucent = YES;
        vc.hidesBottomBarWhenPushed = YES;
        UIViewController *currentVC = [UIViewController currentViewController];
        [currentVC backBarButtonItemWithImageName:@"button_back"];
        [currentVC.navigationController pushViewController:vc animated:YES];
    }];
}



#pragma mark - Api

- (void)fetchGradeCompletion:(void (^)(void))completion
{
    HSUser *user = [HSLoginInfo savedLoginInfo];
//    NSString *PHONE = user.phone;
    NSString *ID = user.ID;
//    NSString *UUID = user.UUID;
    NSString *PRODID = _loanListModel.applyApprovAll;
    if ([NSString isBlankString:PRODID]) {
        [SVProgressHUD showInfoWithStatus:@"请重新选择产品"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    [HSInterface getGradeForProductWithID:ID product:PRODID completion:^(BOOL success, NSString *message, HSHomeDataModel *model) {
        [SVProgressHUD dismiss];
        if (success) {
            _homeDataModel = model;
            completion();
        }
        else
        {
            if (![NSString isBlankString:message]) {
                [SVProgressHUD showInfoWithStatus:message];
                return;
            }
            [SVProgressHUD dismiss];
            completion();
        }
    }];
}




#pragma mark - Jump

- (void)jumpWithAuthName:(NSString *)authName {
    NSInteger index = [self.totalAuthNames indexOfObject:authName];
    [HSAuthFlowManager jumpToAuthVC:index];
}

/// 跳转至相应的认证界面
+ (void)jumpToAuthVC:(NSInteger)authIndex {
    HSAuthFlowManager *manager = [HSAuthFlowManager manager];
    
    // 直接跳转至认证界面
    if (authIndex == 0) {
        [manager jumpToCertVC];
    }
    else if (authIndex == 1) {
        [manager fetchOperatorInfoAndJump];
        //        [delegate jumpToZhimaVC];
        //        [delegate jumpToTaobaoVC];
    }
    else if (authIndex == 2) {
        [manager jumpToCareerVC];
        //        [delegate fetchOperatorInfoAndJump];
    }
    else if (authIndex == 3) {
        [manager jumpToContactInfoVC];
        //        [delegate jumpToZhimaVC];
    }
    else if (authIndex == 4) {
        [manager jumpToZhimaVC];
    }
    else if (authIndex == 5) {
        [manager jumpToAccumulationFundVC];
    }
    else if (authIndex == 6) {
        [manager jumpToSocialSecurityVC];
    }
    else if (authIndex == 7) {
        [manager jumpToCreditVC];
    }
    else if (authIndex == 8) {
        [manager jumpToCHSIAccountRegistrationViewController];
    }
    else if (authIndex == 9) {
        [manager jumpToTaobaoVC];
    }
    else if (authIndex == 10) {
        [manager jumpToCreditCardVC];
    }
    else if (authIndex == 11) {
        [manager jumpToIncomeVC];
    }
}

/// 自动跳转至相关认证VC
- (void)jumpToAuthVC {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        HSAuthAlertView *alertView = [HSAuthAlertView alertViewWithTitle:@"认证成功" butttonTitle:@"继续认证" buttonPressedBlock:^{
            AuthTipOption authOption = self.authOption;
            switch (authOption) {
                case AuthTipOptionRealName:
                {
                    HSUser *user = [HSLoginInfo savedLoginInfo];
                    if (user.auth && [user.auth.errorCode isEqualToString:@"0"]) {
                        UIViewController *currentVC = [UIViewController currentViewController];
                        [currentVC.navigationController popViewControllerAnimated:YES];
                    }
                }
                    break;
                    
                case AuthTipOptionRequired:
                {
                    if ([self requriedAuthIsFinished] == -100) {
                        if (_isOfflineProduct) {
                            UIViewController *currentVC = [UIViewController currentViewController];
                            [currentVC jumpToViewControllerWith:[HSProductSchemaViewController class]];
                        } else {
                            /// 跳转至产品概要界面
                            [self jumpToLimitActivationVC];
                        }
//                        UIViewController *currentVC = [UIViewController currentViewController];
//                        [currentVC.navigationController popViewControllerAnimated:YES];
                    } else {
                        [self requriedAuthIsNotFinishedAndJump];
                    }
                }
                    break;
                    
                case AuthTipOptionProduct1:
                {
                    if ([self authIsFinishedForFirstProduct] == -100) {
//                        [self jumpToBorrowVC];
                    } else {
                        HSAuthAlertView *alertView = [HSAuthAlertView alertViewWithTitle:@"认证成功" butttonTitle:@"继续认证" buttonPressedBlock:^{
                            [self product1AuthIsNotFinishedAndJump];
                        } cancelButtonPressed:^{
                            UIViewController *currentVC = [UIViewController currentViewController];
                            [currentVC.navigationController popViewControllerAnimated:YES];
                        }];
                        [alertView show];
                    }
                }
                    break;
                    
                case AuthTipOptionProduct2:
                {
                    if ([self authIsFinishedForSecondProduct] == -100) {
//                        [self jumpToBorrowVC];
                    } else {
                        HSAuthAlertView *alertView = [HSAuthAlertView alertViewWithTitle:@"认证成功" butttonTitle:@"继续认证" buttonPressedBlock:^{
                            [self product2AuthIsNotFinishedAndJump];
                        } cancelButtonPressed:^{
                            UIViewController *currentVC = [UIViewController currentViewController];
                            [currentVC.navigationController popViewControllerAnimated:YES];
                        }];
                        [alertView show];
                    }
                }
                    break;
                    
                case AuthTipOptionProduct3:
                {
                    if ([self authIsFinishedForThirdProduct] == -100) {
//                        [self jumpToBorrowVC];
                    } else {
                        HSAuthAlertView *alertView = [HSAuthAlertView alertViewWithTitle:@"认证成功" butttonTitle:@"继续认证" buttonPressedBlock:^{
                            [self product3AuthIsNotFinishedAndJump];
                        } cancelButtonPressed:^{
                            UIViewController *currentVC = [UIViewController currentViewController];
                            [currentVC.navigationController popViewControllerAnimated:YES];
                        }];
                        [alertView show];
                    }
                }
                    break;
                    
                case AuthTipOptionProduct4:
                {
                    if ([self authIsFinishedForFourthProduct] == -100) {
//                        [self jumpToBorrowVC];
                    } else {
                        HSAuthAlertView *alertView = [HSAuthAlertView alertViewWithTitle:@"认证成功" butttonTitle:@"继续认证" buttonPressedBlock:^{
                            [self product4AuthIsNotFinishedAndJump];
                        } cancelButtonPressed:^{
                            UIViewController *currentVC = [UIViewController currentViewController];
                            [currentVC.navigationController popViewControllerAnimated:YES];
                        }];
                        [alertView show];
                    }
                }
                    break;
                    
                default:
                    break;
            }
//        } cancelButtonPressed:^{
//            UIViewController *currentVC = [UIViewController currentViewController];
//            [currentVC.navigationController popViewControllerAnimated:YES];
//        }];
//        [alertView show];
    });
}

/// 跳转至实名认证VC
- (void)jumpToCertVC {
    HSCertificateViewController *vc = [[HSCertificateViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/// 获取当前用户手机号码是哪个运营商的，并跳转
- (void)fetchOperatorInfoAndJump {
    //    self.handerResuleString = @"mobile";
    //    sdkFunction = LMZXSDKFunctionMobileCarrie;
    //    [[HSLMZXManager manager] getLMsdkFunction:LMZXSDKFunctionMobileCarrie and:@"mobile"];
    
    
    NSString *phone = [HSLoginInfo savedLoginInfo].phone;
    if ([NSString isBlankString:phone]) {
        [SVProgressHUD showInfoWithStatus:@"手机号为空，无法获取运营商信息"];
        return;
    }
    //        NSString *phone = user.phone;
    //    NSString *phone = @"18220834780";//移动
    //        NSString *phone = @"17629003948";//联通
    //    NSString *phone = @"15388657853";//电信
    
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    [HSInterface fetchOperatorWithPhone:phone Completion:^(BOOL success, NSString *message, HSMobileBelongModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [SVProgressHUD dismiss];
                if ([model.MobileBelong containsString:@"移动"]) {
                    HSCallRecordsChinaMobileFirstViewController *callRecordsChinaMobileViewController = [[HSCallRecordsChinaMobileFirstViewController alloc] init];
                    callRecordsChinaMobileViewController.isInAuthFlow = YES;
                    callRecordsChinaMobileViewController.mobileBelongModel = model;
                    callRecordsChinaMobileViewController.hidesBottomBarWhenPushed = YES;
                    
                    UIViewController *vc = [UIViewController currentViewController];
                    [vc backBarButtonItemWithImageName:@"button_back"];
                    [vc.navigationController pushViewController:callRecordsChinaMobileViewController animated:YES];
                }
                else if ([model.MobileBelong containsString:@"联通"])
                {
                    HSCallRecordsChinaUnicornFirstViewController *callRecordsChinaUnicornFirstViewController = [[HSCallRecordsChinaUnicornFirstViewController alloc] init];
                    callRecordsChinaUnicornFirstViewController.isInAuthFlow = YES;
                    callRecordsChinaUnicornFirstViewController.mobileBelongModel = model;
                    callRecordsChinaUnicornFirstViewController.hidesBottomBarWhenPushed = YES;
                    
                    UIViewController *vc = [UIViewController currentViewController];
                    [vc backBarButtonItemWithImageName:@"button_back"];
                    [vc.navigationController pushViewController:callRecordsChinaUnicornFirstViewController animated:YES];
                }
                else if ([model.MobileBelong containsString:@"电信"])
                {
                    HSCallRecordsChinaTelecomVC *callRecordsChinaTelecomVC = [[HSCallRecordsChinaTelecomVC alloc] init];
                    callRecordsChinaTelecomVC.isInAuthFlow = YES;
                    callRecordsChinaTelecomVC.mobileBelongModel = model;
                    callRecordsChinaTelecomVC.hidesBottomBarWhenPushed = YES;
                    
                    UIViewController *vc = [UIViewController currentViewController];
                    [vc backBarButtonItemWithImageName:@"button_back"];
                    [vc.navigationController pushViewController:callRecordsChinaTelecomVC animated:YES];
                }
            }
            else
            {
                if (![NSString isBlankString:message]) {
                    [SVProgressHUD showInfoWithStatus:message];
                    return;
                }
                [SVProgressHUD dismiss];
            }
        });
    }];
}

/// 跳转至工作单位信息认证
- (void)jumpToCareerVC {
    HSCareerViewController *vc = [[HSCareerViewController alloc] init];
//    vc.navbarIsTranslucent = YES;
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/// 跳转至联系人信息认证
- (void)jumpToContactInfoVC {
    HSContactInfoViewController *vc = [[HSContactInfoViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/// 跳转至淘宝VC
- (void)jumpToTaobaoVC {
//    HSTaoBaoViewController *vc = [[HSTaoBaoViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    UIViewController *currentVC = [UIViewController currentViewController];
//    [currentVC backBarButtonItemWithImageName:@"button_back"];
//    [currentVC.navigationController pushViewController:vc animated:YES];
    
    
    //跳转至淘宝的wek界面信息
    HSTaobaoWebViewController *vc = [[HSTaobaoWebViewController alloc]init];
//    HSTaoBaoViewController *vc = [[HSTaoBaoViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:vc animated:YES];
    
//    [[HSLMZXManager manager] getLMsdkFunction:LMZXSDKFunctionTaoBao and:@"taobao"];
}

//学信网
- (void)jumpToCHSIAccountRegistrationViewController {
    // 返回按钮
    HSCHSIAccountRegistrationViewController *vc = [[HSCHSIAccountRegistrationViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

// 跳转至芝麻WebVC
- (void)jumpToZhimaVC {
    HSUser *user = [HSLoginInfo savedLoginInfo];
    NSString *name = user.custname;
    NSString *cardID = user.paperid;
    NSString *ID = user.ID;
    NSLog(@"芝麻信用未认证");
    
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    [HSInterface fetchZhimaCreditInfoWithnameName:name cardNo:cardID ID:ID completion:^(BOOL success, NSString *message, HSUserInfoModel *model) {
        if (success) {
            NSLog(@"芝麻信用认证success");
            [SVProgressHUD dismiss];
            HSZhimaWebViewController *zhimaWebViewController = [[HSZhimaWebViewController alloc] init];
            zhimaWebViewController.zhimaUrl = model.errorInfo;
//            zhimaWebViewController.isInAuthFlow = YES;
            zhimaWebViewController.hidesBottomBarWhenPushed = YES;
            
            UIViewController *vc = [UIViewController currentViewController];
            [vc backBarButtonItemWithImageName:@"button_back"];
            [vc.navigationController pushViewController:zhimaWebViewController animated:YES];
        }
        else
        {
            NSLog(@"芝麻信用认证message");
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}


- (void)jumpToAccumulationFundVC {


    HSNewAccumulationFundViewController *newAccumulationFundViewController = [[HSNewAccumulationFundViewController alloc] init];
    newAccumulationFundViewController.hidesBottomBarWhenPushed = YES;
    newAccumulationFundViewController.isInAuthFlow = YES;

    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:newAccumulationFundViewController animated:YES];



//    HSAccumulationFundViewController *vc = [[HSAccumulationFundViewController alloc] init];
//    vc.isInAuthFlow = YES;
//    vc.hidesBottomBarWhenPushed = YES;
//    
//    UIViewController *currentVC = [UIViewController currentViewController];
//    [currentVC backBarButtonItemWithImageName:@"button_back"];
//    [currentVC.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSocialSecurityVC {
//    HSSocialSecurityViewController *vc = [[HSSocialSecurityViewController alloc] init];
//    vc.isInAuthFlow = YES;
//    vc.hidesBottomBarWhenPushed = YES;
//    
//    UIViewController *currentVC = [UIViewController currentViewController];
//    [currentVC backBarButtonItemWithImageName:@"button_back"];
//    [currentVC.navigationController pushViewController:vc animated:YES];

    HSNewSocialSecurityViewController *newSocialSecurityViewController = [[HSNewSocialSecurityViewController alloc] init];
    newSocialSecurityViewController.hidesBottomBarWhenPushed = YES;
    newSocialSecurityViewController.isInAuthFlow = YES;

    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:newSocialSecurityViewController animated:YES];
}

// 跳转至社保公积金tableViewController
//- (void)jumpToAccumulationFundAndSocialSecurityVC {
//    HSAccumulationFundAndSocialSecurityTableVC *vc = [[HSAccumulationFundAndSocialSecurityTableVC alloc] init];
//    
//    vc.hidesBottomBarWhenPushed = YES;
//    UIViewController *currentVC = [UIViewController currentViewController];
//    [currentVC backBarButtonItemWithImageName:@"button_back"];
//    [currentVC.navigationController pushViewController:vc animated:YES];
//}


/// 跳转至征信VC
- (void)jumpToCreditVC {
    // 征信VC
    HSCreditInvestigationViewController *vc = [[HSCreditInvestigationViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/// 跳转至信用卡详单
- (void)jumpToCreditCardVC {
    HSAddBankCardBillViewController *vc = [[HSAddBankCardBillViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:vc animated:YES];
}

/// 跳转收入证明认证
- (void)jumpToIncomeVC
{
    HSIncomeCertifyViewController *vc = [[HSIncomeCertifyViewController alloc] init];
    vc.isInAuthFlow = YES;
    vc.hidesBottomBarWhenPushed = YES;
    UIViewController *currentVC = [UIViewController currentViewController];
    [currentVC backBarButtonItemWithImageName:@"button_back"];
    [currentVC.navigationController pushViewController:vc animated:YES];
}


@end
