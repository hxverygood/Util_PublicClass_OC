//
//  HSSectionHeaderView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSSectionHeaderView.h"

@interface HSSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@end

@implementation HSSectionHeaderView

+ (instancetype)view {
    return [[HSSectionHeaderView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSSectionHeaderView" owner:self options:nil] objectAtIndex:0];
        
        CGRect frame = self.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        self.frame = frame;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.headerTitleLabel.text = [NSString isBlankString:title] ? @"" : title;
}

@end
