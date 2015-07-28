//
//  MMessageBox.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/10.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMessageBox.h"

@implementation MMessageBox

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
    
    CGFloat x = rect.size.width/2.;
    CGFloat y = 0.;
    
    /* "\" */
    CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x-2., y+4);
    
    x-=2;
    y+=4;
    
    /* "一" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, 1.5, y);
    
    x = 1.5;
    
    /* "|" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x, rect.size.height -1.5);
    
    y = rect.size.height - 1.5;
    
    /* "一" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, rect.size.width-1.5, y);
    
    x = rect.size.width-1.5;
    
    /* "|" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x, 4);
    
    y = 4.;
    
    /* "一" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, rect.size.width/2.+2., y);
    
    x = rect.size.width/2.+2;
    
    /* "/" */
    //CGContextMoveToPoint(context, x, y);
    CGContextAddLineToPoint(context, x-2., y-4.);
    
    //CGContextAddArc(context, rect.size.width/2., rect.size.height/2., rect.size.width/2. - 2., 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    
    [self addTextLabel];
}

- (void)setTopText:(NSString *)topText
{
    _topText = topText;
    
    if(_textLabel)
        _textLabel.text = topText;
}

- (void)addTextLabel
{
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 4)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor redColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:12.];
    _textLabel.text = _topText;
    [self addSubview:_textLabel];
}

@end
