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

+ (instancetype)alertViewWithTitle:(NSString *)title
                     titleFontSize:(CGFloat)titleFontSize {
    return [[HSAlertViewWithTextField alloc] initWithTitle:title titleFontSize:titleFontSize];
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
        
        [self.confirmButton setCornerRadius:ButtonCorner];
        
        
        if ([title containsString:@"验证码"]) {
            self.textfield.maxTextLength = 10;
            self.textfield.restrictType = HSRestrictTypeCharacterAndNumber;
            self.textfield.placeholder = @"请输入验证码";
        }
        else {
            self.textfield.maxTextLength = 16;
            self.textfield.restrictType = HSRestrictTypeOnlyNumber;
            self.textfield.placeholder = @"";
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                titleFontSize:(CGFloat)titleFontSize {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HSAlertViewWithTextField" owner:nil options:nil] lastObject];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        
        self.title = title;
        self.content = nil;
        
        self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
        self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
        self.contentLabel.text = @"";
        
        [self.confirmButton setCornerRadius:ButtonCorner];

        if ([title containsString:@"验证码"]) {
            self.textfield.maxTextLength = 10;
            self.textfield.restrictType = HSRestrictTypeCharacterAndNumber;
            self.textfield.placeholder = @"请输入验证码";
        }
        else {
            self.textfield.maxTextLength = 16;
            self.textfield.restrictType = HSRestrictTypeOnlyNumber;
            self.textfield.placeholder = @"";
        }
    }
    return self;
}



#pragma mark - Action

- (IBAction)confirmButtonPressed:(id)sender {
    if ([NSString isBlankString:self.textfield.text]) {
        if (self.confirmButtonPressedBlock) {
            self.confirmButtonPressedBlock(self.textfield.text);
        }
        return;
    }
    
    [_alertView dismissWithCompletion:^{
        if (self.confirmButtonPressedBlock) {
            self.confirmButtonPressedBlock(self.textfield.text);
        }
    }];
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
     _alertView = [[JCAlertView alloc] initWithCustomView:weakSelf dismissWhenTouchedBackground:NO];
    [_alertView show];
    
    [_textfield becomeFirstResponder];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_textfield resignFirstResponder];
    [_alertView dismissWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)clear {
    _textfield.text = @"";
}

/// 设置标题
- (void)setTitle:(NSString *)title {
    self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
}

/// 设置提示内容
- (void)setContent:(NSString *)content {
    self.contentLabel.text = [NSString isBlankString:content] ? @"请输入邀请码" : content;
}

/// 设置输入框placeholder内容
- (void)setTextfieldPlaceholder:(NSString *)placeholder {
    self.textfield.placeholder = [NSString isBlankString:placeholder] ? @"" : placeholder;
}


@end
