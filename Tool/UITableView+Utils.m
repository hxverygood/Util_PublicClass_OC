//
//  UITableView+Utils.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/7/4.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

/// 用nibname注册tableViewCell
- (void)registerNibWithNibNames:(NSArray<NSString *> *)nibNames {
    for (NSString *nibName in nibNames) {
        [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
    }
}

@end
