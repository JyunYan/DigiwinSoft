//
//  MTraceLineView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/19.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTraceLineView.h"

@implementation MTraceLineView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
//    CGContextAddRect(context, rect);
//    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
}

@end
