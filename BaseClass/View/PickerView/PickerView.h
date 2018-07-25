//
//  PickerView
//
//  Created by hans on 2017/7/19.
//  Copyright © 2017年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, copy) void (^selectRowBlock)(NSInteger selectedDataArrayIndex, NSInteger row, NSString *title);

@property (nonatomic, assign, readonly) BOOL isVisable;

- (instancetype)initWithDataArrays:(NSArray<NSArray *> *)dataArrays;

- (void)show;
- (void)showWithDataArrayIndex:(NSInteger)selectedDataIndex;
- (void)dismiss;
- (void)setData:(NSArray<NSArray<NSString *> *> *)dataArray;

@end
