//
//  MBarChartView.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MBarChartView.h"

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
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    lab.text=[NSString stringWithFormat:@"%@",_aryBarData[0]];
    lab.backgroundColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lab];
    
    NSArray *data0=[[NSArray alloc]initWithObjects:@"現金流動比率",@"60",nil];
    NSArray *data1=[[NSArray alloc]initWithObjects:@"速動比率",@"70",nil];
    NSArray *data2=[[NSArray alloc]initWithObjects:@"資金積壓天數",@"40",nil];
    NSArray *data3=[[NSArray alloc]initWithObjects:@"存貨週轉天數",@"50",nil];
    NSArray *data4=[[NSArray alloc]initWithObjects:@"淨利率",@"55",nil];
    
    NSMutableArray *aryData=[[NSMutableArray alloc]initWithObjects:data0,data1,data2,data3,data4,nil];
    
    for (int i=0; i<[aryData count]; i++) {
        
        //barTitle
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(20, (i*25)+70,85, 15)];
        lab.text=aryData[i][0];
        lab.font=[UIFont systemFontOfSize:12];
        lab.textAlignment=NSTextAlignmentRight;
        lab.backgroundColor=[UIColor whiteColor];
        [self addSubview:lab];
        
        
        //bar
        CGFloat value=[aryData[i][1]floatValue];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);//填充顏色
        CGContextFillRect(context,CGRectMake(110, (i*25)+73, value*1.8, 10));//填充框
        CGContextDrawPath(context, kCGPathFillStroke);//繪畫路徑
        
        //barValue

    }
    
    //直線
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 110, 70);
    CGContextAddLineToPoint(ctx, 110, 188);
    CGContextStrokePath(ctx);
    
    //橫bar
    
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
