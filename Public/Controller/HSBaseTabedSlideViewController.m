//
//  HSBaseTabedSlideViewController.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/8/29.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseTabedSlideViewController.h"
//#import "DLTabedSlideView.h"


@interface HSBaseTabedSlideViewController () <DLTabedSlideViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIColor *titleColor;

@end

@implementation HSBaseTabedSlideViewController

#pragma mark - Getter / Setter

//- (void)setTabedBaseViewController:(UIViewController *)tabedBaseViewController {
//    _tabedBaseViewController = tabedBaseViewController;
//    self.tabedSlideView.baseViewController = tabedBaseViewController;
//}


#pragma mark - Initializer

- (instancetype)initWithTitles:(NSArray *)titles
                    titleColor:(UIColor *)titleColor {
    self = [super init];
    if (self) {
        self.titles = titles;
        self.titleColor = titleColor;
    }
    return self;
}


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabedSlideView];
}

#pragma mark - TabedSlideView
// DLTabedSlideView
- (void)setupTabedSlideView {
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.baseViewController = self;
    
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = self.titleColor;
    self.tabedSlideView.tabbarTrackColor = self.titleColor;
    self.tabedSlideView.tabbarBottomSpacing = 0.0;
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *title in self.titles) {
        DLTabedbarItem *item = [DLTabedbarItem itemWithTitle:title image:[UIImage imageNamed:@""] selectedImage:[UIImage imageNamed:@""]];
        [items addObject:item];
    }

    self.tabedSlideView.tabbarItems = [items copy];
    self.tabedSlideView.tabbarHeight = 100.0f;
    [self.tabedSlideView buildTabbar];
//    self.tabedSlideView.selectedIndex = 0;
}

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return self.titles.count;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    UIViewController *vc = nil;
    
    if (self.tabedDelegate && [self.tabedDelegate respondsToSelector:@selector(tabedSlideViewController:index:)]) {
        vc = [self.tabedDelegate tabedSlideViewController:self index:index];
    }
    return vc;
}

//- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index{
//    
//}



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
