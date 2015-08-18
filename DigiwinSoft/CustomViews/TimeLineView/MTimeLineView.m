//
//  MTimeLineView.m
//  DigiwinSoft
//if
//  Created by Jyun on 2015/8/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTimeLineView.h"
#import "MTimeLineAxis.h"

@interface MTimeLineView ()

@property (nonatomic, strong) MTimeLineAxis* axis;
@property (nonatomic, strong) UIView* arrowLeft;
@property (nonatomic, strong) UIView* arrowRight;

@end

@implementation MTimeLineView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        
        _startIndex = 0;
        
        [self initTimeLineAxis];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [self prepareTimeLineAxisWithData:dataArray];
    [self initArrowImageView];
}

- (void)initTimeLineAxis
{
    _axis = [[MTimeLineAxis alloc] initWithFrame:CGRectZero];
    _axis.backgroundColor = [UIColor clearColor];
    [self addSubview:_axis];
}

- (void)prepareTimeLineAxisWithData:(NSArray*)dataArray
{
    if(!_axis) return;
    
    CGFloat interval = self.frame.size.width / 10.;
    CGFloat width = interval * (dataArray.count +1);
    CGRect frame = CGRectMake(0, 0, width, self.frame.size.height);
    
    [_axis setFrame:frame];
    [_axis setEndIndex:0];
    [_axis setDateArray:dataArray];
    [_axis setInterval:interval];
    [_axis preparePoints];
    [_axis setNeedsDisplay];
    
    //修正 contentSize
    if(frame.size.width > self.frame.size.width)
        self.contentSize = _axis.frame.size;
}

- (void)initArrowImageView
{
    NSArray* points = [_axis points];
    if(points.count == 0)
        return;
    
    if(!_arrowLeft)
        _arrowLeft = [self addArrowImageWithName:@"icon_red_arrow_left.png" pointIndex:_startIndex];
    
    if(!_arrowRight){
        _arrowRight = [self addArrowImageWithName:@"icon_red_arrow_right.png" pointIndex:_startIndex];
        
        UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSinglePan:)];
        recognizer.maximumNumberOfTouches = 1;
        [_arrowRight addGestureRecognizer:recognizer];
    }
}

- (UIView*)addArrowImageWithName:(NSString*)name pointIndex:(NSInteger)index
{
    CGFloat interval = _axis.interval;
    NSArray* points = [_axis points];
    if(points.count == 0)
        return nil;
    
    MTLAxisPoint* point = [points objectAtIndex:index];
    
    CGRect frame = CGRectMake(0, 0, interval, self.frame.size.height);
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.center = CGPointMake(point.centerX, point.centerY);
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    
    CGFloat width = point.radius*4;
    CGFloat posX = point.centerX - width/2.;
    CGFloat posY = point.centerY + point.radius + 2.;
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, width)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:name];
    [view addSubview:imageView];
    
    return view;
}

- (void)handleSinglePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    CGPoint velocity = [recognizer velocityInView:self];
    NSLog(@"%.1f, %.1f", velocity.x, location.x);
    
    BOOL b = CGRectContainsPoint(self.bounds, location);
    if(!b)
        return;
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"begin");
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"changed");
        [self resetPointIndexWithLocation:location velocity:velocity];
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"end");
        
    }
}

- (void)resetPointIndexWithLocation:(CGPoint)location velocity:(CGPoint)velocity
{
    NSArray* points = [_axis points];
    if(points.count == 0)
        return;
    
    CGFloat interval = _axis.interval;
    NSInteger currentIndex = _axis.endIndex;
    MTLAxisPoint* start = [points objectAtIndex:0];
    
    // 向右滑
    if(velocity.x > 0){
        NSInteger index = (location.x - start.centerX) / interval;
        if(index > currentIndex){
            
            currentIndex = MIN(points.count-1, index);
            
            _endIndex = currentIndex;
            
            MTLAxisPoint* point = [points objectAtIndex:currentIndex];
            
            _arrowRight.center = CGPointMake(point.centerX, point.centerY);
            _axis.endIndex = currentIndex;
            [_axis setNeedsDisplay];
            
            if(_delegateTL && [_delegateTL respondsToSelector:@selector(timeLineView:didChangedIndex:)])
                [_delegateTL timeLineView:self didChangedIndex:currentIndex];
            
        }
    }
    
    // 向左滑
    if(velocity.x < 0){
        NSInteger index = (location.x - start.centerX) / interval;
        if(index < currentIndex){
            currentIndex = MAX(_startIndex, index);
            
            _endIndex = currentIndex;
            
            MTLAxisPoint* point = [points objectAtIndex:currentIndex];
            
            _arrowRight.center = CGPointMake(point.centerX, point.centerY);
            _axis.endIndex = currentIndex;
            [_axis setNeedsDisplay];
            
            if(_delegateTL && [_delegateTL respondsToSelector:@selector(timeLineView:didChangedIndex:)])
                [_delegateTL timeLineView:self didChangedIndex:currentIndex];
        }
    }
}


@end
