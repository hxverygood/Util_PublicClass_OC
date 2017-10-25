//
//  HSAlertViewWithTextField.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/10/23.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSAlertViewWithTextField.h"
#import "JCAlertView.h"

@interface HSAlertViewWithTextField ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet HSTextField *textfield;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) JCAlertView *alertView;
@property (nonatomic, copy) void (^confirmButtonPressedBlock)(NSString *inputContent);

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@end



@implementation HSAlertViewWithTextField

#pragma mark - Initializer

+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content {
    return [[HSAlertViewWithTextField alloc] initWithTitle:title content:content];
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSAlertViewWithTextField" owner:nil options:nil] lastObject];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        
        self.title = title;
        self.content = content;
        
        self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
        self.contentLabel.text = [NSString isBlankString:content] ? @"" : content;
        
        self.textfield.maxTextLength = 16;
        self.textfield.restrictType = HSRestrictTypeOnlyNumber;
    }
    return self;
}



#pragma mark - Action

- (IBAction)confirmButtonPressed:(id)sender {
    if ([NSString isBlankString:self.textfield.text]) {
        [SVProgressHUD showInfoWithStatus:@"输入内容为空，请检查"];
        return;
    }
    
    if (self.confirmButtonPressedBlock) {
        self.confirmButtonPressedBlock(self.textfield.text);
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [_alertView dismissWithCompletion:nil];
}

- (IBAction)closeButtonPressed:(id)sender {
    [_alertView dismissWithCompletion:nil];
}




#pragma mark - Func

- (void)showWithConfirmButtonPressed:(void (^)(NSString *inputContent))confirmButtonPressed {
    if (confirmButtonPressed) {
        self.confirmButtonPressedBlock = confirmButtonPressed;
    }
    
    __weak typeof(self) weakSelf = self;
     _alertView = [[JCAlertView alloc] initWithCustomView:weakSelf dismissWhenTouchedBackground:YES];
    [_alertView show];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_alertView dismissWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)clear {
    _textfield.text = @"";
}


@end
