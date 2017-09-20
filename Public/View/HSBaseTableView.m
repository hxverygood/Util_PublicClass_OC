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

- (instancetype)init {
    self = [super init];
    if (self) {
//        HSBaseTableView *baseTV = [[HSBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self = baseTV;
    }
    
    return self;
}


#pragma mark - CYLTableViewPlaceHolder Delegate

- (UIView *)makePlaceHolderView {
    HSNoDataCustomeView *noDataView = [[HSNoDataCustomeView alloc] initWithFrame:self.frame content:self.placeholderContent];
    return noDataView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing {
    return YES;
}

@end
