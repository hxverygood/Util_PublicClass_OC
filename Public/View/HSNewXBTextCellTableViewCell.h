//
//  HSNewXBTextCellTableViewCell.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/7.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSNewHomeNoticModel.h"

@interface HSNewXBTextCellTableViewCell : UITableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HSNewHomeNoticModel*)model;
@end
