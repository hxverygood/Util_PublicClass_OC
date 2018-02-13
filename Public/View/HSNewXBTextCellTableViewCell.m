//
//  HSNewXBTextCellTableViewCell.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/7.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSNewXBTextCellTableViewCell.h"

@interface HSNewXBTextCellTableViewCell ()
{
    // 上标签（时间）
    UILabel * topTiplabel;
    // 上文本
    UILabel * topContentLabel;
    
    // 上标签（时间）
    UILabel * alltopTiplabel;
    // 上文本
    UILabel * alltopContentLabel;
    // 下标签（时间）
    UILabel * allbottomTiplabel;
    // 下文本
    UILabel * allbottomContentLabel;
    
    UIView  *  topBgView;
    UIView  *  allbgView;
}




@end;

@implementation HSNewXBTextCellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 第一种样式
        topBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:topBgView];
        
        topContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [topBgView addSubview:topContentLabel];
        topContentLabel.font = [UIFont systemFontOfSize:13];
        topContentLabel.textColor = Black51;
        topContentLabel.textAlignment = NSTextAlignmentLeft;
        
        topTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [topBgView addSubview:topTiplabel];
        topTiplabel.font = [UIFont systemFontOfSize:13];
        topTiplabel.textColor = Gray153;
        topTiplabel.textAlignment = NSTextAlignmentLeft;
       
        // 第二种样式
        allbgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:allbgView];

        alltopContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:alltopContentLabel];
        alltopContentLabel.font = [UIFont systemFontOfSize:13];
        alltopContentLabel.textColor = Black51;
        alltopContentLabel.textAlignment = NSTextAlignmentLeft;
        
        alltopTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:alltopTiplabel];
        alltopTiplabel.font = [UIFont systemFontOfSize:13];
        alltopTiplabel.textColor = Gray153;
        alltopTiplabel.textAlignment = NSTextAlignmentLeft;
        
        allbottomContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:allbottomContentLabel];
        allbottomContentLabel.font = [UIFont systemFontOfSize:13];
        allbottomContentLabel.textColor = Black51;
        allbottomContentLabel.textAlignment = NSTextAlignmentLeft;
        
        allbottomTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:allbottomTiplabel];
        allbottomTiplabel.font = [UIFont systemFontOfSize:13];
        allbottomTiplabel.textColor = Gray153;
        allbottomTiplabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat allbgViewItemHeight = (self.contentView.frame.size.height/2.0f)-10;

    // 第一种样式
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.equalTo(self.contentView);
         make.centerY.equalTo(self.contentView);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [topBgView layoutIfNeeded];

    [topContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(topBgView);
         //         make.right.equalTo(topBgView).offset(-5);
         make.top.equalTo(topBgView);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [topContentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [topContentLabel layoutIfNeeded];
    
    [topTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(topContentLabel.mas_right).offset(10);
         make.right.equalTo(topBgView.mas_right);
         make.top.equalTo(topContentLabel);
         make.height.equalTo(topContentLabel);
     }];
    [topTiplabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [topTiplabel layoutIfNeeded];
    
    
    
    // 第二种样式
    [allbgView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [alltopContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(allbgView);
//         make.right.equalTo(allbgView).offset(-5);
         make.top.equalTo(allbgView).offset(5);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [alltopContentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [alltopContentLabel layoutIfNeeded];
    
    [alltopTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(alltopContentLabel.mas_right).offset(10);
         make.right.equalTo(allbgView.mas_right);
         make.top.equalTo(alltopContentLabel);
//         make.width.equalTo(@(40));
         make.height.equalTo(@(allbgViewItemHeight));
         
     }];
    [alltopTiplabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [alltopTiplabel layoutIfNeeded];
    
    [allbottomContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(alltopContentLabel);
         make.bottom.equalTo(allbgView).offset(-5);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [allbottomContentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [allbottomContentLabel layoutIfNeeded];
    
    [allbottomTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(allbottomContentLabel.mas_right).offset(10);
         make.right.equalTo(alltopTiplabel.mas_right);
         make.top.equalTo(allbottomContentLabel);
         make.height.equalTo(allbottomContentLabel);
     }];
    [allbottomTiplabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [allbottomTiplabel layoutIfNeeded];
}


-(void)setNoticModel:(HSNewHomeNoticModel *)noticModel
{
    _noticModel = noticModel;
    if (_noticModel.showCount == 1)
    {
        topTiplabel.text = _noticModel.topTipStr;
        topContentLabel.text = _noticModel.topContentStr;
        topBgView.hidden = NO;
        allbgView.hidden = YES;
        
    }else if (_noticModel.showCount == 2)
    {

        alltopTiplabel.text = _noticModel.topTipStr;
        alltopContentLabel.text = _noticModel.topContentStr;
        allbottomTiplabel.text = _noticModel.bottomTipStr;
        allbottomContentLabel.text = _noticModel.bottomContentStr;
        topBgView.hidden = YES;
        allbgView.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
