//
//  MGanttDashView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttDashView.h"

@implementation MGanttDashView

- (void)drawRect:(CGRect)rect
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(cont, 1);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(cont, 0, lengths, 2);  //画虚线
    CGContextBeginPath(cont);
    
    CGFloat x = 0.;
    
    while (x <= rect.size.width) {
        CGContextMoveToPoint(cont, x, 0.);    //开始画线
        CGContextAddLineToPoint(cont, x, rect.size.height);
        x += _interval;
    }
    
    CGContextStrokePath(cont);
}

@end
