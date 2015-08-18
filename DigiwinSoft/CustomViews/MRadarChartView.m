//
//  MRadarChartView.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRadarChartView.h"
#import "RPRadarChart.h"
#import "MConfig.h"
#import "MDirector.h"
#import "MEfficacy.h"

@interface MRadarChartView ()<RPRadarChartDataSource, RPRadarChartDelegate>

@property (nonatomic, strong) RPRadarChart* RadarChart;
@property (nonatomic, strong) MEfficacy* Data;

@end

@implementation MRadarChartView
{
    NSArray *colors;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat posY = 0.;
        _RadarChart = [self createRadarChartWithFrame:CGRectMake(0, posY,frame.size.width, frame.size.width*0.7)];
        [self addSubview:_RadarChart];
        
        UILabel* centerLabel = [self createCenterLabelWithFrame:CGRectMake(0, 0, 100, 100)];
        centerLabel.center = _RadarChart.center;
        [self addSubview:centerLabel];
        
        
        posY += _RadarChart.frame.size.height;
        UILabel* label = [self createBottomLabelWithFrame:CGRectMake(0, posY,frame.size.width, 30)];
        [self addSubview:label];
    }
    return self;
}

- (RPRadarChart*)createRadarChartWithFrame:(CGRect)frame
{
    RPRadarChart* radar = [[RPRadarChart alloc] initWithFrame:frame];
    radar.dataSource = self;
    radar.delegate = self;
    
    radar.backgroundColor = [UIColor whiteColor];
    
    radar.backLineWidth=1.5;  //輻射線與同心圓的線的寬度
    radar.frontLineWidth=1;  //多角形的線框的寬度
    radar.dotRadius=0;//多角形的點的大小
    //_RadarChart.lineColor=[UIColor blackColor];
    //_RadarChart.fillColor=[UIColor whiteColor];
    radar.drawGuideLines=YES;  //顯示同心圓
    radar.showGuideNumbers = NO;
    radar.showValues = NO;
    radar.fillArea = YES;
    radar.guideLineSteps=5;
    
    radar.currentSpokeIndex = 0;
    
    
    return radar;
 }

- (UILabel*)createCenterLabelWithFrame:(CGRect)frame
{
    UILabel *lab=[[UILabel alloc]initWithFrame:frame];
    lab.backgroundColor=[UIColor clearColor];
    lab.textColor=[UIColor colorWithRed:245.0/255.0 green:113.0/255.0 blue:116.0/255.0 alpha:1];
    lab.text=@"81";
    lab.font=[UIFont systemFontOfSize:60];
    lab.textAlignment = NSTextAlignmentCenter;
    
    return lab;
}

- (UILabel*)createBottomLabelWithFrame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12.];
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"單位:PR值";
    
    return label;
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setCurrentSpokeIndex:(NSInteger)index
{
    _RadarChart.currentSpokeIndex = index;
}

#pragma mark -- data chart data source

// get number of spokes in radar chart
- (NSInteger)numberOfSopkesInRadarChart:(RPRadarChart*)chart
{
    return [_aryRadarChartData count];
}

// get number of datas
- (NSInteger)numberOfDatasInRadarChart:(RPRadarChart*)chart
{
    return 1;
}

// get max value for this radar chart
- (float)maximumValueInRadarChart:(RPRadarChart*)chart
{
    return 100;//最大值
}

// get title for each spoke
- (NSString*)radarChart:(RPRadarChart*)chart titleForSpoke:(NSInteger)atIndex
{
    //return @"";
    MEfficacy *mEff=_aryRadarChartData[atIndex];
    return [NSString stringWithFormat:@"%@(%@)", mEff.name, mEff.pr];
}

// get data value for a specefic data item for a spoke
- (float)radarChart:(RPRadarChart*)chart valueForData:(NSInteger)dataIndex forSpoke:(NSInteger)spokeIndex
{
    //return 0;
    MEfficacy *mEff=_aryRadarChartData[spokeIndex];
    NSString *value=mEff.pr;
    return [value floatValue];
}
// get color legend for a specefic data
- (UIColor*)radarChart:(RPRadarChart*)chart colorForData:(NSInteger)atIndex
{
    return [UIColor colorWithRed:134.0/255.0 green:199.0/255.0 blue:214.0/255.0 alpha:1];
}

#pragma mark -- delegate for chart

- (void)radarChart:(RPRadarChart *)chart lineTouchedForData:(NSInteger)dataIndex atPosition:(CGPoint)point
{
    NSLog(@"Line %d touched at (%f,%f)", (int)dataIndex, point.x, point.y);
}

- (void)radarChart:(RPRadarChart *)chart didSelectedSpokeWithIndx:(NSInteger)spokeIndex
{
    if(_delegate && [_delegate respondsToSelector:@selector(radarChartView:didSelectedSpokeWithIndx:)])
        [_delegate radarChartView:self didSelectedSpokeWithIndx:spokeIndex];
}
@end
