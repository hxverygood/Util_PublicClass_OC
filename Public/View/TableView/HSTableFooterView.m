//
//  HSTableFooterView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSTableFooterView.h"

@interface HSTableFooterView ()

@property (weak, nonatomic) IBOutlet HSBaseButton *button;

@end

@implementation HSTableFooterView

+ (instancetype)view {
    return [[HSTableFooterView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSTableFooterView" owner:self options:nil] objectAtIndex:0];
        [self.button setTitle:@"" forState:UIControlStateNormal];
        CGRect frame = self.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.height;
        self.frame = frame;
    }
    return self;
}

- (void)setButtonTitle:(NSString *)title {
    [self.button setTitle:[NSString isBlankString:title] ? @"下一步" : title  forState:UIControlStateNormal];
}

- (IBAction)buttonPressed:(id)sender {
    if (self.buttonAction) {
        self.buttonAction();
    }
}

@end
