//
//  CountDownButton.h
//  test_utils
//
//  Created by 韩啸 on 2018/3/9.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseCaptchaButton.h"


//@protocol CoundDownButton;

@interface CountDownButton : HSBaseCaptchaButton

//@property (nonatomic, weak) id<CoundDownButton> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  buttonColor:(UIColor *)buttonColor;

@end

//
//@protocol CoundDownButton
//
//- (void)countDownButtonPressed:(CountDownButton *)button;
//
//@end

