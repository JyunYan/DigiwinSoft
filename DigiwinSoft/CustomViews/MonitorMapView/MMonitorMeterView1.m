//
//  MMonitorMeterView1.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMeterView1.h"
#import "MDirector.h"
#import "MMeterView.h"
#import "MDashLine2.h"
#import "MIssue.h"

@interface MMonitorMeterView1 ()

@property (nonatomic, assign) BOOL ready;
@property (nonatomic, strong) MMeterView* metterView;
@property (nonatomic, strong) UILabel* diffLabel;
@property (nonatomic, strong) UILabel* totalLabel;

@property (nonatomic, strong) NSMutableArray* points;

@end

@implementation MMonitorMeterView1

- (id)init
{
    if(self = [super init]){
        _points = [NSMutableArray new];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        _points = [NSMutableArray new];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self addMeterView];
    [self drawConnectLineWithContext:context];
    
    [self addEarningsLabel];
    [self addEarningsDashLine];
    //[self drawEarningsConnectLineWithContext:context];
}

- (void)drawConnectLineWithContext:(CGContextRef)context
{
    NSInteger count = _points.count;
    for (int index=0; index<count; index++) {
        CGPoint start = [_metterView getPointWithIndex:index];
        CGPoint end = [[_points objectAtIndex:index] CGPointValue];
        CGFloat centerY = start.y + (end.y - start.y)/2.;
        UIColor* color = [self getColorWithIndex:index];
        
        CGContextSetLineWidth(context, 1.4);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGContextMoveToPoint(context, start.x, start.y);
        CGContextAddLineToPoint(context, start.x, centerY);
        CGContextAddLineToPoint(context, end.x, centerY);
        CGContextAddLineToPoint(context, end.x, end.y);
        CGContextStrokePath(context);
    }
}

- (void)addEarningsDashLine
{
    CGPoint point = _metterView.endPoint;
    CGFloat height = _metterView.frame.size.height + 36;
    
    MDashLine2* line = [[MDashLine2 alloc] initWithFrame:CGRectMake(0, 0, 4, height)];
    line.center = CGPointMake(point.x, _metterView.center.y);
    line.lineColor = [UIColor redColor];
    [self addSubview:line];
    
    
    //修正 totalLabel.frame
    CGFloat right = line.center.x + _totalLabel.frame.size.width / 2.;
    if(right > self.frame.size.width)
        _totalLabel.center = CGPointMake(self.frame.size.width - _totalLabel.frame.size.width / 2.,
                                         _totalLabel.center.y);
    else
        _totalLabel.center = CGPointMake(point.x, _totalLabel.center.y);
    
}

- (void)addEarningsLabel
{
    UIColor* color = [UIColor redColor];
    NSString* text = [NSString stringWithFormat:@"%@ : $ %ld", NSLocalizedString(@"現在值", @"現在值"), (long)[self calculateEarnings]];
    CGSize size = [self calculateSizeWithText:text];
    CGFloat posY = self.frame.size.height * 0.2;
    
    _totalLabel = [self createLabelWithFrame:CGRectMake(0, posY, size.width, size.height) textColor:color text:text];
    [self addSubview:_totalLabel];
}

//計量表
- (void)addMeterView
{
    CGFloat posX = self.frame.size.width * 0.02;
    CGFloat posY = self.frame.size.height * 0.4;
    CGFloat width = self.frame.size.width - posX*2;
    
    _metterView = [self createMeterViewWithFrame:CGRectMake(posX, posY, width, width*0.1)];
    [self addSubview:_metterView];
    
    posY += _metterView.frame.size.height + 20.;
    
    // 議題info
    UIView* view = [self createDescViewWithFrame:CGRectMake(0, posY, self.frame.size.width, 30)];
    [self addSubview:view];
    
    posY = _metterView.frame.origin.y - 20;
    
    // 差額
    _diffLabel = [self createDifferenceLabelWithFrame:CGRectMake(posX+6, posY, width-12, 20)];
    [self addSubview:_diffLabel];
}

// 差額label
- (UILabel*)createDifferenceLabelWithFrame:(CGRect)frame
{
    UIColor* color = [[MDirector sharedInstance] getCustomGrayColor];
    NSString* text = [NSString stringWithFormat:@"$ %ld", (long)[self calculateDiffence]];
    
    UILabel* label = [self createLabelWithFrame:frame textColor:color text:text];
    label.textAlignment = NSTextAlignmentRight;
    
    return label;
}

// 議題info
- (UIView*)createDescViewWithFrame:(CGRect)frame
{
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    [_points removeAllObjects];
    
    NSInteger count = _issueGroup.count;
    CGFloat gap = 4.;
    CGFloat posX = gap;
    CGFloat width = (self.frame.size.width - gap*(count+1))/count;
    CGFloat height = frame.size.height / 2.;
    
    for (int index = 0; index< count; index++) {
        MIssue* issue = [_issueGroup objectAtIndex:index];
        
        //收益
        UIColor* color = [self getColorWithIndex:index];
        NSString* text = [NSString stringWithFormat:@"$ %@", issue.gainR];
        UILabel* label1 = [self createLabelWithFrame:CGRectMake(posX, 0, width, height)
                                           textColor:color
                                                text:text];
        [view addSubview:label1];
        
        //議題name
        color = [[MDirector sharedInstance] getCustomGrayColor];
        UILabel* label2 = [self createLabelWithFrame:CGRectMake(posX, height, width, height)
                                           textColor:color
                                                text:issue.name];
        [view addSubview:label2];
        
        posX += gap + width;
        
        //save point
        CGPoint point = CGPointMake(label1.center.x, view.frame.origin.y);
        [_points addObject:[NSValue valueWithCGPoint:point]];
    }
    return view;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame textColor:(UIColor*)color text:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.text = text;
    return label;
}

- (MMeterView*)createMeterViewWithFrame:(CGRect)frame
{
    MMeterView* view = [[MMeterView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [view setIssueGroup:_issueGroup];
    
    return view;
}

- (UIColor*)getColorWithIndex:(NSInteger)index
{
    NSInteger value = index % 3;
    if(value == 1)
        return [[MDirector sharedInstance] getCustomBlueColor];
    else if(value == 2)
        return [[MDirector sharedInstance] getCustomOrangeColor];
    else
        return [[MDirector sharedInstance] getForestGreenColor];
}

//計算不足差額
- (NSInteger)calculateDiffence
{
    NSInteger total1 = 0;   //預計總收益
    NSInteger total2 = 0;   //實際總收益
    
    for (MIssue* issue in _issueGroup) {
        total1 += [issue.gainP integerValue];
        total2 += [issue.gainR integerValue];
    }
    
    return total1 - total2;
}

//計算總收益
- (NSInteger)calculateEarnings
{
    NSInteger total = 0;   //實際總收益
    
    for (MIssue* issue in _issueGroup) {
        total += [issue.gainR integerValue];
    }
    
    return total;
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
