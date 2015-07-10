//
//  MConcentricCircles.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MConcentricCircles.h"

@implementation MConcentricCircles

- (void)drawRect:(CGRect)rect {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    CGContextSetLineWidth(context, 1.5);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    
    CGContextAddArc(context, rect.size.width/2., rect.size.height/2., rect.size.width/2. - 2., 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    
    CGContextAddArc(context, rect.size.width/2., rect.size.height/2., _innerRadius, 0, M_PI * 2, 0);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillPath(context);
}

@end
