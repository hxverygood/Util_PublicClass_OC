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
    // 下标签
    UILabel * bottomTiplabe;
    // 下文本
    UILabel * bottomContentLabel;
}


/**
  数据模型
 */
@property(nonatomic,strong)HSNewHomeNoticModel * noticModel;

@end;

@implementation HSNewXBTextCellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(HSNewHomeNoticModel*)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _noticModel = model;
        if (_noticModel.showCount == 1)
        {
            topTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:topTiplabel];
            topTiplabel.font = [UIFont systemFontOfSize:15];
            topTiplabel.textColor = [UIColor colorWithHexString:@"f45d67"];
            topTiplabel.textAlignment = NSTextAlignmentLeft;
            topTiplabel.text = _noticModel.topTipStr;
            
            topContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:topContentLabel];
            topContentLabel.font = [UIFont systemFontOfSize:15];
            topContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
            topContentLabel.textAlignment = NSTextAlignmentLeft;
            topContentLabel.text = _noticModel.topContentStr;

            
            
        }else if (_noticModel.showCount == 2)
        {
            topTiplabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:topTiplabel];
            topTiplabel.font = [UIFont systemFontOfSize:15];
            topTiplabel.textColor = [UIColor colorWithHexString:@"f45d67"];
            topTiplabel.textAlignment = NSTextAlignmentLeft;
            topTiplabel.text = _noticModel.topTipStr;

            
            
            topContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:topContentLabel];
            topContentLabel.font = [UIFont systemFontOfSize:15];
            topContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
            topContentLabel.textAlignment = NSTextAlignmentLeft;
            topContentLabel.text = _noticModel.topContentStr;

            
            
            bottomTiplabe = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:bottomTiplabe];
            bottomTiplabe.font = [UIFont systemFontOfSize:15];
            bottomTiplabe.textColor = [UIColor colorWithHexString:@"f45d67"];
            bottomTiplabe.textAlignment = NSTextAlignmentLeft;
            bottomTiplabe.text = _noticModel.bottomTipStr;

            
            
            bottomContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.contentView addSubview:bottomContentLabel];
            bottomContentLabel.font = [UIFont systemFontOfSize:15];
            bottomContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
            bottomContentLabel.textAlignment = NSTextAlignmentLeft;
            bottomContentLabel.text = _noticModel.bottomContentStr;
            
        }
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat itemHeight = self.frame.size.height/2.0f;
    if (_noticModel.showCount == 1)
    {

        [topTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(5);
             make.width.equalTo(@(50));
             make.centerY.equalTo(self.contentView);
             make.height.equalTo(@(itemHeight));
         }];
        [topTiplabel layoutIfNeeded];

        

        [topContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-5);
             make.left.equalTo(topTiplabel.mas_right).offset(5);
             make.top.equalTo(topTiplabel);
             make.height.equalTo(@(itemHeight));
         }];
        [topContentLabel layoutIfNeeded];
;
        
        
        
    }else if (_noticModel.showCount == 2)
    {

        [topTiplabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(5);
             make.top.equalTo(self.contentView);
             make.width.equalTo(@(50));
             make.height.equalTo(@(itemHeight));
         }];
        [topTiplabel layoutIfNeeded];

        
        
        

        [topContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-5);
             make.left.equalTo(topTiplabel.mas_right).offset(5);
             make.top.equalTo(topTiplabel);
             make.height.equalTo(@(itemHeight));
         }];
        [topContentLabel layoutIfNeeded];

        
        
        

        [bottomTiplabe mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView).offset(5);
             make.top.equalTo(topTiplabel.mas_bottom);
             make.width.equalTo(@(50));
             make.height.equalTo(@(itemHeight));
         }];
        [bottomTiplabe layoutIfNeeded];

        
        

        [bottomContentLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.contentView).offset(-5);
             make.left.equalTo(bottomTiplabe.mas_right).offset(5);
             make.top.equalTo(bottomTiplabe);
             make.height.equalTo(@(itemHeight));
         }];
        [bottomContentLabel layoutIfNeeded];

        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
