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
    CGFloat y = _chart.frame.origin.y + _chart.frame.size.height;
    //CGRect frame2 = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 940, 1080, 780)];
    CGRect frame2 = CGRectMake(0, y, DEVICE_SCREEN_WIDTH, 200);
    MTarChartView2* chart2 = [[MTarChartView2 alloc] initWithFrame:frame2];
    chart2.delegate = self;
    chart2.historys = _historyArray;
    chart2.backgroundColor = [UIColor whiteColor];
    [self addSubview:chart2];
}

- (void)recreateTarChartView
{
    if (_chart)
        [_chart removeFromSuperview];
    
    NSArray* subArray = [_historyArray subarrayWithRange: [self getSubArrayRange]];
    CGRect frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 0, 1080, 940)];
    _chart = [[MTarChartView alloc] initWithFrame:frame];
    _chart.historys = subArray;
    _chart.backgroundColor = [UIColor clearColor];
    [self addSubview:_chart];
}

- (NSRange)getSubArrayRange
{
    NSInteger subCount = _historyArray.count / 3;
    NSInteger startIndex = subCount * _rangeIndex;
    /*
    if (_rangeIndex < 2) {
        // 銜接到下一區間的起點
        subCount++;
    }
     */

    return NSMakeRange(startIndex, subCount);
}

#pragma mark - MTarChartView2Delegate

- (void)designatedChartDidChanged:(MTarChartView2 *)chartView
{
    NSArray* historys = chartView.historys;
    NSInteger dataIndex = chartView.dataIndex;
    NSArray* array = [historys objectAtIndex:dataIndex];
    
    _chart.historys = array;
    [_chart setNeedsDisplay];
}

@end
