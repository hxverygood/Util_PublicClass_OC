//
//  HSBaseTableView.m
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/1/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseTableView.h"
#import "CYLTableViewPlaceHolder.h"
#import "HSNoDataCustomeView.h"

@interface HSBaseTableView () <CYLTableViewPlaceHolderDelegate>

@end

@implementation HSBaseTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = HS_BACKGROUND;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
//        self.contentInset = UIEdgeInsetsMake(0.0, 0.0, [self isIPhoneX] ? 34.0 : 0.0, 0.0);
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = HS_BACKGROUND;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
        
//        self.contentInset = UIEdgeInsetsMake(0.0, 0.0, [self isIPhoneX] ? 34.0 : 0.0, 0.0);
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}



#pragma mark - CYLTableViewPlaceHolder Delegate

- (UIView *)makePlaceHolderView {
    HSNoDataCustomeView *noDataView = [[HSNoDataCustomeView alloc] initWithFrame:self.frame content:self.placeholderContent];
    return noDataView;
}
 
- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}



#pragma mark - Func

- (BOOL)isIPhoneX {
    BOOL flag = [[UIScreen mainScreen] bounds].size.width == 375.f && [[UIScreen mainScreen] bounds].size.height == 812.f ? YES : NO;
    return flag;
}

@end
