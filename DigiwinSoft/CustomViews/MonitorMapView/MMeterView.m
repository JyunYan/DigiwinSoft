//
//  MMeterView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMeterView.h"
#import "MDirector.h"
#import "MIssue.h"

@interface MMeterView ()

@property (nonatomic, assign) NSInteger totalExpected;  //預期收益總額
@property (nonatomic, assign) NSInteger totalReal;      //實際收益總額
@property (nonatomic, strong) NSMutableArray* points;

@end

@implementation MMeterView

- (id)init
{
    if(self = [super init]){
        self.layer.borderWidth = 1.6;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = CORNRADIUS_OUTER;
        
        _points = [NSMutableArray new];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderWidth = 1.6;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = CORNRADIUS_OUTER;
        
        _points = [NSMutableArray new];
    }
    return self;
}

- (void)setIssueGroup:(NSArray *)issueGroup
{
    _issueGroup = issueGroup;
    
    [self calculateTotalGanin];
    [self preparePoints];
}

- (void)preparePoints
{
    [_points removeAllObjects];
    
    CGRect rect = CGRectMake(self.frame.origin.x + 4, self.frame.origin.y + 4, self.frame.size.width - 8, self.frame.size.height - 8);
    CGFloat posX = rect.origin.x;
    for (int index=0; index < _issueGroup.count; index++) {
        MIssue* issue = [_issueGroup objectAtIndex:index];
        CGFloat width = [self calculateFillWidthWithRect:rect issue:issue];
        
        // save point
        CGPoint point = CGPointMake(self.frame.origin.x + posX + width*0.5, rect.origin.y + rect.size.height);
        [_points addObject:[NSValue valueWithCGPoint:point]];
        
        posX += width;
    }
    
    _endPoint = CGPointMake(posX, self.center.y);
}

- (void)calculateTotalGanin
{
    _totalExpected = 0;
    for (MIssue* issue in _issueGroup) {
        NSInteger gain = [issue.gainP integerValue];
        _totalExpected += gain;
    }
}

- (CGFloat)calculateFillWidthWithRect:(CGRect)rect issue:(MIssue*)issue
{
    CGFloat width = rect.size.width;
    NSInteger gainR = [issue.gainR integerValue];
    
    if(_totalExpected == 0)
        return 0;
    else
        return width * gainR / _totalExpected;
}

- (UIColor*)getColorWithIndex:(NSInteger)index
{
    NSInteger value = index % 3;
    if(value == 1)
        return [[MDirector sharedInstance] getCustomBlueColor];
    else if(value == 2)
        return [[MDirector sharedInstance] getCustomOrangeColor];
    else
        return [[MDirector sharedInstance] getForestGreenColor];
}

- (CGPoint)getPointWithIndex:(NSInteger)index
{
    NSValue* value = [_points objectAtIndex:index];
    return [value CGPointValue];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect2 = CGRectMake(rect.origin.x + 4, rect.origin.y + 4, rect.size.width - 8, rect.size.height - 8);
    [self fillRect:rect2 context:context];
}

- (void)fillRect:(CGRect)rect context:(CGContextRef)context
{
    _totalReal = 0;
    CGFloat posX = rect.origin.x;
    for (int index=0; index < _issueGroup.count; index++) {
        
        MIssue* issue = [_issueGroup objectAtIndex:index];
        NSInteger total = _totalReal + [issue.gainR integerValue];
        
        CGFloat width = [self calculateFillWidthWithRect:rect issue:issue];
        CGRect rect2 = CGRectMake(posX, rect.origin.y, width, rect.size.height);
        
        if(_totalReal == 0 && total == [issue.gainP integerValue])
            [self drawBothArcWithContext:context rect:rect2 index:index];   //光某一個就滿了
        else if(index == 0)
            [self drawLeftArcWithContext:context rect:rect2 index:index];   // 第一個
        else if(total == [issue.gainP integerValue])
            [self drawRightArcWithContext:context rect:rect2 index:index];  // 最後一個
        else
            [self drawNoArcWithContext:context rect:rect2 index:index];     //中間其他
        
        posX += width;
        _totalReal = total;
    }
}

- (void)drawLeftArcWithContext:(CGContextRef)context rect:(CGRect)rect index:(NSInteger)index
{
    UIColor* color = [self getColorWithIndex:index];
    
    float left = rect.origin.x;
    float left_center = left + CORNRADIUS_INNER;
    float right = left + rect.size.width;
    float top = rect.origin.y;
    float top_center = top + CORNRADIUS_INNER;
    float bottom = top + rect.size.height;
    float bottom_center = bottom - CORNRADIUS_INNER;
    
    CGContextMoveToPoint(context, left, top_center);
    //左上
    CGContextAddArcToPoint(context, left, top, left_center, top, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, right, top);
    CGContextAddLineToPoint(context, right, bottom);
    CGContextAddLineToPoint(context, left_center, bottom);
    //左下
    CGContextAddArcToPoint(context, left, bottom, left, bottom_center, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, left, top_center);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
}

- (void)drawRightArcWithContext:(CGContextRef)context rect:(CGRect)rect index:(NSInteger)index
{
    UIColor* color = [self getColorWithIndex:index];
    
    float left = rect.origin.x;
    float right = left + rect.size.width;
    float right_center = right - CORNRADIUS_INNER;
    float top = rect.origin.y;
    float top_center = top + CORNRADIUS_INNER;
    float bottom = top + rect.size.height;
    float bottom_center = bottom - CORNRADIUS_INNER;
    
    CGContextMoveToPoint(context, left, top);
    CGContextAddLineToPoint(context, right_center, top);
    CGContextAddArcToPoint(context, right, top, right, top_center, CORNRADIUS_INNER);   //右上
    CGContextAddLineToPoint(context, right, bottom_center);
    CGContextAddArcToPoint(context, right, bottom, right_center, bottom, CORNRADIUS_INNER); //右下
    CGContextAddLineToPoint(context, left, bottom);
    CGContextAddLineToPoint(context, left, top);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
}

- (void)drawBothArcWithContext:(CGContextRef)context rect:(CGRect)rect index:(NSInteger)index
{
    UIColor* color = [self getColorWithIndex:index];
    
    float left = rect.origin.x;
    float left_center = left + CORNRADIUS_INNER;
    float right = left + rect.size.width;
    float right_center = right - CORNRADIUS_INNER;
    float top = rect.origin.y;
    float top_center = top + CORNRADIUS_INNER;
    float bottom = top + rect.size.height;
    float bottom_center = bottom - CORNRADIUS_INNER;
    
    CGContextMoveToPoint(context, left, top_center);
    /* 左上 */
    CGContextAddArcToPoint(context, left, top, left_center, top, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, right_center, top);
    /* 右上 */
    CGContextAddArcToPoint(context, right, top, right, top_center, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, right, bottom_center);
    /* 右下 */
    CGContextAddArcToPoint(context, right, bottom, right_center, bottom, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, left_center, bottom);
    /* 左下 */
    CGContextAddArcToPoint(context, left, bottom, left, bottom_center, CORNRADIUS_INNER);
    CGContextAddLineToPoint(context, left, top_center);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
}

- (void)drawNoArcWithContext:(CGContextRef)context rect:(CGRect)rect index:(NSInteger)index
{
    UIColor* color = [self getColorWithIndex:index];
    
    CGContextAddRect(context, rect);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
}

@end
