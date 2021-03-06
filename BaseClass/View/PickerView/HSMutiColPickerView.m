//
//  HSMutiColPickerView.m
//  HSRongyiBao
//
//  Created by hoomsun on 2017/12/12.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSMutiColPickerView.h"

static CGFloat height = 220.0;

@interface HSMutiColPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) CGRect frameForShow;
@property (nonatomic, assign) CGRect frameForHidden;

@property (nonatomic, assign) NSInteger selectedDataIndex;
@property (nonatomic, assign) NSInteger currentDataIndex;

@property (nonatomic, assign) NSInteger selectedComponent;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSString *selectedTitle;

@property (nonatomic, strong) NSMutableArray *selectedRowArray;

@property (nonatomic, assign) BOOL visable;

@end

@implementation HSMutiColPickerView

#pragma mark - Getter / Setter

- (UIView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIView alloc] init];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_toolbar addSubview:_confirmButton];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10.0, 0.0, 60.0, 40.0);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
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

- (NSMutableArray *)selectedRowArray {
    if (!_selectedRowArray) {
        _selectedRowArray = [NSMutableArray array];
        for (int i = 0; i < _dataArrays.count; i++) {
            [_selectedRowArray addObject:@(0)];
        }
    }
    return _selectedRowArray;
}


- (void)setDataArrays:(NSArray<NSArray<NSString *> *> *)dataArrays {
    _dataArrays = dataArrays;
    [self.pickerView reloadAllComponents];
}



#pragma mark - Initailizer

- (instancetype)initWithDataArrays:(NSArray<NSArray *> *)dataArrays {
    HSMutiColPickerView *pickerView = [[HSMutiColPickerView alloc] init];
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
    return _dataArrays.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArrays[component].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *titleArray = _dataArrays[component];
    return titleArray[row];
}

// 自定义每个pickerView的label
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = [UILabel new];
    //    pickerLabel.frame = CGRectMake(0.0, 0.0, kScreenWidth/3.0, 60.0);
    pickerLabel.numberOfLines = 2;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    [pickerLabel setFont:[UIFont systemFontOfSize:15.0]];
    pickerLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component >= self.selectedRowArray.count) {
        return;
    }
    
    [self.selectedRowArray replaceObjectAtIndex:component withObject:@(row)];
    for (NSInteger i = component+1; i < _dataArrays.count; i++) {
        [self.selectedRowArray replaceObjectAtIndex:i withObject:@(0)];
    }
    
    if (self.selectRowBlock) {
        self.selectRowBlock(component, row);
    }
}



#pragma mark - Action

- (void)cancelButtonPressed:(id)sender {
    [self dismiss];
    if (self.cancelButtonAction)
    {
        self.cancelButtonAction();
    }
}

- (void)confirmButtonPressed:(id)sender {
    if (self.confirmButtonAction) {
        self.confirmButtonAction(_dataArrays.count, [self.selectedRowArray copy]);
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

- (void)show {
    _selectedRowArray = nil;
    
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
        self.frame = self.frameForShow;
        self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    } completion:^(BOOL complete) {
        self.currentDataIndex = self.selectedDataIndex;
        self.visable = YES;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.frameForHidden;
        self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0];
    } completion:^(BOOL complete){
        [self.bgView removeFromSuperview];
        self.visable = NO;
    }];
}

@end
