//
//  HSBaseTabedSlideViewController.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/29.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseViewController.h"
#import "DLTabedSlideView.h"

@protocol HSBaseTabedSlideProtocol <NSObject>

- (UIViewController *)tabedSlideViewController:(UIViewController *)controller index:(NSInteger)index;

@end

@interface HSBaseTabedSlideViewController : HSBaseViewController

@property (weak, nonatomic) IBOutlet DLTabedSlideView *tabedSlideView;

@property (nonatomic, weak) id<HSBaseTabedSlideProtocol> tabedDelegate;


#pragma mark - Initializer

- (instancetype)initWithTitles:(NSArray *)titles
                    titleColor:(UIColor *)titleColor;

@end
