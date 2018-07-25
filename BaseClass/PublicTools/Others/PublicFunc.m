//
//  HSPublicFunc.m
//  HSRongyiBao
//
//  Created by hoomsun on 2016/12/29.
//  Copyright © 2016年 hoomsun. All rights reserved.
//

#import "PublicFunc.h"

@interface PublicFunc ()

@end

@implementation PublicFunc

#pragma mark 拨打电话

+ (void)callWithPhoneNumber:(NSString *)phone {
    NSString *phoneUrlStr = [NSString stringWithFormat:@"tel://%@", phone];
    NSURL *phoneUrl = [NSURL URLWithString:phoneUrlStr];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else {
        [HUD showInfoWithStatus:@"该设备无法拨打电话"];
    }
}

@end
