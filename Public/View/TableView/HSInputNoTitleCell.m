//
//  HSInputNoTitleCell.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSInputNoTitleCell.h"

@interface HSInputNoTitleCell ()



@end

@implementation HSInputNoTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textField.text = @"";
}

- (void)setContent:(NSString *)content {
    _textField.text = [NSString isBlankString:content] ? @"" : content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}

@end
