//
//  MDashLine2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MDashLine2.h"

@implementation MDashLine2

- (id)init
{
    if(self = [super init]){
        
        self.backgroundColor = [UIColor whiteColor];
        
        _type = TYPE_VERTICAL;
        _lineColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
       
        self.backgroundColor = [UIColor clearColor];
        
        _type = TYPE_VERTICAL;
        _lineColor = [UIColor grayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat dashPhase[]={6, 3};
    CGPoint start = [self getStartPoint];
    CGPoint end = [self getEndPoint];
    
    CGContextSetLineDash(context,0,dashPhase,2);
    CGContextSetLineWidth(context, 1.4);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextStrokePath(context);
}

- (CGPoint)getStartPoint
{
    if(_type == TYPE_VERTICAL)
        return CGPointMake(self.frame.size.width*0.5, 0);
    else
        return CGPointMake(0, self.frame.size.height*0.5);
}

- (CGPoint)getEndPoint
{
    if(_type == TYPE_VERTICAL)
        return CGPointMake(self.frame.size.width*0.5, self.frame.size.height);
    else
        return CGPointMake(self.frame.size.width, self.frame.size.height*0.5);
}

@end
