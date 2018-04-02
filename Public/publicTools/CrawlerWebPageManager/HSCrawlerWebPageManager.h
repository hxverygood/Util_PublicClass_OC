//
//  HSCrawlerWebPageManager.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/3/28.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSCrawlerWebPageModel;

@interface HSCrawlerWebPageManager : NSObject

+ (HSCrawlerWebPageManager *_Nullable)shared;

/// 保存webpage打开时的model
- (void)saveWebPageModelWithViewControllerName:(NSString *_Nullable)vcname
                                         phone:(NSString *_Nullable)phone;

/// 获取保存的model
- (nullable HSCrawlerWebPageModel *)savedWebPageModel;

/// 删除保存的文件
- (void)removeSavedWebPageModel;

@end
