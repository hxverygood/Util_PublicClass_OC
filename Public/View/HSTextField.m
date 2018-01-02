//
//  HSTextField.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/17.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSTextField.h"

@interface HSTextField ()

@property (nonatomic, strong) UIColor *defaultTextColor;

@end

@implementation HSTextField

#pragma mark - Getter

- (UIColor *)defaultTextColor {
    if (!_defaultTextColor) {
        _defaultTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6];
    }
    return _defaultTextColor;
}

#pragma mark - Initailizer

/// 两端为大圆角的textField
+ (instancetype _Nullable)roundCornerTextFieldWithFrame:(CGRect)frame
                                              textColor:(UIColor * _Nullable)textColor
                                            placeholder:(NSString * _Nullable )placehoder {
    return [[HSTextField alloc] initWithFrame:frame fontSize:15.0 textColor:textColor placeholder:placehoder placeholderColor:textColor cornerRadius:CGRectGetHeight(frame)/2];
}

/// 生成自定义颜色的textField
+ (instancetype _Nullable)textFieldWithFrame:(CGRect)frame
                                    fontSize:(CGFloat)fontSize
                                   textColor:(UIColor * _Nullable)textColor
                                 placeholder:(NSString * _Nullable )placehoder
                            placeholderColor:(UIColor * _Nullable)placeholderColor
                                cornerRadius:(CGFloat)cornerRadius {
    return [[HSTextField alloc] initWithFrame:frame
                              fontSize:fontSize
                             textColor:textColor
                           placeholder:placehoder
                      placeholderColor:placeholderColor
                          cornerRadius:cornerRadius];
}

- (instancetype)initWithFrame:(CGRect)frame
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor * _Nullable)textColor
                  placeholder:(NSString * _Nullable)placehoder
             placeholderColor:(UIColor * _Nullable)placeholderColor
                 cornerRadius:(CGFloat)cornerRadius {
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:fontSize];
        self.textAlignment = NSTextAlignmentLeft;
        self.textColor = textColor;
        self.tintColor = textColor;
        
        self.placeholder = placehoder;
        [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
        
        [self setValue:[UIFont systemFontOfSize:fontSize] forKeyPath:@"_placeholderLabel.font"];
        
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        
        if (cornerRadius > 0) {
            self.layer.cornerRadius = cornerRadius;
            self.layer.masksToBounds = YES;
            self.layer.borderColor = textColor.CGColor;
            self.layer.borderWidth = 1.0;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = YELLOW;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tintColor = YELLOW;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tintColor = YELLOW;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}



#pragma mark - Func

//- (void)setTextColor:(UIColor * _Nullable)textColor {
//    if (!self) {
//        return;
//    }
//    [self setTextColor:textColor placeholderColor:textColor];
//}

- (void)setTextColor:(UIColor * _Nullable)textColor
    placeholderColor:(UIColor * _Nullable)placeholderColor {
    if (self) {
        if (textColor) {
            self.textColor = textColor;
            self.tintColor = textColor;
        }
        
        [self setPlaceholderColor:placeholderColor];
    }
}

- (void)setTextColor:(UIColor * _Nullable)textColor
           tintColor:(UIColor * _Nullable)tintColor {
    if (self) {
        if (textColor) {
            self.textColor = textColor;
            self.tintColor = tintColor;
        }
        
//        [self setPlaceholderColor:tintColor];
    }
}

- (void)setPlaceholderColor:(UIColor * _Nullable)placeholderColor {
    if (!self) {
        return;
    }
    
    if (placeholderColor) {
        [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)roundCornerTextField {
    self.font = [UIFont systemFontOfSize:15.0];
    self.textColor = self.defaultTextColor;
    self.tintColor = self.defaultTextColor;
    [self setValue:self.defaultTextColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:15.0] forKeyPath:@"_placeholderLabel.font"];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = self.defaultTextColor.CGColor;
    self.layer.borderWidth = 1.0;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0.0, 0.0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0.0, 0.0);
}


@end
