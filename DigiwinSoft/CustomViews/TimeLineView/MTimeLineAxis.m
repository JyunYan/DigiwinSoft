//
//  MTimeLineAxis.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTimeLineAxis.h"


@implementation MTLAxisPoint


@end


@interface MTimeLineAxis ()

@property (nonatomic, strong) UIView* arrowLeft;
@property (nonatomic, strong) UIView* arrowRight;
@property (nonatomic, strong) NSMutableArray* points;

@end

@implementation MTimeLineAxis

- (void)preparePoints
{
    if(!_points)
        _points = [NSMutableArray new];
    [_points removeAllObjects];
    
    CGFloat centerX = _interval / 2.;                            //圓心X
    CGFloat centerY = self.frame.size.height / 2.;                    //圓心Y
    CGFloat radius = MIN(self.frame.size.height, _interval)* 0.12;     //圓半徑
    
    for(int index = 0; index < _dateArray.count; index++){
        
        MTLAxisPoint* point = [MTLAxisPoint new];
        point.centerX = centerX;
        point.centerY = centerY;
        point.radius = radius;
        point.index = index;
        [_points addObject:point];
        
        centerX += _interval;
    }
}

- (NSArray*)points
{
    return _points;
}

- (void)drawRect:(CGRect)rect
{
    [self clean];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.4);
    
    NSInteger count = _points.count;
    for (int index=0; index<count; index++) {
        
        MTLAxisPoint* point = [_points objectAtIndex:index];
        
        //設定顏色
        UIColor* color = (index <= _endIndex) ? [UIColor colorWithRed:242.0f/255.0f green:97.0f/255.0f blue:95.0f/255.0f alpha:1.0f] : [UIColor grayColor];
        CGContextSetFillColorWithColor(context, color.CGColor);
        
        if(index != 0){
            // add矩形
            CGRect frame = [self calculRectangleRectReferPoint:point];
            CGContextAddRect(context, frame);
        }
        
        // add圓
        CGContextAddArc(context, point.centerX, point.centerY, point.radius, 0, M_PI*2, 0);
        CGContextFillPath(context);
        
        [self addMonthLabelWithIndex:index textColor:color];
        
    }
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)addMonthLabelWithIndex:(CGFloat)index textColor:(UIColor*)color
{
    CGFloat x = index * _interval;
    CGFloat y = self.frame.size.height * 0.25;
    CGFloat height = self.frame.size.height * 0.15;
    NSString* text = [self getMonthStringWithIndex:index];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, _interval, height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.text = text;
    [self addSubview:label];
    
    if([text isEqualToString:@"01"])
        [self addYearLabelWithIndex:index];
}

- (void)addYearLabelWithIndex:(CGFloat)index
{
    CGFloat x = index * _interval;
    CGFloat y = self.frame.size.height * 0.1;
    CGFloat height = self.frame.size.height * 0.15;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, _interval, height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = [self getYearStringWithIndex:index];
    [self addSubview:label];
}

- (NSString*)getMonthStringWithIndex:(CGFloat)index
{
    NSString* dateString = [_dateArray objectAtIndex:index];
    NSArray* array;
    if([dateString rangeOfString:@"-"].location != NSNotFound)
        array = [dateString componentsSeparatedByString:@"-"];
    else if ([dateString rangeOfString:@"/"].location != NSNotFound)
        array = [dateString componentsSeparatedByString:@"/"];
    
    if(array.count > 0)
        return [array objectAtIndex:1];
    return @"";
}

- (NSString*)getYearStringWithIndex:(CGFloat)index
{
    NSString* dateString = [_dateArray objectAtIndex:index];
    NSArray* array;
    if([dateString rangeOfString:@"-"].location != NSNotFound)
        array = [dateString componentsSeparatedByString:@"-"];
    else if ([dateString rangeOfString:@"/"].location != NSNotFound)
        array = [dateString componentsSeparatedByString:@"/"];
    
    if(array.count > 0)
        return [array objectAtIndex:0];
    return @"";
}

//計算每個圓之間的間距
- (CGFloat)calculateInterval
{
    UIView* view = self.superview;
    return view.frame.size.width / 10.;
}

//計算矩形rect
- (CGRect)calculRectangleRectReferPoint:(MTLAxisPoint*)point
{
    CGFloat offset = point.radius / 2.;
    CGFloat x = point.centerX - _interval + (point.radius + offset);
    CGFloat y = point.centerY - offset;
    CGFloat width = _interval - (point.radius + offset) * 2;
    CGFloat height = offset * 2;
    return CGRectMake(x, y, width, height);
}

@end
