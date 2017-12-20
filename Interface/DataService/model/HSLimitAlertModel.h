//
//  HSLimitAlertModel.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/20.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "CoreModel.h"

@interface HSLimitAlertModel : CoreModel

/// 产品名称
@property (nonatomic, strong) NSString *productName;
/// 不再显示额度有效的弹窗
@property (nonatomic, assign) BOOL neverShowLimitValid;
/// 不再显示额度无效的弹窗
@property (nonatomic, assign) BOOL neverShowLimitInvalid;

@end
