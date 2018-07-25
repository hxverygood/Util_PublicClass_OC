//
//  CustomCalloutView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/19.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "CustomCalloutView.h"

@interface CustomCalloutView ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end



@implementation CustomCalloutView

+ (instancetype)view {
    return [[CustomCalloutView alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomCalloutView" owner:self options:nil] objectAtIndex:0];
        self.contentLabel.text = @"";
    }
    return self;
}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//
//
//}



#pragma mark -

- (void)setContent:(NSString *)content {
    if ([NSString isBlankString:content]) {
        _contentLabel.text = @"";
    }
    else {
        _contentLabel.text = content;

        CGRect frame = self.frame;
        CGRect labelBounds = _contentLabel.bounds;

        CGSize labelSize = [_contentLabel sizeThatFits:CGSizeMake(80.0, CGFLOAT_MAX)];
        if (labelSize.height > 20.0) {
            labelSize = [_contentLabel sizeThatFits:CGSizeMake(200.0, CGFLOAT_MAX)];
            labelBounds.size.width = labelSize.width;
            labelBounds.size.height = labelSize.height;
            frame.size.width = labelSize.width + 10.0 * 2;
            frame.size.height = labelSize.height + 5.0 * 2;
            _contentLabel.bounds = labelBounds;
            self.frame = frame;
        }

//        BOOL needMultiLine = [content textNeedMoreLineCountWithFont:[UIFont systemFontOfSize:13.0] width:80.0 height:20.0];
//        // 需要多行显示
//        if (needMultiLine) {
//            needMultiLine = [content textNeedMoreLineCountWithFont:[UIFont systemFontOfSize:13.0] width:200.0 height:20.0];
//
//            // label宽度为200时仍需要多行显示
//            if (needMultiLine) {
//                CGFloat labelHeight = [content textHeightWithFont:[UIFont systemFontOfSize:13.0] width:200.0];
//                labelBounds.size.height = labelHeight;
//                frame.size.height = labelHeight + 5.0 * 2;
//            }
//            else {
//                CGFloat labelWidth = [content textWidthWithFont:[UIFont systemFontOfSize:13.0] height:20.0];
//                labelBounds.size.width = labelWidth;
//                frame.size.height = labelWidth + 10.0 * 2;
//            }
//
//            _contentLabel.bounds = labelBounds;
//            self.frame = frame;
//        }

    }
}

@end
