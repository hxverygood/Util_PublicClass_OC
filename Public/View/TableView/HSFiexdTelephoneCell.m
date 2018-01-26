//
//  HSFiexdTelephoneCell.m
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/1/22.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "HSFiexdTelephoneCell.h"

@interface HSFiexdTelephoneCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HSFiexdTelephoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.text = @"";
    _areaNumTextField.text = @"";
    _telephoneTextField.text = @"";
    _extensionNumTextField.text = @"";
    
    _areaNumTextField.maxTextLength = 4;
    _areaNumTextField.restrictType = HSRestrictTypeOnlyNumber;
    _areaNumTextField.keyboardType = UIKeyboardTypePhonePad;
    
    _telephoneTextField.maxTextLength = 8;
    _telephoneTextField.restrictType = HSRestrictTypeOnlyNumber;
    _telephoneTextField.keyboardType = UIKeyboardTypePhonePad;
    
    _extensionNumTextField.maxTextLength = 6;
    _extensionNumTextField.restrictType = HSRestrictTypeOnlyNumber;
    _extensionNumTextField.keyboardType = UIKeyboardTypePhonePad;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = [NSString isBlankString:title] ? @"" : title;
}

- (void)setAreaNum:(NSString *)areaNum {
    self.areaNumTextField.text = [NSString isBlankString:areaNum] ? @"" : areaNum;
}

- (void)setTelephone:(NSString *)telephone {
    self.telephoneTextField.text = [NSString isBlankString:telephone] ? @"" : telephone;
}

- (void)setExtensionNum:(NSString *)extensionNum {
    self.extensionNumTextField.text = [NSString isBlankString:extensionNum] ? @"" : extensionNum;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
