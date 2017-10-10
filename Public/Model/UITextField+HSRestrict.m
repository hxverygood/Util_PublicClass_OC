//
//  UITextField+HSRestrict.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/27.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "UITextField+HSRestrict.h"
#import <objc/runtime.h>


static char *HSRestrictTypeKey = "HSRestrictTypeKey";
static char *HSMaxTextLengthKey = "HSMaxTextLengthKey";
static char *HSTextRestrictKey = "HSTextRestrictKey";
static char *HSPredicateStrKey = "HSPredicateStrKey";

@implementation UITextField (HSRestrict)

- (void)setRestrictType: (HSRestrictType)restrictType
{
    objc_setAssociatedObject(self, HSRestrictTypeKey, @(restrictType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.textRestrict = [HSTextRestrict textRestrictWithRestrictType:restrictType maxTextLength:self.maxTextLength];
}

- (HSRestrictType)restrictType {
    NSNumber *num = objc_getAssociatedObject(self, HSRestrictTypeKey);
    return [num integerValue];
}

- (void)setMaxTextLength:(NSUInteger)maxTextLength {
    objc_setAssociatedObject(self, HSMaxTextLengthKey, @(maxTextLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)maxTextLength {
    NSNumber *num = objc_getAssociatedObject(self, HSMaxTextLengthKey);
    return [num integerValue];
}

/// 设置自定义正则，配合HSRestrictTypeCustom使用
- (void)setPredicateStr:(NSString *)predicateStr {
    objc_setAssociatedObject(self, HSPredicateStrKey, predicateStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)predicateStr {
    return objc_getAssociatedObject(self, HSPredicateStrKey);
}

- (void)setTextRestrict: (HSTextRestrict *)textRestrict
{
    if (self.textRestrict) {
        [self removeTarget: self.text action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    }
    
    if (textRestrict == HSRestrictTypeNone) {
        return;
    }
    
    textRestrict.maxLength = self.maxTextLength;
    textRestrict.predicateStr = self.predicateStr;
    [self addTarget: textRestrict action: @selector(textDidChanged:) forControlEvents: UIControlEventEditingChanged];
    objc_setAssociatedObject(self, HSTextRestrictKey, textRestrict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HSTextRestrict *)textRestrict {
    return objc_getAssociatedObject(self, HSTextRestrictKey);
}

@end
