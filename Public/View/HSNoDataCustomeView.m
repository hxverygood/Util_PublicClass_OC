//
//  HSNoDataCustomeView.m
//  HSInvestorAPP
//
//  Created by hoomsun on 2017/3/20.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSNoDataCustomeView.h"

float const custome_width_view  = 135.0;
float const custome_height_view = 107.0;

@interface HSNoDataCustomeView ()

@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataLabel;
//@property (nonatomic, copy) ReloadButtonClickBlock reloadButtonClickBlock;

@property (nonatomic, assign) BOOL isUserContent;
@property (nonatomic, copy) NSString *content;

@end



@implementation HSNoDataCustomeView

- (instancetype)initWithFrame:(CGRect)frame
                      content:(NSString *)content {
    self = [super initWithFrame:frame];
    if (self) {
        self.content = content;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageViewNoDataRect = CGRectZero;
    imageViewNoDataRect.size = CGSizeMake(custome_width_view, custome_height_view);
    imageViewNoDataRect.origin.x = (self.frame.size.width - custome_width_view)/2.0;
    imageViewNoDataRect.origin.y = (self.frame.size.height - custome_height_view)/2.0-55.0;
    self.noDataImageView.frame = imageViewNoDataRect;
//    self.noDataImageView.backgroundColor = [UIColor grayColor];
    
    if (_content.length > 0) {
        CGRect noDataLabelRect = CGRectZero;
        noDataLabelRect.size = CGSizeMake(custome_width_view, 21.0);
        noDataLabelRect.origin.x = imageViewNoDataRect.origin.x;
        noDataLabelRect.origin.y = imageViewNoDataRect.origin.y+imageViewNoDataRect.size.height+30.0;
        self.noDataLabel.frame = noDataLabelRect;
    }
//    self.noDataLabel.backgroundColor = Red;
}



#pragma mark - Getter

- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"暂无数据"]] ;
        _noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![_noDataImageView superview]) {
            [self addSubview:_noDataImageView] ;
        }
    }
    return _noDataImageView;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        if (self.content && _isUserContent) {
            _noDataLabel.text = _content;
        } else {
            _noDataLabel.text =  @"暂无数据";
        }
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        _noDataLabel.font = [UIFont systemFontOfSize:14.0];
        if (![_noDataLabel superview]) {
            [self addSubview:_noDataLabel] ;
        }
    }
    return _noDataLabel;
}

@end
