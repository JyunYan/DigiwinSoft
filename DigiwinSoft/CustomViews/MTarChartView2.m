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
    MLineChartView2* quartz = [[MLineChartView2 alloc] init];
    quartz.frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(192,1078-830,742,630)];
    quartz.points = (NSMutableArray*)_historys;
    quartz.scale = quartz.frame.size.height / 120.;
    quartz.backgroundColor = [UIColor clearColor];
    //quartz.backgroundColor = [UIColor redColor];
    [self addSubview:quartz];
}

@end
