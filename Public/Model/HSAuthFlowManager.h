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

@property (nonatomic, assign, readonly) CGFloat currentPercentInFlow;
@property (nonatomic, assign, readonly) CGFloat percentAfterCurrentFlowComplete;
@property (nonatomic, assign, readonly) NSInteger totalCount;
@property (nonatomic, assign, readonly) AuthTipOption authOption;
@property (nonatomic, assign, readonly) ProductOption currentProductType;

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

/// 芝麻秒贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForFirstProduct;
- (BOOL)product1AuthIsNotFinishedAndJump;

/// 土豪贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForSecondProduct;
- (BOOL)product2AuthIsNotFinishedAndJump;

/// 学霸贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForThirdProduct;
- (BOOL)product3AuthIsNotFinishedAndJump;

/// 高富贷的认证流程是否完成，如没有完成则跳转
- (NSInteger)authIsFinishedForFourthProduct;
- (BOOL)product4AuthIsNotFinishedAndJump;

/// 产品的标题数组
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
                     homeDataModel:(HSHomeDataModel *)homeDataModel;
- (void)moveCurrentLoanModel;

/// 获取当前借款产品信息
- (void)getCurrentLoanData:(void (^)(ProductOption productType, HSLoanListModel *loanListModel, HSHomeDataModel *homeDataModel))completion;


- (void)jumpToBorrowVC;
/// 跳转至产品概要界面
- (void)jumpToProductSchemaVC;

/// 自动跳转至相关认证VC
- (void)jumpToAuthVC;


#pragma mark - Public Func

- (ProductOption)getAuthOptionWithName:(NSString *)name;
// 将认证自定义字段名转换为认证名称
- (NSString *)convertAuthName:(NSString *)authName;

@end
