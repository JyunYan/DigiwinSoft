//
//  MLineChartView.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLineChartView.h"
#import "MCoordinate.h"

#define SCALE_FOR_VALUE [[UIScreen mainScreen] scale]

@interface MLineChartView()

@end

@implementation MLineChartView

- (id)init
{
    self = [super init];
    if (self)
    {
        _points = [NSMutableArray new];
        _scale = 1.;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _points = [NSMutableArray new];
        _scale = 1.;
    }
    
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self resetPoints];
}

-(void)setPoints:(NSMutableArray *)points
{
    [_points removeAllObjects];
    
    NSInteger count = points.count;
    if(count == 0)
        return;
    
    CGFloat gap = self.frame.size.width / (count - 1);
    for (int index = 0; index < points.count; index++) {
        
        MTarget* target = [points objectAtIndex:index];
        
        MCoordinate* coord = [MCoordinate new];
        coord.target = target;
        coord.x = index * gap * SCALE_FOR_VALUE;
        coord.y = [target.valueR integerValue] * _scale * SCALE_FOR_VALUE;
        
        [_points addObject:coord];
    }
}

- (void)resetPoints
{
    for (MCoordinate* coord in _points) {
        MTarget* target = coord.target;
        coord.y = [target.valueR integerValue] * _scale * SCALE_FOR_VALUE;
    }
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
    
    
    /* 開始繪製矩形*/
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 212./255., 219./255., 227./255., 1.0);
    CGContextAddRect( context , CGRectMake(0, 0, rect.size.width*SCALE_FOR_VALUE , rect.size.height*SCALE_FOR_VALUE));
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFill);
    
    //
    [self drawCoordinateAxis:context];
    
    /* 填滿折線圖 */
    [self fillAreaWithContext:context];
    
    /* 折線圖 */
    [self drawLineWithContext:context];
    
    CGContextRestoreGState(context);
}

- (void)fillAreaWithContext:(CGContextRef)context
{
    //UIColor* blue = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:0.8];
    //CGContextSetRGBStrokeColor(context, 131/255., 208/255., 229/255., 0.5);
    CGContextSetRGBFillColor(context, 131/255., 208/255., 229/255., 0.5);
    //CGContextSetLineJoin(context, kCGLineJoinRound);
    //CGContextSetLineWidth(context, 3.0);
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    MCoordinate* prev = nil;
    for (int index = 0; index < _points.count; index++){
        
        if(index == 0){
            prev = [_points objectAtIndex:index];
            continue;
        }
        
        MCoordinate* coord = [_points objectAtIndex:index];
        CGPathMoveToPoint(pathRef, NULL, prev.x, 0);
        CGPathAddLineToPoint(pathRef, NULL, coord.x, 0);
        CGPathAddLineToPoint(pathRef, NULL, prev.x, prev.y);
        
        CGPathMoveToPoint(pathRef, NULL, coord.x, coord.y);
        CGPathAddLineToPoint(pathRef, NULL, coord.x, 0);
        CGPathAddLineToPoint(pathRef, NULL, prev.x, prev.y);
        
        if(index == _points.count - 1){
            CGPathCloseSubpath(pathRef);
            CGContextAddPath(context, pathRef);
            CGContextFillPath(context);
        }

        prev = coord;
    }
}

- (void)drawLineWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    UIColor* color = [UIColor colorWithRed:0.0/255.0 green:61.0/255.0 blue:121.0/255.0 alpha:1.0];
    CGContextSetStrokeColorWithColor(context, color.CGColor);   //線的顏色
    
    
    MCoordinate* prev = nil;
    for (int index = 0; index < _points.count; index++){
        
        if(index == 0){
            prev = [_points objectAtIndex:index];
            continue;
        }
        
        MCoordinate* coord = [_points objectAtIndex:index];
        NSLog(@"%d, %d, %@", coord.x, coord.y, coord.target.valueR);
        
        CGContextMoveToPoint(context, prev.x, prev.y);
        CGContextAddLineToPoint(context, coord.x, coord.y);
        CGContextStrokePath(context);
        
        prev = coord;
    }
}

- (void)drawCoordinateAxis:(CGContextRef)context
{
    NSInteger width = self.frame.size.width *  SCALE_FOR_VALUE;
    NSInteger height = self.frame.size.height * SCALE_FOR_VALUE;
    
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
