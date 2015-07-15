//
//  MFlowChartView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MFlowChartView.h"

#define NUMBER_FOR_COLUMN   6
#define NUMBER_FOR_ROW      4

@interface MFlowChartView ()

@property (nonatomic,strong) NSMutableArray* points;
@property (nonatomic,strong) NSMutableArray* used;
@property (nonatomic,strong) NSMutableArray* unused;

@property (nonatomic, assign) CGFloat radius;

@end

@implementation MFlowChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    self.frame = frame;
//}

- (void)setItems:(NSArray*)array
{
    if(!_used)
        _used = [NSMutableArray new];
    [_used removeAllObjects];
    
    if(!_unused)
        _unused = [NSMutableArray new];
    [_unused removeAllObjects];
    [_unused addObjectsFromArray:array];
    
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
    CGFloat x = gapX / 2.;
    CGFloat y = gapY / 2.;
    
    // 6x4, 最多24個
    NSInteger count = NUMBER_FOR_COLUMN * NUMBER_FOR_ROW;
    for (int i=0; i<count; i++) {
        
        x = gapX/2. + (i%NUMBER_FOR_COLUMN)*gapX;
        y = gapY/2. + (i/NUMBER_FOR_COLUMN)*gapY;
        
        MFlowChartPoint* point = [MFlowChartPoint new];
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
        MActivity* activity = [_unused firstObject];
        [self setItem:activity atIndex:0 arrowDirection:ARROW_DIRECTION_NONE];
        [_used addObject:activity];
        [_unused removeAllObjects];
        return;
    }
    
    // 先取得主線 items (最多6層)
    MActivity* act = nil;
    NSInteger index = 0;
    while (index < NUMBER_FOR_COLUMN) {
        MActivity* next = [self getNextNodeByItem:act];
        if(next){
            [self setItem:next atIndex:index arrowDirection:ARROW_DIRECTION_RIGHT]; // 把主線item放在位置0~5
            [_used addObject:next];
            [_unused removeObject:next];
            act = next;
        }else{
            [self setItem:act atIndex:index - 1 arrowDirection:ARROW_DIRECTION_NONE];   //把終點的arrow拿掉
            break;
        }
        index ++;
    }
    
    // 根據主線的每個item,檢查是否有分支(這邊要反推回去)
    NSInteger count = _used.count;
    for(int i=0; i<count; i++){
        MActivity* act = [_used objectAtIndex:i];
        [self findSubPathWithReferItem:act];
    }
}

// 每個主線item分支上游(這邊要反推回去)
- (void)findSubPathWithReferItem:(MActivity*)activity
{
    MActivity* act = activity;
    while (true) {
        MActivity* prev = [self getPrevNodeByItem:act];
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
- (NSInteger)indexOfItem:(MActivity*)activity
{
    NSString* uuid = activity.uuid;
    for (MFlowChartPoint* point in _points) {
        if([point.activity.uuid isEqualToString:uuid])
        return point.index;
    }
    return -1;
}

// 指定item到位置index
- (void)setItem:(MActivity*)act atIndex:(NSInteger)index arrowDirection:(NSInteger)direction
{
    MFlowChartPoint* point = [_points objectAtIndex:index];
    point.activity = act;
    point.arrowDirection = direction;
}

// 參照index指定item的合理位置
- (void)setItem:(MActivity*)act referIndex:(NSInteger)index
{
    //不可超出points範圍
    if(index >= _points.count || index < 0)
        return;
    
    //先查看左邊
    if(index%NUMBER_FOR_COLUMN != 0 && index > 1){
        NSInteger left = index - 1;
        MFlowChartPoint* point = [_points objectAtIndex:left];
        if(point.activity == nil){
            point.activity = act;
            point.arrowDirection = ARROW_DIRECTION_RIGHT;
            return;
        }
    }
    
    //再往下
    NSInteger down = index + NUMBER_FOR_COLUMN;
    if(down < _points.count){
        MFlowChartPoint* point = [_points objectAtIndex:down];
        if(point.activity == nil){
            point.activity = act;
            point.arrowDirection = ARROW_DIRECTION_UP;
            return;
        }
    }
    
    //再往右
    if(index%NUMBER_FOR_COLUMN != 5 && index < (_points.count - 2)){
        NSInteger right = index + 1;
        MFlowChartPoint* point = [_points objectAtIndex:right];
        if(point.activity == nil){
            point.activity = act;
            point.arrowDirection = ARROW_DIRECTION_LEFT;
            return;
        }
    }
    
    //在往上
    NSInteger up = index - NUMBER_FOR_COLUMN;
    if(up >= 0){
        MFlowChartPoint* point = [_points objectAtIndex:up];
        if(point.activity == nil){
            point.activity = act;
            point.arrowDirection = ARROW_DIRECTION_DOWN;
            return;
        }
    }
}

//取得上一個item
- (MActivity*)getPrevNodeByItem:(MActivity*)activity
{
    NSString* prev = activity.previos2;
    if(!prev || [prev isEqualToString:@""])
        return nil;
    
    for (MActivity* act in _unused) {
        if([prev isEqualToString:act.uuid])
            return act;
    }
    return nil;
}

//取得下一個item
- (MActivity*)getNextNodeByItem:(MActivity*)activity
{
    NSString* uuid = activity.uuid;
    for (MActivity* act in _unused) {
        if([act.previos1 isEqualToString:@"none"]) // start
            return act;
        else if([uuid isEqualToString:act.previos1])
            return act;
    }
    return nil;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 取得目前轉換矩陣，將矩陣倒置後存到圖像內文中 */
//    CGFloat scale = [[UIScreen mainScreen] scale];
//    CGAffineTransform t0 = CGContextGetCTM(context);
//    t0 = CGAffineTransformInvert(t0);
//    CGContextConcatCTM(context, t0);
//    CGContextScaleCTM(context, scale, scale);   //轉完retina會取消, 所以要把倍數x回來
    
    CGContextSetLineWidth(context, 1.5);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    
    _radius = rect.size.width / NUMBER_FOR_COLUMN * 0.4;
    for (MFlowChartPoint* point in _points) {
        if(point.activity != nil){
            
            // draw 圓
            CGContextAddArc(context, point.coordinate.x, point.coordinate.y, _radius, 0, M_PI * 2, 0);
            CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextFillPath(context);
            
            // draw arrow
            [self drawArrowWithContext:context index:point.index direction:point.arrowDirection];
            
            // add text label
            [self addLabelWithPoint:point];
        }
    }
    
    
}

- (void)drawArrowWithContext:(CGContextRef)context index:(NSInteger)index direction:(NSInteger)direct
{
    CGFloat gap = self.bounds.size.width / NUMBER_FOR_COLUMN * 0.5;
    CGFloat de = self.bounds.size.width / NUMBER_FOR_COLUMN * 0.05;
    
    MFlowChartPoint* point = [_points objectAtIndex:index];
    
    if(direct == ARROW_DIRECTION_UP){
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y - gap - de);
        CGContextAddLineToPoint(context, point.coordinate.x - de*2, point.coordinate.y - gap + de);
        CGContextAddLineToPoint(context, point.coordinate.x + de*2, point.coordinate.y - gap + de);
    }else if(direct == ARROW_DIRECTION_DOWN){
        CGContextMoveToPoint(context, point.coordinate.x, point.coordinate.y + gap + de);
        CGContextAddLineToPoint(context, point.coordinate.x - de*2, point.coordinate.y + gap - de);
        CGContextAddLineToPoint(context, point.coordinate.x + de*2, point.coordinate.y + gap - de);
    }else if(direct == ARROW_DIRECTION_LEFT){
        CGContextMoveToPoint(context, point.coordinate.x - gap - de, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x - gap + de, point.coordinate.y - de*2);
        CGContextAddLineToPoint(context, point.coordinate.x - gap + de, point.coordinate.y + de*2);
    }else if(direct == ARROW_DIRECTION_RIGHT){
        CGContextMoveToPoint(context, point.coordinate.x + gap + de, point.coordinate.y);
        CGContextAddLineToPoint(context, point.coordinate.x + gap - de, point.coordinate.y - de*2);
        CGContextAddLineToPoint(context, point.coordinate.x + gap - de, point.coordinate.y + de*2);
    }
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextFillPath(context);
    
    //CGContextClosePath(context);
}

- (void)addLabelWithPoint:(MFlowChartPoint*)point
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _radius*1.2, _radius*1.4)];
    label.center = CGPointMake(point.coordinate.x, point.coordinate.y);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.text = point.activity.name;
    
    [self addSubview:label];
}

@end
