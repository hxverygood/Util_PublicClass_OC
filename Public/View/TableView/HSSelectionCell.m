//
//  HSSelectionCell.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/13.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSSelectionCell.h"

@interface HSSelectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation HSSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.text = @"";
    _textField.text = @"";
    _textField.enabled = NO;
    [_button setTitle:@"" forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
}

- (IBAction)buttonPressed:(id)sender {
    if (self.buttonAction) {
        self.buttonAction();
    }
}

- (void)setContent:(NSString *)content {
    self.textField.text = [NSString isBlankString:content] ? @"" : content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
