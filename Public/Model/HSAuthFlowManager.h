//
//  HSAuthFlowManager.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/16.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSUser.h"

//typedef NS_ENUM(NSInteger, AuthFlowOption) {
//    AuthFlowOptionAllFinished <<< 0
//    
//};

@class HSLoanListModel;
@class HSHomeDataModel;

@interface HSAuthFlowManager : NSObject

@property (nonatomic, strong, readonly) NSArray *product1AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *product2AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *product3AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *product4AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *offlineProduct1AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *offlineProduct1PromotionAuthNames;
@property (nonatomic, strong, readonly) NSArray *offlineProduct2AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *offlineProduct3AuthNameArray;
@property (nonatomic, strong, readonly) NSArray *offlineProduct4AuthNameArray;

@property (nonatomic, assign, readonly) CGFloat currentPercentInFlow;
@property (nonatomic, assign, readonly) CGFloat percentAfterCurrentFlowComplete;
@property (nonatomic, assign, readonly) NSInteger totalCount;
@property (nonatomic, assign, readonly) AuthTipOption authOption;
@property (nonatomic, assign, readonly) ProductOption currentProductType;

/// 线下产品认证项数组
@property (nonatomic, strong) NSArray<NSArray *> *offlineProductNames;




+ (instancetype)manager;

/// 必须认证的4项是否完成
- (NSInteger)requriedAuthIsFinished;
/// 必须认证的4项是否完成，如果没完成则跳转进行认证
- (BOOL)requriedAuthIsNotFinishedAndJump;

///是否进行了必要认证1，没有完成认证则跳转，下同
- (BOOL)requriedAuth1IsNotFinishedAndJump;

/// 必要认证2
//- (BOOL)requriedAuth2IsNotFinishedAndJump;

/// 对必须认证的项目进行跳转
//- (BOOL)requriedAuthIsNotFinishedAndJump;

/// 第2等必须认证的情况
//- (NSInteger)requriedAuth2IsFinished;

/// 是否需要实名认证
- (BOOL)realNameIsAuthed;

/// 线上产品显示的认证是否完成
- (BOOL)onlineProductDisplayAuthIsFinished:(ProductOption)productOption;

/// 线下产品显示的认证是否完成
- (BOOL)offlineProductDisplayAuthIsFinished:(OfflineProductOption)offlineProductOption;

/// 芝麻秒贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForFirstProduct;
- (BOOL)product1AuthIsNotFinishedAndJump;
/// 查找处于认证中的”必要认证“索引
- (NSInteger)requriedAuthIsInProccessing;

/// 土豪贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForSecondProduct;
- (BOOL)product2AuthIsNotFinishedAndJump;

/// 学霸贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForThirdProduct;
- (BOOL)product3AuthIsNotFinishedAndJump;

/// 高富贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForFourthProduct;
- (BOOL)product4AuthIsNotFinishedAndJump;

/// 线下产品 融易贷
- (NSInteger)authIsFinishedForOfflineProduct1;
- (BOOL)offlineProduct1AuthIsNotFinishedAndJump;

/// 线下产品 薪居贷
- (NSInteger)authIsFinishedForOfflineProduct2;
- (BOOL)offlineProduct2AuthIsNotFinishedAndJump;

/// 线下产品 开薪贷
- (NSInteger)authIsFinishedForOfflineProduct3;
- (BOOL)offlineProduct3AuthIsNotFinishedAndJump;

/// 线下产品 安居贷
- (NSInteger)authIsFinishedForOfflineProduct4;
- (BOOL)offlineProduct4AuthIsNotFinishedAndJump;

/// 线上产品的标题数组
- (NSArray<NSArray *> *)product1AuthTitles;
- (NSArray<NSArray *> *)product2AuthTitles;
- (NSArray<NSArray *> *)product3AuthTitles;
- (NSArray<NSArray *> *)product4AuthTitles;




/// 保存当前选择的产品数据
- (void)saveCurrentLoanDataWith:(HSLoanListModel *)loanListHomeModel
                  loanListModel:(HSLoanListModel *)loanListModel
                  homeDataModel:(HSHomeDataModel *)homeDataModel
                      longitude:(CGFloat)longitude
                       latitude:(CGFloat)latitude;

/// 读取选择的产品数据
- (void)readCurrentLoanData:(void (^)(HSLoanListModel *loanListHomeModel, HSLoanListModel *loanListModel, HSHomeDataModel *homeDataModel, CGFloat longitude, CGFloat latitude))completion;

/// 保存当前借款产品信息，可用于跳转至额度激活界面
- (void)saveCurrentProductWithType:(ProductOption)productType
                     loanListModel:(HSLoanListModel *)loanListModel
                     homeDataModel:(HSHomeDataModel *)homeDataModel
                  isOfflineProduct:(BOOL)isOfflineProduct;

/// 获取当前借款产品信息
- (void)getCurrentLoanData:(void (^)(ProductOption productType, HSLoanListModel *loanListModel, HSHomeDataModel *homeDataModel, BOOL isOfflineProduct))completion;

/// 移除当前借款产品信息
- (void)removeCurrentLoanModel;


//- (void)jumpToBorrowVC;
/// 跳转至产品概要界面
//- (void)jumpToProductSchemaVC;

/// 自动跳转至相关认证VC
- (void)jumpToAuthVC;

/// 跳转至实名认证VC
- (void)jumpToCertVC;
/// 获取当前用户手机号码是哪个运营商的，并跳转至相关认证界面
- (void)fetchOperatorInfoAndJump;
/// 跳转至芝麻WebVC
- (void)jumpToZhimaVC;
/// 跳转至社保认证VC
- (void)jumpToSocialSecurityVC;
/// 跳转至公积金认证VC
- (void)jumpToAccumulationFundVC;
/// 跳转至征信VC
- (void)jumpToCreditVC;
/// 学信网认证VC
- (void)jumpToCHSIAccountRegistrationViewController;
/// 跳转至淘宝VC
- (void)jumpToTaobaoVC;
/// 跳转至信用卡详单VC
- (void)jumpToCreditCardVC;
/// 跳转收入证明认证VC
- (void)jumpToIncomeVC;


#pragma mark - Public Func

- (ProductOption)getAuthOptionWithName:(NSString *)name;
// 将认证自定义字段名转换为认证名称
- (NSString *)convertAuthName:(NSString *)authName;

@end
