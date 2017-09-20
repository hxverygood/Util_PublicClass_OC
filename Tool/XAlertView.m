//
//  XAlertView.m
//  TR7TreesV3
//
//  Created by hoomsun-finance on 16/5/1.
//  Copyright © 2016年 hoomsun-finance. All rights reserved.
//

#import "XAlertView.h"

#define W CGRectGetWidth([UIScreen mainScreen].bounds)
#define H CGRectGetHeight([UIScreen mainScreen].bounds)

@interface XAlertView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *titileView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *lab1;



@end
@implementation XAlertView
@synthesize lab1;
-(instancetype)init{
    self = [super init];
    if(self){
        

        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
       
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W - 40, 177)];
        if (iphone4x_3_5) {
            
            self.bigView.frame = CGRectMake(0, 0, W-40, 177);
        }else if(iphone6_4_7){
            
             self.bigView.frame = CGRectMake(0, 0, W-115, 177);
           
        }else if (iphone6Plus_5_5){
              self.bigView.frame = CGRectMake(0, 0, W-134, 177);
        }
        
        
        NSLog(@"$%f",self.bigView.frame.size.height/2);
        _bigView.layer.cornerRadius = 10;
        _bigView.layer.masksToBounds = YES;
        _bigView.backgroundColor = [UIColor whiteColor];
        self.bigView.center = CGPointMake(W / 2, H / 2);
    
        
        
        _titileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bigView.frame.size.width, 40)];
        _titileView.backgroundColor = [UIColor colorWithRed:251/255.0f green:91/255.0f blue:91/255.0f alpha:1];
       
  
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  self.bigView.frame.size.width, 20)];
        _titleLable.center = CGPointMake(_titileView.frame.size.width/2, _titileView.frame.size.height/2);
        _titleLable.textColor = [UIColor whiteColor];
        
        _titleLable.text = @"版本更新";
        
        _titleLable.textAlignment = NSTextAlignmentCenter;
        
        [_titileView addSubview:_titleLable];
        lab1
        
        = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  self.bigView.frame.size.width-20, 60)];
    
        lab1.textColor = [UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1];
      
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.numberOfLines=0;
        lab1.font = [UIFont systemFontOfSize:12];
        lab1.center =  CGPointMake((self.bigView.frame.size.width)/2,CGRectGetHeight(self.bigView.frame)/2);
     lab1.text =@"系统检测到有新版本，为了您有更好的体验效果，请您移步App Store进行更新使用。";
        CGRect X = self.bigView.frame;
        NSLog(@"%@",NSStringFromCGRect(X));
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(_bigView.frame), 0.4f)];
        line.center = CGPointMake(CGRectGetWidth(_bigView.bounds)/2, CGRectGetHeight(_bigView.bounds) - 44+2);
        line.backgroundColor =[UIColor lightGrayColor];
      
        
        UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn1 = bu1;
        bu1.bounds = CGRectMake(0, 0, CGRectGetWidth(_bigView.frame), 44);
        bu1.center = CGPointMake(CGRectGetWidth(_bigView.bounds)/2, CGRectGetHeight(_bigView.bounds) - 44 + 24);
        [bu1 setTitleColor:[UIColor colorWithRed:251/255.0f green:91/255.0f  blue:91/255.0f  alpha:1] forState:UIControlStateNormal];
        [bu1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [bu1 setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [bu1 setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]] forState:UIControlStateHighlighted];
        bu1.titleLabel.font = [UIFont systemFontOfSize:15];
        [bu1 setTitle:@"确定" forState:UIControlStateNormal];
        
        [_bigView addSubview:_titileView];
        [_bigView addSubview:lab1];
           [_bigView addSubview:line];
        [_bigView addSubview:bu1];

        [self addSubview:_bigView];
    
        
        
        
 _bigView.transform = CGAffineTransformMakeScale(0, 0);
        
        
        
    }
    
    return self;
}
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)dissmiss {
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
       
    }];
}



- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        _bigView.transform = CGAffineTransformIdentity;
        lab1.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
