//
//  MBarChartView.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MBarChartView.h"
#import "MEfficacy.h"
#import "MTarget.h"
#import "MDirector.h"

#define SCALE 1.6
@implementation MBarChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    MEfficacy *data=_aryBarData;
    
        //title
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        lab.text=[NSString stringWithFormat:@"%@(%@)",data.name,data.pr];
        lab.backgroundColor=[UIColor whiteColor];
        lab.textColor=[UIColor colorWithRed:22.0/255.0 green:172.0/255.0 blue:197.0/255.0 alpha:1.0];
        lab.textAlignment=NSTextAlignmentCenter;
        [self addSubview:lab];
       
        //橫線
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        CGContextMoveToPoint(ctx, 0, 41);
        CGContextAddLineToPoint(ctx, self.frame.size.width, 41);
        CGContextStrokePath(ctx);

    
        for (int i=0; i<[data.effTargetArray count]; i++) {

        //barTitle
        UILabel *labTitle=[[UILabel alloc]initWithFrame:CGRectMake(5, (i*25)+65,70, 15)];
        labTitle.text=[data.effTargetArray[i]name];
        labTitle.font=[UIFont systemFontOfSize:12];
        labTitle.textAlignment=NSTextAlignmentRight;
        labTitle.backgroundColor=[UIColor whiteColor];
        [self addSubview:labTitle];
        
        //bar
        CGFloat value=[[_aryBarData.effTargetArray[i]pr] floatValue];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);//填充顏色
        CGContextFillRect(context,CGRectMake(80, (i*25)+68, value*SCALE, 10));//填充框
        CGContextDrawPath(context, kCGPathFillStroke);//繪畫路徑
        
        //barValue
            UILabel *labValue=[[UILabel alloc]initWithFrame:CGRectMake((80+(value*SCALE)+2), (i*25)+68,25, 10)];
            labValue.text=[data.effTargetArray[i]pr];
            labValue.font=[UIFont systemFontOfSize:12];
            labValue.textAlignment=NSTextAlignmentLeft;
            labValue.backgroundColor=[UIColor clearColor];
            [self addSubview:labValue];


    }
    
    //直線
    CGContextMoveToPoint(ctx, 80, 65);
    CGContextAddLineToPoint(ctx, 80, 182);
    CGContextStrokePath(ctx);
    
    //橫線
    CGContextMoveToPoint(ctx, 80, 182);
    CGContextAddLineToPoint(ctx, 80+(100*SCALE), 182);
    CGContextStrokePath(ctx);
    
    //绘制虚线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.5);
    UIColor *CustomBlue=[[MDirector sharedInstance] getCustomBlueColor];
    CGContextSetStrokeColorWithColor(context, CustomBlue.CGColor);
    CGFloat dashArray[] = {4,2};
    CGContextSetLineDash(context, 0, dashArray, 2);
    CGContextMoveToPoint(context, 80+(80*SCALE), 65);
    CGContextAddLineToPoint(context, 80+(80*SCALE), 182);
    CGContextStrokePath(context);
    
    //lab80
    UILabel *labVa=[[UILabel alloc]initWithFrame:CGRectMake((80+(80*SCALE)-10), 182, 20, 20)];
    labVa.font=[UIFont systemFontOfSize:12];
    labVa.textAlignment=NSTextAlignmentCenter;
    labVa.backgroundColor=[UIColor clearColor];
    labVa.textColor=[[MDirector sharedInstance] getCustomBlueColor];
    labVa.text=@"80";
    [self addSubview:labVa];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
