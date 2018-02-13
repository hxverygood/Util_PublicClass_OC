//
//  XBTextLoopView.m
//  文字轮播
//
//  Created by 周旭斌 on 2017/4/9.
//  Copyright © 2017年 周旭斌. All rights reserved.
//

#import "XBTextLoopView.h"
#import "HSXBTextCell.h"
#import "HSNoticeModel.h"
#import "HSNewHomeNoticModel.h"
#import "HSNewXBTextCellTableViewCell.h"
#import "HSGCDTimerManager.h"

    static NSString *ID = @"HSNewXBTextCellTableViewCell";
@interface XBTextLoopView () <UITableViewDataSource, UITableViewDelegate>
{
    
}


@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, assign) NSInteger currentRowIndex;
@property (nonatomic, copy) selectTextBlock selectBlock;

@property (nonatomic,strong)NSMutableArray <HSNewHomeNoticModel*>* modelsArray;

@end

@implementation XBTextLoopView

#pragma mark - Setter
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;

    _currentRowIndex = 0;    
    NSInteger logIndex = 0;
    NSMutableArray <HSNoticeModel*>* tesarray;
    NSMutableArray  * finalArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataSource.count; i++)
    {
        logIndex = logIndex + 1;
        if (logIndex == 1)
        {
            tesarray = [[NSMutableArray alloc] init];
        }
        HSNoticeModel * model = [_dataSource objectAtIndex:i];
        [tesarray addObject:model];
        
        if (i == _dataSource.count - 1)
        {
            if ((i+1)%2 != 0)
            {
                [finalArray addObject:tesarray];
            }else
            {
                if (logIndex == 2)
                {
                    logIndex = 0;
                    [finalArray addObject:tesarray];
                }
            }
        }else
        {
            if (logIndex == 2)
            {
                logIndex = 0;
                [finalArray addObject:tesarray];
            }
        }
    }
//    NSLog(@"++++%@",finalArray);
    [self enumdataSourceArray:finalArray];
}


/**
 排序dataSource数组
 @param dataArray 数组
 */
-(void)enumdataSourceArray:(NSMutableArray<NSMutableArray<HSNoticeModel*>*>*)dataArray
{
    
    NSMutableArray <HSNewHomeNoticModel*>* modelsCacheArray = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(NSMutableArray<HSNoticeModel *> * _Nonnull sectionObj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        HSNewHomeNoticModel * newNoticModel = [[HSNewHomeNoticModel alloc] init];
        [sectionObj enumerateObjectsUsingBlock:^(HSNoticeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            NSString *distanceTimeStr = [obj.noticeData distanceTimeBeforeNowWithShowDetail:NO];
            NSString *message = [NSString isBlankString:obj.message] ? @"" : [NSString stringWithFormat:@"・%@", obj.message];
            
            if (idx == 0)
            {
                newNoticModel.topTipStr = [NSString isBlankString:distanceTimeStr] ? @"" : distanceTimeStr;
                newNoticModel.topContentStr = message;

            }else if (idx ==1)
            {
                newNoticModel.bottomTipStr = [NSString isBlankString:distanceTimeStr] ? @"" : distanceTimeStr;
                newNoticModel.bottomContentStr = message;
                newNoticModel.showCount = 2;
            }
        }];
        [modelsCacheArray addObject:newNoticModel];
    }];
    
//    HSNewHomeNoticModel * newNoticModel1 = [[HSNewHomeNoticModel alloc] init];
//    HSNewHomeNoticModel * newNoticModel2 = [[HSNewHomeNoticModel alloc] init];
//
//    newNoticModel1.topTipStr = @"新闻";
//    newNoticModel1.topContentStr = @"下部分测试数据";
//    newNoticModel1.bottomTipStr = @"资讯";
//    newNoticModel1.bottomContentStr = @"下部分测试数据";
//    newNoticModel1.showCount = 2;
//
//    newNoticModel2.topTipStr = @"新闻1";
//    newNoticModel2.topContentStr = @"下部分测试数据1";
//    newNoticModel2.showCount = 1;
    
    
//    [modelsCacheArray addObject:newNoticModel1];
//    [modelsCacheArray addObject:newNoticModel2];
    self.modelsArray = modelsCacheArray;
}

-(void)setModelsArray:(NSMutableArray<HSNewHomeNoticModel *> *)modelsArray
{
    _modelsArray = modelsArray;
    [self.tableView reloadData];
    
    if (_interval != 0.0) {
        [_gcdTimer resumeTimer];
    }
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    
    if (interval == 0.0) {
        return;
    }
    
    //    // 定时器
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timer) userInfo:nil repeats:YES];
    //    _myTimer = timer;
    _gcdTimer = [[HSGCDTimerManager alloc] initWithgcdTimerManagerWithTimerCount:NSIntegerMax withTimeInterval:_interval];
    [_gcdTimer startTimerCompletion:^(NSInteger count)
     {
         [self timer];
     }];
    
}


#pragma mark - 初始化方法
+ (instancetype)textLoopViewWith:(NSArray *)dataSource
                    loopInterval:(NSTimeInterval)timeInterval
                   initWithFrame:(CGRect)frame
                     selectBlock:(selectTextBlock)selectBlock {
    XBTextLoopView *loopView = [[XBTextLoopView alloc] initWithFrame:frame];
    loopView.dataSource = dataSource;
    loopView.selectBlock = selectBlock;
    loopView.interval = timeInterval;
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        // tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = frame.size.height;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.pagingEnabled = YES;
        tableView.bounces = NO;
        tableView.scrollEnabled = NO;
        
        _tableView = tableView;
        //        [self.tableView registerNib:[UINib nibWithNibName:@"HSNewXBTextCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"HSNewXBTextCellTableViewCell"];
        [self addSubview:tableView];
    }
    return self;
}



#pragma mark - tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _interval == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSNewHomeNoticModel * model = [_modelsArray objectAtIndex:indexPath.row];
    HSNewXBTextCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[HSNewXBTextCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.noticModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectBlock) 
    {
        HSNewHomeNoticModel * mdoel = _modelsArray[indexPath.row];
        self.selectBlock(mdoel.topTipStr, indexPath.row);
    }
}


#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 以无动画的形式跳到第1组的第0行
    if (_currentRowIndex == _modelsArray.count) {
        _currentRowIndex = 0;
        [_tableView setContentOffset:CGPointZero];
    }
}

#pragma mark - priviate method

- (void)timer
{
    self.currentRowIndex++;
    [self.tableView setContentOffset:CGPointMake(0, _currentRowIndex * self.frame.size.height) animated:YES];
}

@end
