//
//  MTarInfoChartView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarInfoChartView.h"
#import "MLineChartView.h"
#import "MTarget.h"
#import "MDirector.h"
#import "MTarMeterView.h"
#import "MTarChartView.h"

@interface MTarInfoChartView ()

@property (nonatomic) MTarget* target;

@end

@implementation MTarInfoChartView

- (void)setHistoryArray:(NSArray *)historyArray
{
    _historyArray = historyArray;
    
    if(historyArray.count > 0)
        self.target = [historyArray lastObject];
    else
        self.target = [MTarget new];
}

- (void)drawRect:(CGRect)rect
{
    //計量表
    CGSize size = [[MDirector sharedInstance] getScaledSize:CGSizeMake(1080, 830)];
    MTarMeterView* meter = [[MTarMeterView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    meter.target = self.target;
    meter.backgroundColor = [UIColor clearColor];
    [self addSubview:meter];
    
    //長灰線
    [self createRectAtView:self frame:CGRectMake(39,830,1002,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    
    //折線圖
    CGRect frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(0, 830, 1080, 940)];
    MTarChartView* chart = [[MTarChartView alloc] initWithFrame:frame];
    chart.historys = _historyArray;
    chart.backgroundColor = [UIColor clearColor];
    [self addSubview:chart];
    
    //close btn
    UIButton *btn_close=[[UIButton alloc]initWithFrame:  [[MDirector sharedInstance] getScaledRect:CGRectMake(974, 140, 66, 66)]];
    [btn_close setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(actionCloseChatView:) forControlEvents:UIControlEventTouchUpInside];
    btn_close.backgroundColor=[UIColor clearColor];
    [self addSubview:btn_close];
}

- (void)actionCloseChatView:(id)sender
{
    [self removeFromSuperview];
}

-(void) createRectAtView:(UIView*)view  frame:(CGRect)frame color:(UIColor*)color
{
    CGRect frame2 = [[MDirector sharedInstance] getScaledRect:frame];
    UIView* rect = [[UIView alloc] initWithFrame:frame2];
    rect.backgroundColor = color;
    [view addSubview:rect];
}

@end
