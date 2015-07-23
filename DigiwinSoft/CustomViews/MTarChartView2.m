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

@property (nonatomic, strong) MLineChartView2* quartz;

@end

@implementation MTarChartView2

-(id)init
{
    if(self = [super init]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    return self;
}

- (void)setHistorys:(NSArray *)historys
{
    if(historys.count >= 12)
        _historys = historys;
    
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:_historys];
    NSInteger count = 12 - _historys.count;
    for (int index = 0; index < count; index++) {
        if(array.count == 0){
            
            MTarget* target = [MTarget new];
            target.datetime = [self getPrevDateStringByDateString:nil];
            [array addObject:target];
            continue;
        }
        
        MTarget* tar = [array objectAtIndex:0];
        MTarget* target = [MTarget new];
        target.datetime = [self getPrevDateStringByDateString:tar.datetime];
        [array insertObject:target atIndex:0];
    }
    _historys = array;
}

- (NSString*)getPrevDateStringByDateString:(NSString*)string
{
    if(!string || [string isEqualToString:@""]){
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:[NSDate date]];
        return [NSString stringWithFormat:@"%04d-%02d-%02d", (int)comps.year, (int)comps.month, (int)comps.day];
    }
    
    NSDateFormatter* fm = [NSDateFormatter new];
    fm.dateFormat = @"yyyy-MM-dd";
    NSDate* date = [fm dateFromString:string];
    
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:date];
    NSInteger year = comps.year;
    NSInteger month = comps.month - 1;
    
    if(month < 1){
        year -= 1;
        month += 12;
    }
    
    return [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)comps.day];
}

- (void)drawRect:(CGRect)rect
{
    // 折線圖
    _quartz = [[MLineChartView2 alloc] init];
    _quartz.frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(112,1078-830,856,520)];
    _quartz.points = (NSMutableArray*)_historys;
    _quartz.scale = _quartz.frame.size.height / 150.;
    _quartz.backgroundColor = [UIColor clearColor];
    //quartz.backgroundColor = [UIColor redColor];
    [self addSubview:_quartz];
    
    /* 區間年份 */
    [self drawYearLabel:_quartz.frame];

    // add button
    [self addButtonView:_quartz.frame];
}

- (void) drawYearLabel:(CGRect)quartzRect
{
    CGFloat posX = quartzRect.origin.x;
    CGFloat posY = 80;
    CGFloat width = quartzRect.size.width / 3;
    CGFloat height = 30;
    
    NSInteger subCount = _historys.count / 3;

    UILabel* label;
    for (int i = 0; i < 3; i++)
    {
        NSInteger index = subCount * (i + 1) - 1;
        NSString* end = [[[_historys objectAtIndex:index] datetime] substringToIndex:4];

        label = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:85./255. green:85./255. blue:85./255. alpha:1.];
        label.font = [UIFont systemFontOfSize:13.];
        label.text = end;
        [self addSubview:label];
        
        posX += width;
    }
}

- (void)addButtonView:(CGRect)quartzRect
{
    UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, quartzRect.origin.y, 34, quartzRect.size.height)];
    leftButton.backgroundColor = [UIColor grayColor];
    [leftButton setImage:[UIImage imageNamed:@"icon_arrow_left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(actionLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    
    UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectMake(quartzRect.origin.x + quartzRect.size.width - 1, quartzRect.origin.y, 34, quartzRect.size.height)];
    rightButton.backgroundColor = [UIColor grayColor];
    [rightButton setImage:[UIImage imageNamed:@"icon_arrow_right.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionRight:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

#pragma mark - UIButton

- (void)actionLeft:(id)sender
{
    NSString* direction = @"left";
    [_quartz moveRange:direction];
    [self.delegate moveRange:direction];
}

- (void)actionRight:(id)sender
{
    NSString* direction = @"right";
    [_quartz moveRange:direction];
    [self.delegate moveRange:direction];
}

@end
