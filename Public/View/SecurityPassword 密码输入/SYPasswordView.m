//
//  SYPasswordView.m
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "SYPasswordView.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height self.frame.size.height  //每一个输入框的高度等于当前view的高度
#define kLineColor [UIColor colorWithRed:0.8353 green:0.8353 blue:0.8353 alpha:1.0f];

@interface SYPasswordView ()

@property (nonatomic, strong) NSMutableArray *dotViewArray; //用于存放黑色的点点
@property (nonatomic, assign) NSInteger dotCount;

@end

@implementation SYPasswordView

#pragma mark - Getter

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        UIColor *borderColor = kLineColor;
        _textField.layer.borderColor = [borderColor CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}



#pragma mark - Initializer

- (id)initWithFrame:(CGRect)frame
           dotCount:(NSInteger)dotCont {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dotCount = dotCont;
        [self initPwdTextField];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
    }
    return self;
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    if (self.dotCount == 0) {
        self.dotCount = kDotCount;
    }
    CGFloat width = self.frame.size.width / self.dotCount;
    
    //生成分割线
    for (int i = 0; i < self.dotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 1, K_Field_Height)];
        lineView.backgroundColor = kLineColor;
        [self addSubview:lineView];
    }
    
    self.dotViewArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < self.dotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - self.dotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotViewArray addObject:dotView];
    }
}

- (void)dealloc {
    _textField.delegate = nil;
}



#pragma mark - Text Field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    } else if(textField.text.length > self.dotCount) {
        //输入的字符个数大于kDotCount，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数过多，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotViewArray) {
        dotView.hidden = YES;
    }
    
    if (self.dotViewArray.count < textField.text.length) {
        if (self.inputFinished) {
            self.inputFinished(NO, textField.text);
        }
        return;
    }
    
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotViewArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == self.dotCount) {
        [self.textField resignFirstResponder];
        if (self.inputFinished) {
            self.inputFinished(YES, textField.text);
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.inputFinished) {
        if ([self isBlankString:textField.text] ||
            (self.dotCount > 0 && textField.text.length < self.dotCount)) {
            self.inputFinished(NO, textField.text);
        }
    }
}



#pragma mark - Func

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/// 判断字符串是否为空
- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
