//
//  HXMoneyTextField.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/3/22.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HXMoneyTextField.h"

@interface HXMoneyTextField () <UITextFieldDelegate>
@end

@implementation HXMoneyTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tintColor = YELLOW;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        self.totalCount = -1;
//        self.integerCount = -1;
        self.decimalCount = -1;
//        self.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = YELLOW;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.totalCount = -1;
//    self.integerCount = -1;
    self.decimalCount = -1;
//    self.delegate = self;
}



#pragma mark - Text Field

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 如果是删除操作
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    // 已经输入的文字信息
    NSString *inputedText = textField.text;
    
    // 如果已输入的数字数量大于指定数量
    if (inputedText.length >= 9) {
        return NO;
    }
    else if (inputedText.length == 8 &&
             [string isEqualToString:@"."]) {
        // 如果长度限制下的最后一位是小数点，则不能输入
        return NO;
    }
    
    // 如果首先输入的不是小数点，并且已输入的字符串中没有小数点，则可以输入
    if (inputedText.length > 0 &&
        [inputedText containsString:@"."] == NO &&
        [string isEqualToString:@"."]) {
        return YES;
    }
    
    NSMutableString *mutStr = [inputedText mutableCopy];
    [mutStr insertString:string atIndex:range.location];
    
    NSString *regex = @"^(([1-9]\\d*)|0)(.\\d{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:mutStr];
    return result;
}


@end
