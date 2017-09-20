//
//  HSInsetsTextField.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/9/7.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSInsetsTextField : UITextField

- (CGRect)textRectForBounds:(CGRect)bounds;
- (CGRect)editingRectForBounds:(CGRect)bounds;

@end
