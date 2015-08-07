//
//  MTimeLineAxis.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTimeLineAxis.h"

@implementation MTimeLineAxis

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.4);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    CGFloat centerX = 24.;  //圓心X
    CGFloat centerY = rect.size.height / 2.;    //圓心Y
    CGFloat radius = 4.;    //圓半徑
    CGFloat interval = 30;   //每個圓的間隔
    
    for (int index=0; index<30; index++) {
        CGContextAddArc(context, centerX, centerY, radius, 0, M_PI*2, 0);
        
        centerX += interval;
    }
    
    CGContextFillPath(context);
    
    if(_delegate && [_delegate respondsToSelector:@selector(timeLineAxisDidDrawed:)]){
        self.frame = CGRectMake(0, 0, centerX+24., 100);
        [_delegate timeLineAxisDidDrawed:self];
    }
}

@end
