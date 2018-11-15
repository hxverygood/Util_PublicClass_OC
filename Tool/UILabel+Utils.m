//
//  UILabel+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/29.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

/// 给用于显示金额的label添加带有 ¥ 符号的富文本
- (void)addAttributedPriceWithMoneySymbol:(NSString *)price {
    NSString *priceStr = [NSString isBlankString:price] ? @"¥ 0.00" : [NSString stringWithFormat:@"¥ %@", price];
    NSMutableAttributedString *mutStr = [NSMutableAttributedString attributedWithString:priceStr fromIndex:0 toIndex:0 withSize:17.0 andOtherSize:17.0 withColor:BlackColor andOtherColor:RedColor lineHeight:1.0];
    self.attributedText = mutStr;
}

@end
