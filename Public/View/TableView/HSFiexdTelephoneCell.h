//
//  HSFiexdTelephoneCell.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/1/22.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFiexdTelephoneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HSTextField *areaNumTextField;
@property (weak, nonatomic) IBOutlet HSTextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet HSTextField *extensionNumTextField;

- (void)setTitle:(NSString *)title;
- (void)setAreaNum:(NSString *)areaNum;
- (void)setTelephone:(NSString *)telephone;
- (void)setExtensionNum:(NSString *)extensionNum;

@end
