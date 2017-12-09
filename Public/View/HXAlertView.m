//
//  HXAlertView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/6.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HXAlertView.h"
#import "JCAlertView.h"

@interface HXAlertView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) JCAlertView *alertView;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *content;

@end



@implementation HXAlertView

#pragma mark - Initializer

+ (instancetype)alertViewWithImageName:(NSString *)imageName
                               content:(NSString *)content {
    return [[HXAlertView alloc] initWithImageName:imageName content:content];
}

- (instancetype)initWithImageName:(NSString *)imageName
                          content:(NSString *)content {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HXAlertView" owner:nil options:nil] lastObject];
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = YES;
        
        
        self.imageName = imageName;
        self.content = content;
        
        self.imageView.image = [UIImage imageNamed:imageName];
        self.contentLabel.text = [NSString isBlankString:content] ? @"" : content;
    }
    return self;
}



#pragma mark - Func

- (void)show {
    __weak typeof(self) weakSelf = self;
    _alertView = [[JCAlertView alloc] initWithCustomView:weakSelf dismissWhenTouchedBackground:NO];
    [_alertView show];
}

- (void)dismissWithCompletion:(void (^)(void))completion {
    [_alertView dismissWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}


@end
