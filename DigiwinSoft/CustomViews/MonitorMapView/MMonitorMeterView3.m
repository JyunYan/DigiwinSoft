//
//  MMonitorMeterView3.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMeterView3.h"
#import "MDirector.h"

@interface MMonitorMeterView3 ()

@property (nonatomic, assign) CGRect meterRect;
@property (nonatomic, assign) CGFloat endX;

@end

@implementation MMonitorMeterView3

- (id)init
{
    if(self = [super init]){
        self.backgroundColor = [[MDirector sharedInstance] getCustomLightestGrayColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[MDirector sharedInstance] getCustomLightestGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawMeterOnCenterOfRect:rect context:context];
    [self addNameLabel];
    [self addEarningsLabel];
    [self addBottomLabel];
}

- (void)drawMeterOnCenterOfRect:(CGRect)rect context:(CGContextRef)context
{
    //meter outer
    CGFloat outerX = rect.size.width * 0.05;
    CGFloat outerW = rect.size.width - outerX*2;
    CGFloat outerH = rect.size.width * 0.05;
    CGFloat outerY = (rect.size.height - outerH)/2.;
    
    _meterRect = CGRectMake(outerX, outerY, outerW, outerH);
    
    UIColor* color1 = [[MDirector sharedInstance] getCustomLightGrayColor];
    
    CGContextSetFillColorWithColor(context, color1.CGColor);
    CGContextAddRect(context, _meterRect);
    CGContextFillPath(context);
    
    if([_issType.gainP integerValue] == 0)
        return;
    
    //meter inner
    CGFloat innerX = outerX + 4.;
    CGFloat innerW = (outerW - innerX*2) * [_issType.gainR integerValue] / [_issType.gainP integerValue];
    CGFloat innerH = outerH* 0.6;
    CGFloat innerY = outerY + (outerH - innerH)/2.;
    
    UIColor* color2 = [[MDirector sharedInstance] getCustomRedColor];
    
    CGContextSetFillColorWithColor(context, color2.CGColor);
    CGContextAddRect(context, CGRectMake(innerX, innerY, innerW, innerH));
    CGContextFillPath(context);
    
    _endX = innerX + innerW;
}

- (void)addBottomLabel
{
    CGRect frame = CGRectMake(_meterRect.origin.x, _meterRect.origin.y + _meterRect.size.height, _meterRect.size.width, 20);
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"$ %@", _issType.gainP];
    [self addSubview:label];
}

- (void)addNameLabel
{
    CGRect frame = CGRectMake(_meterRect.origin.x, _meterRect.size.width * 0.016, _meterRect.size.width, 20);
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textColor = [UIColor blackColor];
    label.text = _issType.name;
    [self addSubview:label];
}

- (void)addEarningsLabel
{
    NSString* text = [NSString stringWithFormat:@"$ %@", _issType.gainR];
    
    CGSize size = [self calculateSizeWithText:text];
    CGRect frame = CGRectMake(_meterRect.origin.x, _meterRect.origin.y - size.height, size.width, size.height);
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textColor = [[MDirector sharedInstance] getCustomRedColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [self addSubview:label];
    
    // 修正frame
    CGFloat left = _endX - label.frame.size.width / 2.;
    CGFloat left_limit = _meterRect.origin.x;
    CGFloat right = _endX + label.frame.size.width / 2.;
    CGFloat right_limit = _meterRect.origin.x + _meterRect.size.width;
    
    if(left < left_limit)
        label.frame = CGRectMake(left_limit, label.frame.origin.y, size.width, size.height);
    else if(right > right_limit)
        label.frame = CGRectMake(right_limit - size.width, label.frame.origin.y, size.width, size.height);
    else
        label.center = CGPointMake(_endX, label.center.y);
}

- (CGSize)calculateSizeWithText:(NSString*)text
{
    CGSize maxSize = CGSizeMake(self.frame.size.width, 20);
    UIFont* font = [UIFont systemFontOfSize:12.];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dict
                                     context:nil].size;
    return size;
}


@end
