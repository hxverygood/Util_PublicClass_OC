//
//  HSMutiColPickerView.h
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/12.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSMutiColPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *dataArrays;
@property (nonatomic, assign, readonly) BOOL isVisable;

@property (nonatomic, copy) void (^selectRowBlock)(NSInteger component, NSInteger row);
@property (nonatomic, copy) void (^confirmButtonAction)(NSInteger componentCount, NSArray *rowArray);
@property (nonatomic, copy) void (^cancelButtonAction) (void);


- (instancetype)initWithDataArrays:(NSArray<NSArray *> *)dataArrays;

- (void)show;
- (void)dismiss;

@end
