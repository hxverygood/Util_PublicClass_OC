//
//  MapNaviInfoView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/8/25.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapNaviInfoView.h"

@interface MapNaviInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *segmentRemainDistanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentRoadNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextRoadNameLabel;

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) CGRect frameForShow;
@property (nonatomic, assign) CGRect frameForHidden;

@end



@implementation MapNaviInfoView

+ (instancetype)view {
    MapNaviInfoView *view = [[[NSBundle mainBundle] loadNibNamed:@"MapNaviInfoView" owner:self options:nil] objectAtIndex:0];
    [view initView];

    CGRect frame = view.frame;
    frame.size.width = kScreenWidth;
    view.frame = frame;

    CGRect frameForHidden = frame;
    frameForHidden.origin.y -= CGRectGetHeight(frame);
    view.frameForHidden = frameForHidden;

    CGRect frameForShow = frame;
    frameForShow.origin.y = 0.0;
    view.frameForShow = frameForShow;

    return view;
//    return [[LDWithdrawConfirmView alloc] init];
}

- (void)initView {
    self.segmentRemainDistanceLabel.text = @"0米后";
    self.turnImageView.image = [UIImage imageNamed:@"default_navi_action_1"];
    self.currentRoadNameLabel.text = @"从 当前道路 进入";
    self.nextRoadNameLabel.text = @"下条道路名称";
}

- (void)setRemainDistance:(NSString *)distance {
    NSString *distanceStr = nil;
    if ([NSString isBlankString:distance]) {
        distanceStr = @"暂无数据";
    }
    else {
        distanceStr = [NSString stringWithFormat:@"%@后", distance];
    }
    _segmentRemainDistanceLabel.text = distanceStr;
}

- (void)setTurnImageWithIndex:(NSInteger)index {
    if (index == 0) {
        _turnImageView.image = nil;
    }
    else {
        _turnImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default_navi_action_%ld", (long)index]];
    }
}

- (void)setCurrentRoadName:(NSString *)currentRoadName {
    if ([NSString isBlankString:currentRoadName]) {
        _currentRoadNameLabel.text = @"暂无当前道路名";
    }
    else {
        _currentRoadNameLabel.text = [NSString stringWithFormat:@"从 %@ 进入", currentRoadName];
    }
}

- (void)setNextRoadName:(NSString *)nextRoadName {
    if ([NSString isBlankString:nextRoadName]) {
        _nextRoadNameLabel.text = @"暂无当前道路名";
    }
    else {
        _nextRoadNameLabel.text = nextRoadName;
    }
}


- (void)showInView:(UIView *)view {
    _superView = view;

    if ([_superView.subviews containsObject:self]) {
        return;
    }

    self.frame = _frameForHidden;
    [_superView addSubview:self];

    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.frame = weakself.frameForShow;
    }];
}

- (void)dismiss {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.frame = weakself.frameForHidden;
    } completion:^(BOOL finished) {
        [weakself initView];
        [weakself removeFromSuperview];
    }];
}

@end
