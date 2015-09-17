//
//  MTarChartView2.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarChartView2.h"
#import "MDirector.h"
#import "MLineChartView2.h"

@interface MTarChartView2 ()

@property (nonatomic) UIColor* blueColor;
@property (nonatomic) UIColor* grayColor;
@property (nonatomic) UIColor* darkGrayColor;

@property (nonatomic, strong) UIScrollView* scroll;
@property (nonatomic, strong) UIView* rangeView;

@end

@implementation MTarChartView2

-(id)init
{
    if(self = [super init]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];

        _dataIndex = 0;
        _rangeIndex = 2;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
        _dataIndex = 0;
        _rangeIndex = 2;
    }
    return self;
}

- (void)setHistorys:(NSArray *)historys
{
    if(historys.count == 0)
        return;
    
    //依照年份分類
    MTarget* tar = [historys firstObject];
    NSString* year = [tar.datetime substringToIndex:4];
    NSMutableArray* all = [NSMutableArray new];
    NSMutableArray* array = [NSMutableArray new];
    for (MTarget* target in historys) {
        
        if(![target.datetime hasPrefix:year]){
            
            //不足12個月的資料必須補齊
            NSMutableArray* arr = [self completeDataWithArray:array];
            [all addObject:arr];
            
            array = [NSMutableArray new];
            year = [target.datetime substringToIndex:4];
        }
        [array addObject:target];
    }
    
    //最後一年記得加進去
    NSArray* arr = [self completeDataWithArray:array];
    [all addObject:arr];
    
    //範圍是每年1月~隔年1月,共13個月,所以要再補一個月
    NSInteger index = 0;
    for (NSMutableArray* array in all) {
        NSInteger next = index + 1;
        if(next < all.count){
            NSMutableArray* nextArr = [all objectAtIndex:next];
            MTarget* target = [nextArr firstObject];
            [array addObject:target];
        }else if(next == all.count){
            
            MTarget* tar2 = [array firstObject];
            NSInteger year2 = [[tar2.datetime substringToIndex:4] integerValue];
            year2 += 1;
            
            MTarget* target = [MTarget new];
            target.unit = tar.unit;
            target.datetime = [NSString stringWithFormat:@"%04d-01-01", (int)year2];
            [array addObject:target];
        }
        index = next;
    }
    
    _historys = all;
    _dataIndex = all.count - 1;
    _rangeIndex = MIN(2, _dataIndex);
    
    if(_delegate && [_delegate respondsToSelector:@selector(designatedChartDidChanged:)])
        [_delegate designatedChartDidChanged:self];
}

- (NSMutableArray*)completeDataWithArray:(NSMutableArray*)array
{
    if(array.count == 0)
        return array;
    if(array.count >= 12)
        return array;
    
    MTarget* target = [array firstObject];
    NSString* unit = target.unit;
    NSString* year = [target.datetime substringToIndex:4];
    NSInteger month = 1;
    NSMutableArray* arr = [NSMutableArray new];
    while (arr.count < 12) {
        BOOL exist = NO;
        NSString* datetime = [NSString stringWithFormat:@"%@-%02d-01", year, (int)month];
        
        for (MTarget* target in array) {
            
            if([target.datetime isEqualToString:datetime]){
                [arr addObject:target];
                exist = YES;
                break;
            }
        }
        
        if(!exist){
            MTarget* target = [MTarget new];
            target.unit = unit;
            target.datetime = datetime;
            [arr addObject:target];
        }
        
        month++;
    }
    return arr;
}

- (void)drawRect:(CGRect)rect
{
    [self clean];
    
    // 折線圖
    [self drawLineCharView];
    
    /* 區間年份 */
    //[self drawYearLabel:_quartz.frame];

    // add button
    [self addButtonView];
    [self addChartRangeView];
}

- (void)clean
{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)drawLineCharView
{
    CGRect frame = CGRectMake(self.frame.size.width*0.1, 0, self.frame.size.width*0.8, self.frame.size.height);
    CGFloat chartWidth = frame.size.width / 3.;
    NSInteger count = _historys.count;
    
    UIView* view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.scrollEnabled = NO;
    _scroll.contentSize = CGSizeMake(chartWidth * count, frame.size.height);
    _scroll.contentOffset = CGPointMake(MAX(0, _scroll.contentSize.width - _scroll.frame.size.width), 0);
    [view addSubview:_scroll];
    
    NSInteger index = 0;
    for (NSMutableArray* array in _historys) {
        
        MLineChartView2* view = [[MLineChartView2 alloc] init];
        view.frame = CGRectMake( chartWidth * index, 0, chartWidth, frame.size.height);
        view.points = array;
        view.scale = view.frame.size.height / 150.;
        view.backgroundColor = [UIColor clearColor];
        [_scroll addSubview:view];
        index++;
    }
}

- (void) drawYearLabel:(CGRect)quartzRect
{
    CGFloat posX = quartzRect.origin.x;
    CGFloat posY = quartzRect.origin.y + 5;
    CGFloat width = quartzRect.size.width / 3 - 10;
    CGFloat height = 30;
    
    NSInteger subCount = _historys.count / 3;

    UILabel* label;
    for (int i = 0; i < 3; i++)
    {
        NSInteger index = subCount * (i + 1) - 1;
        NSString* end = [[[_historys objectAtIndex:index] datetime] substringToIndex:4];

        label = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor colorWithRed:85./255. green:85./255. blue:85./255. alpha:1.];
        label.font = [UIFont systemFontOfSize:13.];
        label.text = end;
        [self addSubview:label];
        
        posX = posX + width + 10;
    }
}

- (void)addButtonView
{
    CGFloat buttonWidth = (self.bounds.size.width - _scroll.frame.size.width) / 2.;
    
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, _scroll.frame.size.height)];
    leftButton.backgroundColor = [UIColor grayColor];
    [leftButton setImage:[UIImage imageNamed:@"icon_arrow_left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(actionLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - buttonWidth, 0, buttonWidth, _scroll.frame.size.height)];
    rightButton.backgroundColor = [UIColor grayColor];
    [rightButton setImage:[UIImage imageNamed:@"icon_arrow_right.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionRight:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    
    NSInteger count = _historys.count;
    if(count <= 3){
        leftButton.enabled = NO;
        rightButton.enabled = NO;
    }
}

- (void)addChartRangeView
{
    UIView* view = _scroll.superview;
    
    CGFloat width = _scroll.frame.size.width/3.;
    _rangeView = [[UIView alloc] initWithFrame:CGRectMake(width * _rangeIndex, 0, width, _scroll.frame.size.height)];
    _rangeView.backgroundColor = [UIColor colorWithRed:1. green:1. blue:1. alpha:0.4];
    [view addSubview:_rangeView];
    
    UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_rangeView addGestureRecognizer:recognizer];
}

- (void)handlePan:(UIPanGestureRecognizer*)sender
{
    UIView* view = sender.view;
    UIView* superview = sender.view.superview;
    CGPoint point = [sender locationInView:superview];
    BOOL contain = CGRectContainsPoint(superview.bounds, point);
    if(!contain)
        return;
    
    CGFloat width = superview.frame.size.width / 3.;
    NSInteger rangeIndex = point.x / width;
    if(_rangeIndex == rangeIndex)
        return;
    
    NSInteger dataIndex = _dataIndex + (rangeIndex - _rangeIndex);
    if(dataIndex >= _historys.count)
        return;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    
    view.frame = CGRectMake( width * rangeIndex, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    [UIView commitAnimations];
    
    _rangeIndex = rangeIndex;
    _dataIndex = dataIndex;
    NSLog(@"dataIndex = %d", (int)_dataIndex);
    
    //NSLog(@"%.2f,%.2f : %d",point.x,point.y, );
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(_delegate && [_delegate respondsToSelector:@selector(designatedChartDidChanged:)])
        [_delegate designatedChartDidChanged:self];
}

#pragma mark - UIButton

- (void)actionLeft:(id)sender
{
    CGPoint offset = _scroll.contentOffset;
    CGFloat x = MAX(0, offset.x - _scroll.frame.size.width);
    CGFloat width = _scroll.frame.size.width / 3.;
    
    [_scroll setContentOffset:CGPointMake(x, 0) animated:YES];
    
    NSInteger dataIndex = (int)(x / width) + _rangeIndex;
    if(_dataIndex == dataIndex)
        return;
    
    _dataIndex = dataIndex;
    NSLog(@"dataIndex = %d", (int)_dataIndex);
    
    if(_delegate && [_delegate respondsToSelector:@selector(designatedChartDidChanged:)])
        [_delegate designatedChartDidChanged:self];
}

- (void)actionRight:(id)sender
{
    CGPoint offset = _scroll.contentOffset;
    CGSize size = _scroll.contentSize;
    CGFloat x = MIN(size.width - _scroll.frame.size.width, offset.x + _scroll.frame.size.width);
    CGFloat width = _scroll.frame.size.width / 3.;
    
    [_scroll setContentOffset:CGPointMake(x, 0) animated:YES];
    
    NSInteger dataIndex = (int)(x / width) + _rangeIndex;
    if(_dataIndex == dataIndex)
        return;
    
    _dataIndex = dataIndex;
    NSLog(@"dataIndex = %d", (int)_dataIndex);
    
    if(_delegate && [_delegate respondsToSelector:@selector(designatedChartDidChanged:)])
        [_delegate designatedChartDidChanged:self];
}

@end
