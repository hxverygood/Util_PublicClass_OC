//
//  UITableViewCell+UI.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/10/31.
//  Copyright © 2017年 hoomsun. All rights reserved.
//



@interface UITableViewCell (UI)

/// 分隔线左侧是否留有空间
- (void)leftSpaceForSeparator:(BOOL)needShow;

/// 分隔线距左侧距离
- (void)separatorLeftSpace:(CGFloat)leftSpace;

/// 是否显示分隔线
- (void)showSeparator:(BOOL)needShow;

@end
