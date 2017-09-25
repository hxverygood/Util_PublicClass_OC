//
//  HSPickerView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPickerView : UIView

@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, copy) void (^selectRowBlock)(NSInteger selectedDataArrayIndex, NSInteger row, NSString *title);

@property (nonatomic, assign, readonly) BOOL isVisable;

- (instancetype)initWithDataArrays:(NSArray<NSArray *> *)dataArrays;

- (void)show;
- (void)showWithDataArrayIndex:(NSInteger)selectedDataIndex;
- (void)dismiss;
- (void)setData:(NSArray<NSArray<NSString *> *> *)dataArray;

@end
