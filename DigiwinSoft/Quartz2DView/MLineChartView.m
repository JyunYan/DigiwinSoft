//
//  MLineChartView.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLineChartView.h"

#define SCALA_FOR_VALUE [[UIScreen mainScreen] scale]

@interface MLineChartView()

@property (nonatomic, strong) NSArray* pointsArray;

@end

@implementation MLineChartView

- (id)initWithPoints:(NSMutableArray*)point
{
    self = [super init];
    if (self)
    {
        _pointsArray = point;
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /* 取得得目前的圖像內文，並將其保存起來 */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    
    /* 開始繪製矩形 */
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.0);
    CGContextAddRect( context , CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFill);
    //
    [self drawCoordinateAxis:context];
    
    /* 折線圖 */
    CGContextSetLineWidth(context, 2.0);
    UIColor* color = [UIColor colorWithRed:0.0/255.0 green:61.0/255.0 blue:121.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    NSInteger width = self.frame.size.width * SCALA_FOR_VALUE;
    NSInteger height = self.frame.size.height * SCALA_FOR_VALUE;
    
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSInteger point_x = 0;
    NSInteger point_y = 0;
    
    NSInteger count = 0;
    NSInteger day = 0;
    
    NSDictionary* dict;
    
    for (int index = 0; index < _pointsArray.count; index++)
    {
        dict = [_pointsArray objectAtIndex:index];
        
        if (index == 0)
        {
            count = [[dict valueForKey:@"count"] integerValue];
            
            point_y = count * height / 120;
            
        }else
        {
            count = [[dict valueForKey:@"count"] integerValue];
            day = [[dict valueForKey:@"day"] integerValue];
            
            x = day * width / 12;
            y = count * height / 120;
            
            CGContextMoveToPoint(context, point_x, point_y);
            CGContextAddLineToPoint(context, x, y);
            CGContextStrokePath(context);
            
            point_x = x;
            point_y = y;
        }
        
        
    }
    
    CGContextRestoreGState(context);
}

- (void)drawCoordinateAxis:(CGContextRef)context
{
    NSInteger width = self.frame.size.width *  SCALA_FOR_VALUE;
    NSInteger height = self.frame.size.height * SCALA_FOR_VALUE;
    
    CGContextSetLineWidth(context, 2.0);
    UIColor* color = [UIColor lightGrayColor];// deep bule
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    /* axis_x */
    CGContextMoveToPoint(context, 0.0, 1.0);
    CGContextAddLineToPoint(context, width, 1.0);
    CGContextStrokePath(context);
    
    /* axis_y */
    CGContextMoveToPoint(context, 1.0, 0.0);
    CGContextAddLineToPoint(context, 1.0, height);
    CGContextStrokePath(context);
    
    NSInteger point_y = height / 4;
    
    for (int count = 1; count < 5; count++)
    {
        color = [UIColor whiteColor];// lifgt gray
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextMoveToPoint(context, 0.0, point_y * count);
        CGContextAddLineToPoint(context, width, point_y * count);
        CGContextStrokePath(context);
    }
    
}

@end
