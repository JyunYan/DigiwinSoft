//
//  MGanttDashView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttDashView.h"
#import "MConfig.h"
#import "MDirector.h"
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
    
    //chang backgroundColor for the new year
    BOOL bChang = NO;
    while (x <= rect.size.width) {
        CGRect topRect = CGRectMake(x, 0, _interval, rect.size.height);
        for (NSNumber *changX in _aryChangColorX) {
            if ([changX floatValue]==x) {
                bChang=!bChang;
            }
        }
        
        if (bChang) {
            _ChangColor=[[[MDirector sharedInstance] getCustomRedColor] colorWithAlphaComponent:0.3];
        }
        else
        {
            _ChangColor=[[[MDirector sharedInstance] getCustomBlueColor] colorWithAlphaComponent:0.3];
        }
        
        
        [_ChangColor setFill];
        UIRectFill( topRect );
        x += _interval;
    }
    
    //dotted line
    x = 0.;
    while (x <= rect.size.width) {
        CGContextMoveToPoint(cont, x, 0.);    //开始画线
        CGContextAddLineToPoint(cont, x, rect.size.height);
        x += _interval;
        }
    
    CGContextStrokePath(cont);
    
  
}

@end
