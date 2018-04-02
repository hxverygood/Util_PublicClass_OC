//
//  HSCrawlerWebPageModel.h
//  HSRongyiBao
//
//  Created by 韩啸 on 2018/3/28.
//  Copyright © 2018年 hoomsun. All rights reserved.
//

#import "JSONModel.h"

@interface HSCrawlerWebPageModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *viewControllerName;
@property (nonatomic, copy) NSString<Optional> *startTime;
@property (nonatomic, copy) NSString<Optional> *phone;

@end
