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
@interface MRadarChartView ()<RPRadarChartDataSource, RPRadarChartDelegate>

@property (nonatomic, strong) RPRadarChart* RadarChart;
@property (nonatomic, strong)NSArray *aryData;
@end

@implementation MRadarChartView
{
    NSArray *colors;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
- (void)drawRect:(CGRect)rect {
    
    [self data];
    [self addRadarChart];
}

-(void)data
{

    NSArray *data1=[[NSArray alloc]initWithObjects:@"最適化存貨周轉(60)",@"data1",nil];
    NSArray *data2=[[NSArray alloc]initWithObjects:@"提昇供應鏈品質(75)",@"data2",nil];
    NSArray *data3=[[NSArray alloc]initWithObjects:@"提升生產效率(90)",@"data3",nil];
    NSArray *data4=[[NSArray alloc]initWithObjects:@"提升生產效率(90)",@"data3",nil];
    NSArray *data5=[[NSArray alloc]initWithObjects:@"提升生產效率(90)",@"data3",nil];
    
    _aryData=[[NSArray alloc]initWithObjects:data1,data2,data3,data4,data5,nil];

}
-(void)addRadarChart
{
      
    if(!_RadarChart){
        _RadarChart = [[RPRadarChart alloc] initWithFrame:CGRectMake(0, 0,150, 150)];
        _RadarChart.dataSource = self;
        _RadarChart.delegate = self;


        _RadarChart.backgroundColor = [UIColor orangeColor];
        
        
        _RadarChart.backLineWidth=1;  //輻射線與同心圓的線的寬度
        _RadarChart.frontLineWidth=1;  //多角形的線框的寬度
        _RadarChart.dotRadius=0;//多角形的點的大小
//        _RadarChart.lineColor=[UIColor blackColor];
//        _RadarChart.fillColor=[UIColor whiteColor];
        _RadarChart.drawGuideLines=YES;  //顯示同心圓
        _RadarChart.showGuideNumbers=NO;
        _RadarChart.showValues=NO;
        _RadarChart.fillArea=YES;
        _RadarChart.guideLineSteps=5;
        
//        //Private
//        float maxSize;
//        float maxValue;
//        float minValue;

        
        
        [self addSubview:_RadarChart];
    }

 }
#pragma mark -- data chart data source

// get number of spokes in radar chart
- (NSInteger)numberOfSopkesInRadarChart:(RPRadarChart*)chart
{
    return [_aryData count];
}

// get number of datas
- (NSInteger)numberOfDatasInRadarChart:(RPRadarChart*)chart
{
    return 1;
}

// get max value for this radar chart
- (float)maximumValueInRadarChart:(RPRadarChart*)chart
{
    return 6;
}

// get title for each spoke
- (NSString*)radarChart:(RPRadarChart*)chart titleForSpoke:(NSInteger)atIndex
{
    return [NSString stringWithFormat:@"%@", _aryData[atIndex][0]];
}

-(NSArray *)radarChart:(RPRadarChart*)chart aryData:(NSArray *)ary;
{
    return _aryData;
}
// get data value for a specefic data item for a spoke
- (float)radarChart:(RPRadarChart*)chart valueForData:(NSInteger)dataIndex forSpoke:(NSInteger)spokeIndex
{
    float data2[] = {2, 3, 4, 5, 6,1};
    return data2[spokeIndex];
}
// get color legend for a specefic data
- (UIColor*)radarChart:(RPRadarChart*)chart colorForData:(NSInteger)atIndex
{
    return [UIColor colorWithRed:134.0/255.0 green:199.0/255.0 blue:214.0/255.0 alpha:1];
}

#pragma mark -- delegate for chart

- (void)radarChart:(RPRadarChart *)chart lineTouchedForData:(NSInteger)dataIndex atPosition:(CGPoint)point
{
    NSLog(@"Line %d touched at (%f,%f)", dataIndex, point.x, point.y);
}
- (void)btnTitilClick:(id)sender
{
    NSLog(@"%ld",(long)[sender tag]);
    NSLog(@"成功成功成功");
}

@end
