//
//  BasePopView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/9/6.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopViewStyle) {
    PopViewStyleNone,
    PopViewStyleCenter,
    PopViewStyleFromBottom,
    PopViewStyleCustom
};



@interface BasePopView : UIView

@property (nonatomic, assign) PopViewStyle popViewStyle;


/**
 popViewStyle为PopViewStyleCustom时需设置隐藏和显示的frame
 */
@property (nonatomic, assign) CGRect frameForShow;
@property (nonatomic, assign) CGRect frameForHidden;

@property (nonatomic, assign) BOOL canDismissWhenTapBackground;

- (void)show;
- (void)dismissWithCompletion:(void (^)(void))completion;

@end
