//
//  UILabel+Utils.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/29.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

/// 给用于显示金额的label添加带有¥符号的富文本
- (void)addAttributedPriceWithMoneySymbol:(NSString *)price;

@end
