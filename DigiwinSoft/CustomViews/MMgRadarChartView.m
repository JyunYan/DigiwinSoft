//
//  MMgRadarChartView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMgRadarChartView.h"
#import "RPRadarChart.h"
#import "MConfig.h"
#import "MDirector.h"
#import "MIssue.h"

@interface MMgRadarChartView ()<RPRadarChartDataSource, RPRadarChartDelegate>

@property (nonatomic, strong) RPRadarChart* RadarChart;

@end

@implementation MMgRadarChartView
{
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self clean];
    
    CGFloat posY = 0.;
    _RadarChart = [self createRadarChartWithFrame:CGRectMake(0, posY,rect.size.width, rect.size.width*0.7)];
    [self addSubview:_RadarChart];
    
    posY += _RadarChart.frame.size.height;
    UIView* tag = [self createBottomViewWithFrame:CGRectMake(0, posY,rect.size.width, 30)];
    [self addSubview:tag];
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
    radar.drawGuideLines=YES;  //顯示同心圓
    radar.showGuideNumbers=NO;
    radar.showValues=NO;
    radar.fillArea=YES;
    radar.guideLineSteps=5;

    return radar;
}

- (UIView*)createBottomViewWithFrame:(CGRect)frame
{
    UIView* base = [[UIView alloc] initWithFrame:frame];
    base.backgroundColor = [UIColor clearColor];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [base addSubview:view];
    
    CGFloat posX = 0.;
    
    UIView* imgNow = [[UIView alloc] initWithFrame:CGRectMake(posX, (frame.size.height-10)/2., 10, 10)];
    imgNow.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:199.0/255.0 blue:214.0/255.0 alpha:1];  //blue
    [view addSubview:imgNow];
    
    posX += imgNow.frame.size.width + 4.;
    
    UILabel* dateNow = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, 50, frame.size.height)];
    dateNow.backgroundColor = [UIColor clearColor];
    dateNow.font = [UIFont boldSystemFontOfSize:14.];
    dateNow.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    dateNow.textAlignment = NSTextAlignmentCenter;
    dateNow.text = [_dateNewString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [view addSubview:dateNow];
    
    posX += dateNow.frame.size.width + 20.;
    
    UIView* imgOld = [[UIView alloc] initWithFrame:CGRectMake(posX, (frame.size.height-10)/2., 10, 10)];
    imgOld.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:137.0f/255.0f blue:135.0f/255.0f alpha:1.0f];  //red
    [view addSubview:imgOld];
    
    posX += imgOld.frame.size.width + 4.;
    
    UILabel* dateOld = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, 50, frame.size.height)];
    dateOld.backgroundColor = [UIColor clearColor];
    dateOld.font = [UIFont boldSystemFontOfSize:14.];
    dateOld.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    dateOld.textAlignment = NSTextAlignmentCenter;
    dateOld.text = [_dateOldString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [view addSubview:dateOld];
    
    posX += dateOld.frame.size.width;
    
    view.frame = CGRectMake(0, 0, posX, frame.size.height);
    view.center = CGPointMake(frame.size.width/2., frame.size.height/2.);
    
    return base;
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)refresh
{
    [self setNeedsDisplay];
}

- (void)setCurrentSpokeIndex:(NSInteger)index
{
    _RadarChart.currentSpokeIndex = index;
}

#pragma mark -- data chart data source

// get number of spokes in radar chart
- (NSInteger)numberOfSopkesInRadarChart:(RPRadarChart*)chart
{
    return MAX([_dataNow count], [_dataOld count]);
}

// get number of datas
- (NSInteger)numberOfDatasInRadarChart:(RPRadarChart*)chart
{
    return 2;
}

// get max value for this radar chart
- (float)maximumValueInRadarChart:(RPRadarChart*)chart
{
    return 100;//最大值
}

// get title for each spoke
- (NSString*)radarChart:(RPRadarChart*)chart titleForSpoke:(NSInteger)atIndex
{
    //NSArray* array = (_data2.count > _data1.count) ? _data2 : _data1;
    //MIssue* issue = [array objectAtIndex:atIndex];
    
    MIssue* issue = [_dataNow objectAtIndex:atIndex];
    
    return [NSString stringWithFormat:@"%@(%@)", issue.name, issue.pr];
}

// get data value for a specefic data item for a spoke
- (float)radarChart:(RPRadarChart*)chart valueForData:(NSInteger)dataIndex forSpoke:(NSInteger)spokeIndex
{
    if(dataIndex == 0){ // old
        MIssue* issue = [_dataOld objectAtIndex:spokeIndex];
        return [issue.pr floatValue];
    }else { // now
        MIssue* issue = [_dataNow objectAtIndex:spokeIndex];
        return [issue.pr floatValue];
    }
}
// get color legend for a specefic data
- (UIColor*)radarChart:(RPRadarChart*)chart colorForData:(NSInteger)atIndex
{
    //return [UIColor colorWithRed:134.0/255.0 green:199.0/255.0 blue:214.0/255.0 alpha:0.3];
    if(atIndex == 0)
        return [UIColor colorWithRed:243.0f/255.0f green:137.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    else
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

