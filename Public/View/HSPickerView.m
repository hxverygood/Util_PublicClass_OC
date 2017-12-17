//
//  HSPickerView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/7/19.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSPickerView.h"

static CGFloat height = 220.0;

@interface HSPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *dataArrays;

@property (nonatomic, assign) CGRect frameForShow;
@property (nonatomic, assign) CGRect frameForHidden;

@property (nonatomic, assign) NSInteger selectedDataIndex;
@property (nonatomic, assign) NSInteger currentDataIndex;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSString *selectedTitle;

@property (nonatomic, assign) BOOL visable;

@end



@implementation HSPickerView

#pragma mark - Getter / Setter

- (UIView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIView alloc] init];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:_confirmButton];
    
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10.0, 0.0, 60.0, 40.0);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:_cancelButton];
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:0.1];
        [_toolbar addSubview:_line];
    }
    return _toolbar;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        
//        _pickerView.backgroundColor = [UIColor yellowColor];
    }
    return _pickerView;
}

- (BOOL)isVisable {
    return _visable;
}

- (void)setData:(NSArray<NSArray<NSString *> *> *)dataArray {
    _dataArrays = dataArray;
    [self.pickerView reloadAllComponents];
}



#pragma mark - Initailizer

- (instancetype)initWithDataArrays:(NSArray<NSArray *> *)dataArrays {
    HSPickerView *pickerView = [[HSPickerView alloc] init];
    pickerView.dataArrays = dataArrays;
    return pickerView;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        [self addSubview:self.pickerView];
        [self addSubview:self.toolbar];
        
        //        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect superViewframe = self.superview.frame;
    _frameForHidden = CGRectMake(0.0, CGRectGetHeight(superViewframe), CGRectGetWidth(superViewframe), height);
    _frameForShow = CGRectMake(0.0, CGRectGetHeight(superViewframe)-height, CGRectGetWidth(superViewframe), height);
    self.frame = _frameForHidden;

    _pickerView.frame = CGRectMake(0.0, 40.0, self.frame.size.width, self.frame.size.height-40.0);
    _toolbar.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 30.0);
    _confirmButton.frame = CGRectMake(_toolbar.frame.size.width-10.0-60.0, 0.0, 60.0, 40.0);
    _line.frame = CGRectMake(0.0, CGRectGetMaxY(_cancelButton.frame), CGRectGetWidth(self.frame), 1.0);
}


#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_dataArrays.count == 1) {
        return _dataArrays[0].count;
    } else {
        return _dataArrays[_selectedDataIndex].count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_selectedDataIndex < _dataArrays.count ) {
        NSArray *data = _dataArrays[_selectedDataIndex];
        return data[row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *title;
    if (_selectedDataIndex < _dataArrays.count) {
        NSArray *data = _dataArrays[_selectedDataIndex];
        title = data[row];
    }
    _selectedRow = row;
    _selectedTitle = title;
}



#pragma mark - Action

- (void)cancelButtonPressed:(id)sender {
    [self dismiss];
}

- (void)confirmButtonPressed:(id)sender {
    if (self.selectRowBlock) {
        // 说明没有进行滑动选择，默认选第1个
        if (_selectedDataIndex < _dataArrays.count) {
            NSArray *data = _dataArrays[_selectedDataIndex];
            _selectedTitle = data[_selectedRow];
        }
        
        /// 返回的_selectTitle可能为nil，使用时要最判断
        self.selectRowBlock(_currentDataIndex, _selectedRow, [_selectedTitle copy]);
    }
    [self dismiss];
}


#pragma mark - Func

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    
    [self.confirmButton setTitleColor:buttonColor forState:UIControlStateNormal]; 
    [self.cancelButton setTitleColor:buttonColor forState:UIControlStateNormal];
}


#pragma - Animation

- (void)showWithDataArrayIndex:(NSInteger)selectedDataIndex {
    _selectedDataIndex = selectedDataIndex;
    
    [self show];
}

- (void)show {
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _selectedRow = 0;
    _selectedTitle = @"";
    [self.pickerView reloadAllComponents];
//    if (_selectedDataIndex != _currentDataIndex) {
//        [self.pickerView reloadAllComponents];
//        [self.pickerView selectRow:0 inComponent:0 animated:YES];
//    }
    
    UIView *currentView = self.superview;
    if (currentView) {
        CGRect f = currentView.frame;
        self.frameForHidden = CGRectMake(0.0, f.size.height, _frameForShow.size.width, _frameForShow.size.height);
        self.frame = self.frameForHidden;
//        self.hidden = NO;
        
        _bgView = [[UIView alloc] initWithFrame:currentView.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
        [currentView insertSubview:_bgView belowSubview:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = _frameForShow;
        self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    } completion:^(BOOL complete) {
        _currentDataIndex = _selectedDataIndex;
        _visable = YES;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.frameForHidden;
        self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    } completion:^(BOOL complete){
        [self.bgView removeFromSuperview];
        _visable = NO;
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
    }];
}

@end
