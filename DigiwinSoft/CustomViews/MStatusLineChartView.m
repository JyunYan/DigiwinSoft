//
//  MStatusLineChartView.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MStatusLineChartView.h"
#import "MDirector.h"
#import "MTarChartView.h"
#import "MTarChartView2.h"

@interface MStatusLineChartView ()<MTarChartView2Delegate>

@property (nonatomic, assign) NSInteger rangeIndex;

@property (nonatomic, strong) MTarChartView* chart;

@end

@implementation MStatusLineChartView

- (void)setHistoryArray:(NSArray *)historyArray
{
    _historyArray = historyArray;
}

- (void)drawRect:(CGRect)rect
{
    _rangeIndex = 0;
    
    //折線圖
    [self recreateTarChartView];
    
    //折線圖2
    CGRect frame2 = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 830, 1080, 780)];
    MTarChartView2* chart2 = [[MTarChartView2 alloc] initWithFrame:frame2];
    chart2.delegate = self;
    chart2.historys = _historyArray;
    chart2.backgroundColor = [UIColor clearColor];
    [self addSubview:chart2];
}

- (void)recreateTarChartView
{
    if (_chart)
        [_chart removeFromSuperview];
    
    NSArray* subArray = [_historyArray subarrayWithRange: [self getSubArrayRange]];
    CGRect frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 0, 1080, 830)];
    _chart = [[MTarChartView alloc] initWithFrame:frame];
    _chart.historys = subArray;
    _chart.backgroundColor = [UIColor clearColor];
    [self addSubview:_chart];
}

- (NSRange)getSubArrayRange
{
    NSInteger subCount = _historyArray.count / 3;
    NSInteger startIndex = subCount * _rangeIndex;

    return NSMakeRange(startIndex, subCount);
}

#pragma mark - MTarChartView2 delegate

- (void)moveRange:(NSString *)direction
{
    if ([direction isEqualToString:@"left"]) {
        if (_rangeIndex > 0)
            _rangeIndex--;
        else
            return;
    } else if ([direction isEqualToString:@"right"]) {
        if (_rangeIndex < 2)
            _rangeIndex++;
        else
            return;
    } else {
        return;
    }
    
    [self recreateTarChartView];
}

@end
