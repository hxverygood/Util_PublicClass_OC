//
//  HSNoDataView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/23.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadButtonClickBlock)() ;

@interface HSNoDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock;

- (void)showInView:(UIView *)viewWillShow ;
- (void)dismiss ;

@end
