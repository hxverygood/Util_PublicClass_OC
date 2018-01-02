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
    // 上标签
    UILabel * topTiplabel;
    // 上文本
    UILabel * topContentLabel;
    
    // 上标签
    UILabel * alltopTiplabel;
    // 上文本
    UILabel * alltopContentLabel;
    // 下标签
    UILabel * allbottomTiplabe;
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

        
        topTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [topBgView addSubview:topTiplabel];
        topTiplabel.font = [UIFont systemFontOfSize:13];
        topTiplabel.textColor = [UIColor colorWithHexString:@"f45d67"];
        topTiplabel.backgroundColor  = [UIColor colorWithHexString:@"fdf8f5"];
        topTiplabel.textAlignment = NSTextAlignmentCenter;
        
        
        
        
        topContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [topBgView addSubview:topContentLabel];
        topContentLabel.font = [UIFont systemFontOfSize:15];
        topContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        topContentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        
        // 第二种样式
        allbgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:allbgView];

        alltopTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:alltopTiplabel];
        alltopTiplabel.font = [UIFont systemFontOfSize:13];
        alltopTiplabel.textColor = [UIColor colorWithHexString:@"f45d67"];
        alltopTiplabel.textAlignment = NSTextAlignmentCenter;
        alltopTiplabel.backgroundColor  = [UIColor colorWithHexString:@"fdf8f5"];


        alltopContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:alltopContentLabel];
        alltopContentLabel.font = [UIFont systemFontOfSize:15];
        alltopContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        alltopContentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        allbottomTiplabe = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:allbottomTiplabe];
        allbottomTiplabe.font = [UIFont systemFontOfSize:13];
        allbottomTiplabe.textColor = [UIColor colorWithHexString:@"f45d67"];
        allbottomTiplabe.textAlignment = NSTextAlignmentCenter;
        allbottomTiplabe.backgroundColor  = [UIColor colorWithHexString:@"fdf8f5"];

        
        allbottomContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [allbgView addSubview:allbottomContentLabel];
        allbottomContentLabel.font = [UIFont systemFontOfSize:15];
        allbottomContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        allbottomContentLabel.textAlignment = NSTextAlignmentLeft;

    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat allbgViewItemHeight = (self.contentView.frame.size.height/2.0f)-15;

         // 第一种样式
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.right.equalTo(self.contentView);
         make.centerY.equalTo(self.contentView);
         make.height.equalTo(@(allbgViewItemHeight));
     }];

    [topTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(topBgView).offset(5);
         make.width.equalTo(@(40));
         make.centerY.equalTo(topBgView);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [topTiplabel layoutIfNeeded];
    
    
    [topContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(topBgView).offset(-5);
         make.left.equalTo(topTiplabel.mas_right).offset(5);
         make.top.equalTo(topTiplabel);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [topContentLabel layoutIfNeeded];
    
    // 第二种样式
    
    
    [allbgView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
     }];
    
    
    [alltopTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(allbgView).offset(5);
         make.top.equalTo(allbgView).offset(10);
         make.width.equalTo(@(40));
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [alltopTiplabel layoutIfNeeded];
    
    [alltopContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(allbgView).offset(-5);
         make.left.equalTo(alltopTiplabel.mas_right).offset(5);
         make.top.equalTo(alltopTiplabel);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [alltopContentLabel layoutIfNeeded];
    
    [allbottomTiplabe mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(allbgView).offset(5);
         make.top.equalTo(alltopTiplabel.mas_bottom).offset(10);
         make.width.equalTo(@(40));
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [allbottomTiplabe layoutIfNeeded];
    
    [allbottomContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.right.equalTo(self.contentView).offset(-5);
         make.left.equalTo(allbottomTiplabe.mas_right).offset(5);
         make.top.equalTo(allbottomTiplabe);
         make.height.equalTo(@(allbgViewItemHeight));
     }];
    [allbottomContentLabel layoutIfNeeded];
    
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
        allbottomTiplabe.text = _noticModel.bottomTipStr;
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
