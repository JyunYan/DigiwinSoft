//
//  MTarChartView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarChartView.h"
#import "MDirector.h"
#import "MLineChartView.h"
#import "MDashedLine.h"

@interface MTarChartView ()

@property (nonatomic) UIColor* blueColor;
@property (nonatomic) UIColor* grayColor;
@property (nonatomic) UIColor* darkGrayColor;

@end

@implementation MTarChartView

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
    UILabel* label = nil;
    
    // 折線圖
    CGFloat lineChartWidth = 742;
    CGFloat dashedLineWidth = lineChartWidth * 0.4;
    CGRect frame = [[MDirector sharedInstance] getScaledRect:CGRectMake(192-dashedLineWidth+45, 1078-830, lineChartWidth+dashedLineWidth*2-90, 630)];
    MLineChartView* quartz = [[MLineChartView alloc] init];
    quartz.frame = frame;
    quartz.points = (NSMutableArray*)_historys;
    quartz.scale = quartz.frame.size.height / 120.;
    quartz.backgroundColor = [UIColor clearColor];
    //quartz.backgroundColor = [UIColor redColor];
    [self addSubview:quartz];
    
    label = [self createTextAtView:self frame:CGRectMake(110,1008-830,70,38) text:@"(天)" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1074-830,70,38) text:@"120" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1218-830,70,38) text:@"90" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1378-830,70,38) text:@"60" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1534-830,70,38) text:@"30" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    
    //日期區間
    NSString* start = [[[_historys firstObject] datetime] substringToIndex:7];
    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString* end = [[[_historys lastObject] datetime] substringToIndex:7];
    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString* period = [NSString stringWithFormat:@"%@ ~ %@", start, end];
    
    label = [self createTextAtView:self frame:CGRectMake(290,900-830,500,56) text:period color:self.darkGrayColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    //長灰線
    [self createRectAtView:self frame:CGRectMake(290,964-830,500,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
}

-(void) createRectAtView:(UIView*)view  frame:(CGRect)frame color:(UIColor*)color
{
    CGRect frame2 = [[MDirector sharedInstance] getScaledRect:frame];
    UIView* rect = [[UIView alloc] initWithFrame:frame2];
    rect.backgroundColor = color;
    [view addSubview:rect];
}

-(UILabel*) createTextAtView:(UIView*)view frame:(CGRect)frame text:(NSString*)text color:(UIColor*) color fontSize:(int)fontSize
{
    CGRect frame2 = [[MDirector sharedInstance] getScaledRect:frame];
    UILabel* label = [[UILabel alloc] initWithFrame:frame2];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:label];
    return label;
}

- (NSMutableArray*)loadQuartzData
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    NSString* count = @"22";
    NSString* day = @"01";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"65";
    day = @"02";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"60";
    day = @"03";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"40";
    day = @"04";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"70";
    day = @"05";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"85";
    day = @"06";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"60";
    day = @"07";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"90";
    day = @"08";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"110";
    day = @"09";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"82";
    day = @"10";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"51";
    day = @"11";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    count = @"30";
    day = @"12";
    dict = [[NSMutableDictionary alloc] init];
    [dict setValue:count forKey:@"count"];
    [dict setValue:day forKey:@"day"];
    
    [array addObject:dict];
    
    return array;
    
}

@end
