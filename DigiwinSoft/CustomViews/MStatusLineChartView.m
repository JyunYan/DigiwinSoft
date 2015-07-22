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

@implementation MStatusLineChartView

- (void)setHistoryArray:(NSArray *)historyArray
{
    _historyArray = historyArray;
}

- (void)drawRect:(CGRect)rect
{
    //折線圖
    CGRect frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 0, 1080, 940)];
    MTarChartView* chart = [[MTarChartView alloc] initWithFrame:frame];
    chart.historys = _historyArray;
    chart.backgroundColor = [UIColor clearColor];
    [self addSubview:chart];
    
    //折線圖2
    CGRect frame2 = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 940, 1080, 940)];
    MTarChartView2* chart2 = [[MTarChartView2 alloc] initWithFrame:frame2];
    chart2.historys = _historyArray;
    chart2.backgroundColor = [UIColor clearColor];
    [self addSubview:chart2];
}

@end
