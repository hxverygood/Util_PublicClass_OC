//
//  HXMoneyTextField.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/3/22.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMoneyTextField : UITextField

// 用于金额的UITextField，暂时无法正常使用，但delegate方法可以参考

/// 总位数
@property (nonatomic, assign) NSInteger totalCount;
///// 整数位数
//@property (nonatomic, assign) NSInteger integerCount;
/// 小数点位数
@property (nonatomic, assign) NSInteger decimalCount;

@end
