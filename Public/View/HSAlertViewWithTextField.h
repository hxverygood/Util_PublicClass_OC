//
//  HSAlertViewWithTextField.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/10/23.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAlertViewWithTextField : UIView

@property (nonatomic, copy) void (^cancelBlock)(void);

+ (instancetype)alertViewWithTitle:(NSString *)title
                           content:(NSString *)content;

- (void)showWithConfirmButtonPressed:(void (^)(NSString *inputContent))confirmButtonPressed;

- (void)setTitle:(NSString *)title;
- (void)setContent:(NSString *)content;
- (void)setTextfieldPlaceholder:(NSString *)placeholder;

- (void)dismissWithCompletion:(void (^)(void))completion;

- (void)clear;

@end
