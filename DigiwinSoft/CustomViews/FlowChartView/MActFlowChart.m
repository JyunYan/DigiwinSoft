//
//  MActFlowChart.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MActFlowChart.h"

#define NUMBER_FOR_COLUMN   13
#define NUMBER_FOR_ROW      10

@interface MActFlowChart ()

@property (nonatomic,strong) NSMutableArray* unusedPoints;
@property (nonatomic,strong) NSMutableArray* points;
@property (nonatomic,strong) NSMutableArray* used;  //已決定位置的item
@property (nonatomic,strong) NSMutableArray* unused;//未決定位置的item

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat pointSize;

@end

@implementation MActFlowChart

- (void)setItems:(NSArray*)array
{
    if(!_used)
        _used = [NSMutableArray new];
    [_used removeAllObjects];
    
    if(!_unused)
        _unused = [NSMutableArray new];
    [_unused removeAllObjects];
    [_unused addObjectsFromArray:array];
    
    _pointSize = (DEVICE_SCREEN_WIDTH <= 320) ? 12. : 14.;
    
    [self preparePoints];
    [self findMainPath];
}

- (void)preparePoints
{
    if(!_points)
        _points = [NSMutableArray new];
    
    [_points removeAllObjects];
    
    CGFloat gapX = self.frame.size.width / NUMBER_FOR_COLUMN;
    CGFloat gapY = self.frame.size.height / NUMBER_FOR_ROW;
    
    NSInteger count = NUMBER_FOR_COLUMN * NUMBER_FOR_ROW;
    for (int i=0; i<count; i++) {
        
        CGFloat x = gapX + (i%NUMBER_FOR_COLUMN)*gapX;
        CGFloat y = gapY + (i/NUMBER_FOR_COLUMN)*gapY;
        
        MFlowChartPoint2* point = [MFlowChartPoint2 new];
        point.index = i;
        point.coordinate = CGPointMake(x, y);
        
        [_points addObject:point];
    }
}

- (void)findMainPath
{
    // if 沒有item
    if(_unused.count == 0)
        return;
    
    // if 只有一個item
    if(_unused.count == 1){
        MCustActivity* activity = [_unused firstObject];
        [self setItem:activity atIndex:13 arrowDirection:ARROW_DIRECTION_NONE];
        [_used addObject:activity];
        [_unused removeAllObjects];
        return;
    }
    
    // 先取得主線 items (最多6層)
    MCustActivity* activity = nil;
    NSInteger index = NUMBER_FOR_COLUMN;
    while (index < NUMBER_FOR_COLUMN*2) {
        MCustActivity* next = [self getNextNodeByItem:activity];
        if(next){
            [self setItem:next atIndex:index arrowDirection:ARROW_DIRECTION_RIGHT]; // 把主線item放在位置13,15,17,19,21,23
            [_used addObject:next];
            [_unused removeObject:next];
            activity = next;
        }else{
            //把終點的arrow拿掉
            MFlowChartPoint2* point = [_points objectAtIndex:index - 2];
            point = [_points objectAtIndex:point.arrowIndex];
            point.type = TYPE_FOR_NONE;
            point.arrowDirection = ARROW_DIRECTION_NONE;
            break;
        }
        index += 2;
    }
    
    // 根據主線的每個item,檢查是否有分支(這邊要反推回去)
    NSInteger count = _used.count;
    for(int i=0; i<count; i++){
        MCustActivity* item = [_used objectAtIndex:i];
        [self findSubPathWithReferItem:item];
    }
    
    // set title loaction
    [self setTitlePoints];
}

// 每個主線item分支上游(這邊要反推回去)
- (void)findSubPathWithReferItem:(MCustActivity*)activity
{
    MCustActivity* act = activity;
    while (true) {
        MCustActivity* prev = [self getPrevNodeByItem:act];
        if(prev){
            NSInteger index = [self indexOfItem:act];
            [self setItem:prev referIndex:index];
            [_used addObject:prev];
            [_unused removeObject:prev];
            act = prev;
        }else{
            break;
        }
    }
}

// item所在的index
- (NSInteger)indexOfItem:(MCustActivity*)activity
{
    NSString* uuid = activity.uuid;
    for (MFlowChartPoint2* point in _points) {
        if([point.activity.uuid isEqualToString:uuid])
            return point.index;
    }
    return -1;
}

- (void)setTitlePoints
{
    for (NSInteger index = 0; index < _points.count; index++) {
        MFlowChartPoint2* point = [_points objectAtIndex:index];
        if(point.type == TYPE_FOR_ITEM){
            NSString* title = point.activity.name;
            
            //先查看上面
            MFlowChartPoint2* point2 = [_points objectAtIndex:index - NUMBER_FOR_COLUMN];
            if(point2.type == TYPE_FOR_NONE){
                point2.type = TYPE_FOR_DESC;
                point2.title = title;
                continue;
            }
            
            // 再看下
            point2 = [_points objectAtIndex:index + NUMBER_FOR_COLUMN];
            if(point2.type == TYPE_FOR_NONE){
                point2.type = TYPE_FOR_DESC;
                point2.title = title;
                continue;
            }
            
            // 在看右
            point2 = [_points objectAtIndex:index + 1];
            if(point2.type == TYPE_FOR_NONE){
                point2.type = TYPE_FOR_DESC;
                point2.title = title;
                continue;
            }
        }
    }
}

// 指定item到位置index
- (void)setItem:(MCustActivity*)activity atIndex:(NSInteger)index arrowDirection:(NSInteger)direction
{
    // set item location
    MFlowChartPoint2* point = [_points objectAtIndex:index];
    point.activity = activity;
    point.type = TYPE_FOR_ITEM;
    
    // set arrow location
    NSInteger arrowIndex = 0;
    if(direction == ARROW_DIRECTION_RIGHT){
        MFlowChartPoint2* point2 = [_points objectAtIndex:index+1];
        point2.arrowDirection = direction;
        point2.type = TYPE_FOR_ARROW;
        arrowIndex = index+1;
    }else if(direction == ARROW_DIRECTION_LEFT){
        MFlowChartPoint2* point2 = [_points objectAtIndex:index-1];
        point2.arrowDirection = direction;
        point2.type = TYPE_FOR_ARROW;
        arrowIndex = index-1;
    }else if(direction == ARROW_DIRECTION_UP){
        MFlowChartPoint2* point2 = [_points objectAtIndex:index-NUMBER_FOR_COLUMN];
        point2.arrowDirection = direction;
        point2.type = TYPE_FOR_ARROW;
        arrowIndex = index-NUMBER_FOR_COLUMN;
    }else if(direction == ARROW_DIRECTION_DOWN){
        MFlowChartPoint2* point2 = [_points objectAtIndex:index+NUMBER_FOR_COLUMN];
        point2.arrowDirection = direction;
        point2.type = TYPE_FOR_ARROW;
        arrowIndex = index+NUMBER_FOR_COLUMN;
    }
    
    point.arrowIndex = arrowIndex;
}

// 參照index指定item的合理位置
- (void)setItem:(MCustActivity*)activity referIndex:(NSInteger)index
{
    //不可超出points範圍
    if(index >= _points.count || index < 0)
        return;
    
    //先查看左邊
    if(index%NUMBER_FOR_COLUMN != 0 && index >= (13 + 2)){
        NSInteger left = index - 2;
        MFlowChartPoint2* point = [_points objectAtIndex:left];
        if(point.type == TYPE_FOR_NONE){
            [self setItem:activity atIndex:left arrowDirection:ARROW_DIRECTION_RIGHT];
            return;
        }
    }
    
    //再往下
    NSInteger down = index + NUMBER_FOR_COLUMN*2;
    if(down < (_points.count - NUMBER_FOR_COLUMN*2)){
        MFlowChartPoint2* point = [_points objectAtIndex:down];
        if(point.type == TYPE_FOR_NONE){
            [self setItem:activity atIndex:down arrowDirection:ARROW_DIRECTION_UP];
            return;
        }
    }
    
    //再往右
    if(index%NUMBER_FOR_COLUMN != 12 && index < (_points.count - 26 - 2)){
        NSInteger right = index + 2;
        MFlowChartPoint2* point = [_points objectAtIndex:right];
        if(point.type == TYPE_FOR_NONE){
            [self setItem:activity atIndex:down arrowDirection:ARROW_DIRECTION_LEFT];
            return;
        }
    }
    
    //在往上
    NSInteger up = index - NUMBER_FOR_COLUMN;
    if(up >= 13){
        MFlowChartPoint2* point = [_points objectAtIndex:up];
        if(point.type == TYPE_FOR_NONE){
            [self setItem:activity atIndex:down arrowDirection:ARROW_DIRECTION_DOWN];
            return;
        }
    }
}

//取得上一個item
- (MCustActivity*)getPrevNodeByItem:(MCustActivity*)activity
{
    NSString* prev = activity.previos2;
    if(!prev || [prev isEqualToString:@""])
        return nil;
    
    for (MCustActivity* act in _unused) {
        if([prev isEqualToString:act.uuid])
            return act;
    }
    return nil;
}

//取得下一個item
- (MCustActivity*)getNextNodeByItem:(MCustActivity*)activity
{
    NSString* uuid = activity.uuid;
    for (MCustActivity* act in _unused) {
        if([act.previos1 isEqualToString:@"none"]) // start
            return act;
        else if([uuid isEqualToString:act.previos1])
            return act;
    }
    return nil;
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self clean];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
    //    CGFloat scale = [[UIScreen mainScreen] scale];
    //    CGAffineTransform t0 = CGContextGetCTM(context);
    //    t0 = CGAffineTransformInvert(t0);
    //    CGContextConcatCTM(context, t0);
    //    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    
    // 先畫路線
    [self drawAllArrowsWithContext:context];
    
    NSInteger index = 0;
    CGFloat raidus = rect.size.width / NUMBER_FOR_COLUMN * 0.25;
    for (MFlowChartPoint2* point in _points) {
        if(point.type == TYPE_FOR_ITEM) {
            // draw 圓
            CGContextSetLineWidth(context, 1.5);
            
            CGContextAddArc(context, point.coordinate.x, point.coordinate.y, raidus, 0, M_PI * 2, 0);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillPath(context);
            
            CGContextAddArc(context, point.coordinate.x, point.coordinate.y, raidus, 0, M_PI * 2, 0);
            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            CGContextStrokePath(context);
            
            CGContextClosePath(context);
            
            [self addTapViewWithPoint:point];
            
        }
        if(point.type == TYPE_FOR_DESC){
            // add text label
            [self addLabelWithPoint:point];
        }
        index++;
    }
}

- (void)drawAllArrowsWithContext:(CGContextRef)context
{
    NSInteger index = 0;
    for (MFlowChartPoint2* point in _points) {
        if(point.type == TYPE_FOR_ARROW){
            // draw arrow
            [self drawArrowWithContext:context index:index direction:point.arrowDirection];
        }
        index++;
    }
}

- (void)drawArrowWithContext:(CGContextRef)context index:(NSInteger)index direction:(NSInteger)direct
{
    CGFloat gapLH = self.bounds.size.width / NUMBER_FOR_COLUMN;
    CGFloat gapLV = self.bounds.size.height / NUMBER_FOR_ROW;
    CGFloat gapWide = gapLH * 0.2 / 2.;
    
    MFlowChartPoint2* point = [_points objectAtIndex:index];
    if(direct == ARROW_DIRECTION_UP){
        // draw line
        CGRect rect = CGRectMake(point.coordinate.x - gapWide, point.coordinate.y - gapLV, gapWide*2, gapLV*2);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, rect);
        
        // draw white arrow
        //CGContextSetLineWidth(context, 2.);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x + gapWide, point.coordinate.y + gapWide);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x - gapWide, point.coordinate.y + gapWide);
        CGContextStrokePath(context);
    }else if(direct == ARROW_DIRECTION_DOWN){
        // draw line
        CGRect rect = CGRectMake(point.coordinate.x - gapWide, point.coordinate.y - gapLV, gapWide*2, gapLV*2);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, rect);
        
        // draw white arrow
        //CGContextSetLineWidth(context, 2.);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x + gapWide, point.coordinate.y - gapWide);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x - gapWide, point.coordinate.y - gapWide);
        CGContextStrokePath(context);
    }else if(direct == ARROW_DIRECTION_LEFT){
        // draw line
        CGRect rect = CGRectMake(point.coordinate.x - gapLH, point.coordinate.y - gapWide, gapLH*2, gapWide*2);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, rect);
        
        // draw white arrow
        //CGContextSetLineWidth(context, 2.);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x + gapWide, point.coordinate.y - gapWide);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x + gapWide, point.coordinate.y + gapWide);
        CGContextStrokePath(context);
    }else if(direct == ARROW_DIRECTION_RIGHT){
        // draw line
        CGRect rect = CGRectMake(point.coordinate.x - gapLH, point.coordinate.y - gapWide, gapLH*2, gapWide*2);
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, rect);
        
        // draw white arrow
        //CGContextSetLineWidth(context, 2.);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x - gapWide, point.coordinate.y + gapWide);
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x - gapWide, point.coordinate.y - gapWide);
        CGContextStrokePath(context);
    }
    
    CGContextClosePath(context);
}

- (void)addTapViewWithPoint:(MFlowChartPoint2*)point
{
    CGFloat side = MIN(self.frame.size.width/NUMBER_FOR_COLUMN, self.frame.size.height/NUMBER_FOR_ROW);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, side*1.8, side*1.8)];
    view.center = CGPointMake(point.coordinate.x, point.coordinate.y);
    view.tag = point.index;
    //view.backgroundColor = [UIColor redColor];
    //view.alpha = 0.3;
    [self addSubview:view];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [view addGestureRecognizer:recognizer];
}

- (void)addLabelWithPoint:(MFlowChartPoint2*)point
{
    CGFloat gapLH = self.bounds.size.width / NUMBER_FOR_COLUMN;
    CGFloat gapLV = self.bounds.size.height / NUMBER_FOR_ROW;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, gapLH*2*0.9, gapLV*2*0.9)];
    label.center = CGPointMake(point.coordinate.x, point.coordinate.y);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 3;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont boldSystemFontOfSize:10.];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = point.title;
    
    [self addSubview:label];
}

#pragma mark - UITapGestureRecognizer actions

- (void)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    NSInteger index = recognizer.view.tag;
    MFlowChartPoint2* point = [_points objectAtIndex:index];
    
    if(_delegate && [_delegate respondsToSelector:@selector(actFlowChart:didSelectedActivity:)])
        [_delegate actFlowChart:self didSelectedActivity:point.activity];
    
    NSLog(@"xxx");
}

@end
