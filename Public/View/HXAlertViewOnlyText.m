//
//  HXAlertViewOnlyText.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/6.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HXAlertViewOnlyText.h"
#import "JCAlertView.h"

@interface HXAlertViewOnlyText ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) JCAlertView *alertView;
@property (nonatomic, strong) NSString *content;

@end



@implementation HXAlertViewOnlyText

#pragma mark - Initializer

+ (instancetype)alertViewWithContent:(NSString *)content {
    return [[HXAlertViewOnlyText alloc] initWithContent:content];
}

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HXAlertViewOnlyText" owner:nil options:nil] lastObject];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        self.content = content;
        self.contentLabel.text = [NSString isBlankString:content] ? @"" : content;
    }
    
    return self;
}



#pragma mark - Func

- (void)showWithConfirmButtonPressed:(void (^)(void))confirmButtonPressed {
    if (confirmButtonPressed) {
        confirmButtonPressed();
    }
    
    __weak typeof(self) weakSelf = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:weakSelf dismissWhenTouchedBackground:NO];
    [_alertView show];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_alertView dismissWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}
- (IBAction)touchDIsmissAction:(id)sender
{
    [self dismissWithCompletion:^{
        
    }];
}


@end
