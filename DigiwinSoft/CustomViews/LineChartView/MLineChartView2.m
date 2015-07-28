//
//  MLineChartView2.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLineChartView2.h"
#import "MCoordinate.h"
#import "MChartRangeView.h"

@interface MLineChartView2()<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat gapX;
@property (nonatomic, strong) NSString* topString;
@property (nonatomic, assign) NSInteger rangeIndex;

@property (nonatomic, strong) MChartRangeView* chartRangeView;

@end

@implementation MLineChartView2

- (id)init
{
    self = [super init];
    if (self)
    {
        _points = [NSMutableArray new];
        _scale = 1.;
        _gapX = 0.;
        _rangeIndex = 0.;
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
        _gapX = 0.;
        _rangeIndex = 0.;
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
    
    _gapX = self.frame.size.width / (count - 1);
    for (int index = 0; index < points.count; index++) {
        
        MTarget* target = [points objectAtIndex:index];
        
        MCoordinate* coord = [MCoordinate new];
        coord.target = target;
        coord.x = index * _gapX;
        coord.y = [target.valueR integerValue] * _scale;
        
        [_points addObject:coord];
    }
    
    [self setTopString];
}

- (void)setTopString
{
    MCoordinate* coord = [_points lastObject];
    _topString = coord.target.valueR;
}

- (void)resetPoints
{
    for (MCoordinate* coord in _points) {
        MTarget* target = coord.target;
        coord.y = [target.valueR integerValue] * _scale;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    /* 取得得目前的圖像內文，並將其保存起來 */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    
    /* 開始繪製矩形*/
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 212./255., 219./255., 227./255., 1.0);
    CGContextAddRect( context , CGRectMake(0, 0, rect.size.width , rect.size.height));
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFill);
    
    /* 填滿折線圖 */
    [self fillAreaWithContext:context];
    
    /* 折線圖 */
    [self drawLineWithContext:context];
    
    CGContextRestoreGState(context);
    
    // add chart range view
    [self addChartRangeView];
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
        prev = coord;
    }
    
    CGPathCloseSubpath(pathRef);
    CGContextAddPath(context, pathRef);
    CGContextFillPath(context);
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
        NSLog(@"%d, %d, %@", (int)coord.x, (int)coord.y, coord.target.valueR);
        
        CGContextMoveToPoint(context, prev.x, prev.y);
        CGContextAddLineToPoint(context, coord.x, coord.y);
        
        
        prev = coord;
    }
    
    CGContextStrokePath(context);
}

- (void)addChartRangeView
{
    if(_chartRangeView)
        return;
    
    _chartRangeView = [[MChartRangeView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*5/3 + 10, self.bounds.size.height)];
    _chartRangeView.backgroundColor = [UIColor clearColor];
    [self addSubview:_chartRangeView];
    
    [self resetChartRangeViewPoint];
}

- (void)resetChartRangeViewPoint
{
    NSInteger subCount1 = _points.count / 3 * _rangeIndex + _points.count / 6 - 1;
    NSInteger subCount2 = subCount1 + 1;
    
    MCoordinate* coord1 = [_points objectAtIndex:subCount1];
    MCoordinate* coord2 = [_points objectAtIndex:subCount2];
    CGFloat posX = (coord1.x + coord2.x) / 2.;
    
    [UIView animateWithDuration:0.1f
                     animations:^{
                         _chartRangeView.center = CGPointMake(posX, self.bounds.size.height/2);;
                     }
     ];
}

#pragma mark - 

- (void)moveRange:(NSString*) direction
{
    if ([direction isEqualToString:@"left"]) {
        if (_rangeIndex > 0)
            _rangeIndex--;
        else
            return;
    } else if ([direction isEqualToString:@"right"]) {
        if (_rangeIndex < 2)
            _rangeIndex++;
        else
            return;
    } else {
        return;
    }    
    
    [self resetChartRangeViewPoint];
}

@end
