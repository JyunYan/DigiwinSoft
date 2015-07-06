//
//  MTarInfoChartView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarInfoChartView.h"
#import "MLineChartView.h"
#import "MTarget.h"

@interface MTarInfoChartView ()

@property (nonatomic) UIColor* blueColor;
@property (nonatomic) UIColor* greenColor;
@property (nonatomic) UIColor* grayColor;
@property (nonatomic) UIColor* lightGrayColor;
@property (nonatomic) UIColor* darkGrayColor;
@property (nonatomic) UIColor* yellowColor;
@property (nonatomic) UIColor* redColor;

@property (nonatomic) MTarget* mTarget;

@end

@implementation MTarInfoChartView

-(id)init
{
    if(self = [super init]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.greenColor = [UIColor colorWithRed:123/255.0 green:191/255.0 blue:79/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.yellowColor = [UIColor colorWithRed:234/255.0 green:204/255.0 blue:75/255.0 alpha:1.0];
        
        self.lightGrayColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.redColor = [UIColor colorWithRed:242/255.0 green:97/255.0 blue:95/255.0 alpha:1.0];
        
//        self.mTarget = [[MTarget alloc] init];
//        self.mTarget.valueR = @"80";
//        self.mTarget.top = @"25";
//        self.mTarget.avg = @"30";
//        self.mTarget.bottom = @"40";
//        self.mTarget.name = @"庫存周轉天數(天)";
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        self.blueColor = [UIColor colorWithRed:131/255.0 green:208/255.0 blue:229/255.0 alpha:1.0];
        self.greenColor = [UIColor colorWithRed:123/255.0 green:191/255.0 blue:79/255.0 alpha:1.0];
        self.grayColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
        self.yellowColor = [UIColor colorWithRed:234/255.0 green:204/255.0 blue:75/255.0 alpha:1.0];
        
        self.lightGrayColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        self.darkGrayColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.redColor = [UIColor colorWithRed:242/255.0 green:97/255.0 blue:95/255.0 alpha:1.0];
        
//        self.mTarget = [[MTarget alloc] init];
//        self.mTarget.valueR = @"50";
//        self.mTarget.top = @"25";
//        self.mTarget.avg = @"30";
//        self.mTarget.bottom = @"40";
//        self.mTarget.name = @"庫存周轉天數(天)";
    }
    return self;
}

- (void)setHistoryArray:(NSArray *)historyArray
{
    _historyArray = historyArray;
    
    if(historyArray.count > 0)
        self.mTarget = [historyArray lastObject];
    else
        self.mTarget = [MTarget new];
}

- (void)drawRect:(CGRect)rect
{
    //UIScrollView* view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT - 44)];
    
    UILabel* label = nil;
    
    
    MLineChartView* quartz = [[MLineChartView alloc] initWithPoints:[self loadQuartzData]];
    quartz.frame = [self getScaledRect:CGRectMake(192,1078,742,630)];
    quartz.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:219.0/255.0 blue:227.0/255.0 alpha:1.0];
    [self addSubview:quartz];
    
    label = [self createTextAtView:self frame:CGRectMake(110,1008,70,38) text:@"(天)" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1074,70,38) text:@"120" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1218,70,38) text:@"90" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1378,70,38) text:@"60" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    label = [self createTextAtView:self frame:CGRectMake(110,1534,70,38) text:@"30" color:self.grayColor fontSize:10];
    label.textAlignment = NSTextAlignmentRight;
    
    //btn
    UIButton *btn_close=[[UIButton alloc]initWithFrame:  [self getScaledRect:CGRectMake(974, 140, 66, 66)]];
    [btn_close setBackgroundImage:[UIImage imageNamed:@"icon_close.png"] forState:UIControlStateNormal];
    [btn_close addTarget:self action:@selector(actionCloseChatView:) forControlEvents:UIControlEventTouchUpInside];
    btn_close.backgroundColor=[UIColor clearColor];
    [self addSubview:btn_close];
    
    
    // 上方計量表
    [self createRectAtView:self frame:CGRectMake(189, 702, 37,37) color:self.blueColor];
    [self createRectAtView:self frame:CGRectMake(385, 702, 37,37) color:self.greenColor];
    [self createRectAtView:self frame:CGRectMake(579, 702, 37,37) color:self.grayColor];
    [self createRectAtView:self frame:CGRectMake(772, 702, 37,37) color:self.yellowColor];
    
    label = [self createTextAtView:self frame:CGRectMake(230,155,620,55) text:self.mTarget.name color:self.darkGrayColor fontSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self createTextAtView:self frame:CGRectMake(242,702, 104,37) text:@"自己" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(437,702, 104,37) text:@"低標" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(629,702, 104,37) text:@"均標" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(825,702, 104,37) text:@"頂標" color:self.grayColor fontSize:12];
    //
    //長灰線
    [self createRectAtView:self frame:CGRectMake(143,631,800,4) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    [self createRectAtView:self frame:CGRectMake(39,830,1002,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    [self createRectAtView:self frame:CGRectMake(343,964,394,2) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
    
    //日期區間
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear  fromDate:[NSDate date]];
    int n_year = (int)[todayComponents year];
    int n_month = (int)[todayComponents month];
    int p_year = n_year - 1;
    int p_month = n_month + 1;
    if( n_month == 12)
    {
        p_month = 1;
        p_year = n_year;
    }
    NSString* period = [NSString stringWithFormat:@"%d/%02d ~ %d/%02d", p_year, p_month, n_year, n_month];
    
    label = [self createTextAtView:self frame:CGRectMake(290,900,500,56) text:period color:self.darkGrayColor fontSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    label = [self createTextAtView:self frame:CGRectMake(259,290,64,58) text:self.mTarget.valueR color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(421,290,64,58) text:self.mTarget.bottom color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(595,290,64,58) text:self.mTarget.avg color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(759,290,64,58) text:self.mTarget.top color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    for(int i = 0; i < 10; i++)
        [self createRectAtView:self frame:CGRectMake(240,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:self frame:CGRectMake(408,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:self frame:CGRectMake(576,346 + i * 28,104,20)color:self.lightGrayColor];
    for(int i = 0; i < 10; i++)
        [self createRectAtView:self frame:CGRectMake(743,346 + i * 28,104,20)color:self.lightGrayColor];
    
    
    if(true)
    {
        int value = [self.mTarget.valueR intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:self frame:CGRectMake(240,618 - i * 28 - h,104, h)color:self.blueColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.bottom intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:self frame:CGRectMake(408,618 - i * 28 - h,104, h)color:self.greenColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.avg intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:self frame:CGRectMake(576,618 - i * 28 - h,104, h)color:self.grayColor];
            i++;
            value -= 10;
        }
    }
    if(true)
    {
        int value = [self.mTarget.top intValue];
        int i = 0;
        while( value > 0)
        {
            float ratio = 1.0f;
            if( value < 10)
                ratio = value / 10.0;
            float h = 20 * ratio;
            [self createRectAtView:self frame:CGRectMake(743,618 - i * 28 - h,104, h)color:self.yellowColor];
            i++;
            value -= 10;
        }
    }
}

- (void)actionCloseChatView:(id)sender
{
    [self removeFromSuperview];
}

-(void) createRectAtView:(UIView*)view  frame:(CGRect)frame color:(UIColor*)color
{
    CGRect frame2 = [self getScaledRect:frame];
    UIView* rect = [[UIView alloc] initWithFrame:frame2];
    rect.backgroundColor = color;
    [view addSubview:rect];
}

-(UILabel*) createTextAtView:(UIView*)view frame:(CGRect)frame text:(NSString*)text color:(UIColor*) color fontSize:(int)fontSize
{
    CGRect frame2 = [self getScaledRect:frame];
    UILabel* label = [[UILabel alloc] initWithFrame:frame2];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:label];
    return label;
}

-(CGRect) getScaledRect:(CGRect) frame
{
    float scale = DEVICE_SCREEN_WIDTH / 1080.0;
    CGRect frame2 = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height  * scale);
    return frame2;
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
