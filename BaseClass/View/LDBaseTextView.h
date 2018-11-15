//
//  LDBaseTextView.h
//  LDDriverSide
//
//  Created by 闪电狗 on 2018/9/29.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDBaseTextView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(instancetype)view;

@end

NS_ASSUME_NONNULL_END
