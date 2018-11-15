//
//  HSTextAttributedView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/20.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSTextAttributedView.h"

@interface HSTextAttributedView ()<UITextViewDelegate>

@end

@implementation HSTextAttributedView
{
    UITextView * textView;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)creatTextView:(HSTextAttributedViewBlock)block
{
    self.block = block;
    [self creatAttributedView];
    
}

-(void)creatAttributedView
{
    self.backgroundColor = [UIColor clearColor];
    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges .mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
     }];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = [NSString stringWithFormat:@"%@,%@",self.prefixStr,self.selectedStr];
    textView.backgroundColor = [UIColor clearColor];
    
    [self protocolTextLabel:textView.text];
    
}


// 设置可点击属性
- (void)protocolTextLabel:(NSString*)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"sendMessage://"
                             range:[[attributedString string] rangeOfString:@"全部提现"]];

    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attributedString.length)];
    textView.attributedText = attributedString;
    textView.linkTextAttributes = @{NSForegroundColorAttributeName: HEXCOLOR(0x7C91DB),
                                    NSUnderlineColorAttributeName: HEXCOLOR(0x9b9b9b),
                                    NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    textView.delegate = self;
    textView.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    textView.scrollEnabled = NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"sendMessage"])
    {
        NSLog(@"全部提现");
        // 弹出自定义的AlertController
        
        self.block();
//        [ConfirmAlertController actionSheetWithTitle:@"提示" message:@"您将接受12590****830来电的语音验证码，请注意接听" confirmTitle:@"确认接听" cancelTitle:nil actionStyle:UIAlertActionStyleDefault viewController:[kTools getCurrentVC] actionBlock:^(UIAlertAction * _Nullable confirmAction, UIAlertAction * _Nullable cancelAction)
//         {
//             if (confirmAction)
//             {
//                 if (self.managerBlock)
//                 {
//                     self.managerBlock(1);
//                 }
//             }
//         }];
        
        return NO;
    }
    return YES;
}



@end
