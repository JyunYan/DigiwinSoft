//
//  MMeterView2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMeterView2.h"
#import "MIssType.h"
#import "MDirector.h"

@interface MMeterView2 ()

@property (nonatomic, assign) NSInteger totalExpected;  //預期收益總額
@property (nonatomic, assign) NSInteger totalReal;      //實際收益總額

@property (nonatomic, assign) CGRect rect;  //實際上填滿的區塊

@end

@implementation MMeterView2

- (id)init
{
    if(self = [super init]){
        self.layer.borderWidth = 1.6;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = CORNRADIUS_OUTER;
        
        _totalExpected = 0;
        _totalReal = 0;
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
        
        _totalExpected = 0;
        _totalReal = 0;
        
        _rect = CGRectMake(frame.origin.x + 4, frame.origin.y + 4, frame.size.width - 8, frame.size.height - 8);
    }
    return self;
}

- (void)setIssue:(MIssue *)issue
{
    _issue = issue;
    [self calculateTotalEarnings];
    [self calculateEndPoint];
}

- (void)calculateTotalEarnings
{
    _totalExpected = 0;
    _totalReal = 0;
    
    NSArray* array = _issue.issTypeArray;
    for (MIssType* type in array) {
        _totalExpected += [type.gainP integerValue];
        _totalReal += [type.gainR integerValue];
    }
}

- (void)calculateEndPoint
{
    if(_totalExpected == 0){
        _endPoint = CGPointMake(_rect.origin.x, self.center.y);
        return;
    }
    
    CGFloat posX = _rect.origin.x;
    CGFloat width = _rect.size.width * _totalReal / _totalExpected;
    
    _endPoint = CGPointMake(posX + width , self.center.y);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    _rect = CGRectMake(rect.origin.x + 4, rect.origin.y + 4, rect.size.width - 8, rect.size.height - 8);
    [self fillRectWithContext:context];
    
}

- (void)fillRectWithContext:(CGContextRef)context
{
    if(_totalExpected == 0 || _totalReal == 0)
        return;
    
    CGFloat posX = _rect.origin.x;
    CGFloat width = _endPoint.x - posX;
    CGRect rect = CGRectMake(posX, _rect.origin.y, width, _rect.size.height);
    
    if(_totalReal == _totalExpected)
        [self drawBothArcWithContext:context rect:rect];
    else
        [self drawLeftArcWithContext:context rect:rect];
}

- (void)drawLeftArcWithContext:(CGContextRef)context rect:(CGRect)rect
{
    UIColor* color = [[MDirector sharedInstance] getCustomBlueColor];
    
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

- (void)drawBothArcWithContext:(CGContextRef)context rect:(CGRect)rect
{
    UIColor* color = [[MDirector sharedInstance] getCustomBlueColor];
    
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

@end
