//
//  HSInputCell.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSInputCell.h"

@interface HSInputCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HSInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.text = @"";
    _textField.text = @"";
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
}

- (void)setContent:(NSString *)content {
    self.textField.text = [NSString isBlankString:content] ? @"" : content;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
