//
//  HSBaseTableView.h
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/1/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

typedef void (^Handler)(BOOL needRefresh);

@interface HSBaseTableView : UITableView

@property (nonatomic, copy) NSString *placeholderContent;


@end
