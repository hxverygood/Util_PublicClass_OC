//
//  NSString+Util.h
//  Baili
//
//  Created by xabaili on 16/3/1.
//  Copyright © 2016年 Baili. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface NSString (Util)

- (NSString *)URLEncodedString;

// 恒丰银行转码信息
- (NSString *)URLEncoding;

- (NSString *)URLDecoding;

@end
