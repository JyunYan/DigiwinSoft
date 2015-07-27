//
//  MChartRangeView.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MChartRangeView.h"

@implementation MChartRangeView

- (void)drawRect:(CGRect)rect {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    CGAffineTransform t0 = CGContextGetCTM(context);
    t0 = CGAffineTransformInvert(t0);
    CGContextConcatCTM(context, t0);
    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    
    /* 開始繪製矩形*/
    // 左矩形
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 139./255., 137./255., 137./255., 0.6);
    CGContextAddRect(context , CGRectMake(2, 0, rect.size.width*2/5 + 2, rect.size.height));
    CGContextClosePath(context);
    CGContextDrawPath(context,kCGPathFill);
    // 右矩形
    CGContextBeginPath(context);
    CGContextSetRGBFillColor(context, 139./255., 137./255., 137./255., 0.6);
    CGContextAddRect(context, CGRectMake(rect.size.width*3/5 + 3, 0, rect.size.width*2/5 + 2, rect.size.height));
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFill);
}

@end
