//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) void (^inputFinished)(BOOL inputFinished, NSString *inputText);

- (id)initWithFrame:(CGRect)frame
           dotCount:(NSInteger)dotCont;

/**
 *  清除密码
 */
- (void)clearUpPassword;

@end
