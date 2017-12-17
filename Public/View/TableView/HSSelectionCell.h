//
//  HSSelectionCell.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSSelectionCell : UITableViewCell

@property (nonatomic, copy) void (^buttonAction)(void);

// 输入框
@property (weak, nonatomic) IBOutlet HSTextField *textField;

- (void)setTitle:(NSString *)title;
- (void)setContent:(NSString *)content;

@end
