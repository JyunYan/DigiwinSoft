//
//  MLineChartView.m
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MLineChartView.h"
#import "MCoordinate.h"
#import "MDashedLine.h"

@interface MLineChartView()<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat gapX;
@property (nonatomic, strong) MDashedLine* dashLineView;
@property (nonatomic, strong) NSString* topString;

@end

@implementation MLineChartView

- (id)init
{
    self = [super init];
    if (self)
    {
        _points = [NSMutableArray new];
        _scale = 1.;
        _gapX = 0.;
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
    
    // 
    [self drawCoordinateAxis:context];
    
    /* 填滿折線圖 */
    [self fillAreaWithContext:context];
    
    /* 折線圖 */
    [self drawLineWithContext:context];
    
    CGContextRestoreGState(context);
    
    // add dash view
    [self addDashLineView];
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

- (void)drawCoordinateAxis:(CGContextRef)context
{
    NSInteger width = self.frame.size.width;
    NSInteger height = self.frame.size.height;
    
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

- (void)addDashLineView
{
    if(_dashLineView)
        return;
    
    CGFloat width = self.frame.size.width * 0.4;
    _dashLineView = [[MDashedLine alloc] initWithFrame:CGRectMake(0, 0, width, self.bounds.size.height)];
    _dashLineView.center = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.);
    _dashLineView.backgroundColor = [UIColor clearColor];
    _dashLineView.topText = _topString;
    [self addSubview:_dashLineView];
    
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.maximumNumberOfTouches = 1;
    [_dashLineView addGestureRecognizer:recognizer];
}

#pragma mark - 處理手勢操作相關

- (void)handlePan:(UIGestureRecognizer*)recognizer
{
    UIView* view = recognizer.view;
    CGPoint point = [recognizer locationInView:self];
    BOOL b = CGRectContainsPoint(self.bounds, point);
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"begin");
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"changed");
        if(b)   // in rect
            view.center = CGPointMake(point.x, view.center.y);
        else if(point.x < 0 && point.y > 0 && point.y < self.bounds.size.height)    //左側 out rect
            view.center = CGPointMake(0, view.center.y);
        else if (point.x > self.bounds.size.width && point.y > 0 && point.y < self.bounds.size.height)  //右側 out rect
            view.center = CGPointMake(self.bounds.size.width, view.center.y);
        [self setBottomTextAtPoint:view.center];
        [self setTopTextAtPoint:view.center];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"end");
        MCoordinate* coord = [self theNearestNodeByPoint:view.center];
        view.center = CGPointMake(coord.x, view.center.y);
        [self setBottomTextAtPoint:CGPointMake(coord.x, coord.y)];
        [self setTopTextAtPoint:CGPointMake(coord.x, coord.y)];
    }
}

-(MCoordinate*)theNearestNodeByPoint:(CGPoint)point
{
    MCoordinate* coordinate = nil;
    CGFloat min = self.bounds.size.width;
    for (MCoordinate* coord in _points) {
        CGFloat absf = fabsf((float)point.x - (float)coord.x);
        if(absf < min){
            min = absf;
            coordinate = coord;
        }
    }
    return coordinate;
}

- (void)setTopTextAtPoint:(CGPoint)point
{
    CGFloat right = self.bounds.size.width;
    CGFloat left = self.bounds.origin.x;
    
    //if最右測
    if(point.x >= right){
        [_dashLineView hideTopBox:NO];
    }
    //if最左側
    if(point.x <= left){
        [_dashLineView hideTopBox:NO];
    }
    //if範圍內
    if(CGRectContainsPoint(self.bounds, point)){
        NSString* text = @"";
        BOOL hide = YES;
        for (int index=0; index < _points.count; index++) {
            MCoordinate* coord = [_points objectAtIndex:index];
            
            CGFloat fabs = fabsf((float)point.x - (float)coord.x);
            if(fabs <= 5.){
                hide = NO;
                text = [NSString stringWithFormat:@"%@%@", coord.target.valueR, coord.target.unit];
                break;
            }
        }
        [_dashLineView hideTopBox:hide];
        
        if(!hide)
            [_dashLineView setTopText:text];
    }
}

- (void)setBottomTextAtPoint:(CGPoint)point;
{
    CGFloat right = self.bounds.size.width;
    CGFloat left = self.bounds.origin.x;
    
    //if最左測
    if(point.x >= right){
        MCoordinate* coord = [_points lastObject];
        NSString* datetime = [coord.target.datetime substringToIndex:7];
        datetime = [datetime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [_dashLineView setBottomText:datetime];
    }
    //if最右側
    if(point.x <= left){
        MCoordinate* coord = [_points firstObject];
        NSString* datetime = [coord.target.datetime substringToIndex:7];
        datetime = [datetime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [_dashLineView setBottomText:datetime];
    }
    //if範圍內
    if(CGRectContainsPoint(self.bounds, point)){
        for (int index=0; index < _points.count; index++) {
            MCoordinate* coord = [_points objectAtIndex:index];
            CGFloat gap = point.x - coord.x;
            if(gap > 0 && gap < _gapX){
                NSString* datetime = [coord.target.datetime substringToIndex:7];
                datetime = [datetime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                [_dashLineView setBottomText:datetime];
                break;
            }
        }
    }
}

@end
