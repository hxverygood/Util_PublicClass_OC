//
//  HSTextAttributedView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/20.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HSTextAttributedViewBlock) (void);

@interface HSTextAttributedView : UIView

@property(nonatomic,copy)HSTextAttributedViewBlock block;

// 前缀字符
@property(nonatomic,copy)NSString * prefixStr;

// 可点击的字符
@property(nonatomic,copy)NSString * selectedStr;

-(void)creatTextView:(HSTextAttributedViewBlock)block;


@end
