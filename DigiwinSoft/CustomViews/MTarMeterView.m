//
//  MTarMeterView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/9.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MTarMeterView.h"
#import "MDirector.h"

@interface MTarMeterView ()

@property (nonatomic) UIColor* blueColor;
@property (nonatomic) UIColor* greenColor;
@property (nonatomic) UIColor* grayColor;
@property (nonatomic) UIColor* lightGrayColor;
@property (nonatomic) UIColor* darkGrayColor;
@property (nonatomic) UIColor* yellowColor;
@property (nonatomic) UIColor* redColor;

@end

@implementation MTarMeterView

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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel* label = nil;
    
    // 計量表下方字樣左邊小圖
    [self createRectAtView:self frame:CGRectMake(189, 702, 37,37) color:self.blueColor];
    [self createRectAtView:self frame:CGRectMake(385, 702, 37,37) color:self.greenColor];
    [self createRectAtView:self frame:CGRectMake(579, 702, 37,37) color:self.grayColor];
    [self createRectAtView:self frame:CGRectMake(772, 702, 37,37) color:self.yellowColor];
    
    label = [self createTextAtView:self frame:CGRectMake(230,155,620,55) text:self.target.name color:self.darkGrayColor fontSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    // 計量表上方數據字樣
    label = [self createTextAtView:self frame:CGRectMake(259,290,64,58) text:self.target.valueR color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(421,290,64,58) text:self.target.bottom color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(595,290,64,58) text:self.target.avg color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label = [self createTextAtView:self frame:CGRectMake(759,290,64,58) text:self.target.top color:self.redColor fontSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    
    // 計量表下方字樣
    [self createTextAtView:self frame:CGRectMake(242,702, 104,37) text:@"自己" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(437,702, 104,37) text:@"低標" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(629,702, 104,37) text:@"均標" color:self.grayColor fontSize:12];
    [self createTextAtView:self frame:CGRectMake(825,702, 104,37) text:@"頂標" color:self.grayColor fontSize:12];
    
    // 計量表
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
        int value = [self.target.valueR intValue];
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
        int value = [self.target.bottom intValue];
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
        int value = [self.target.avg intValue];
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
        int value = [self.target.top intValue];
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
    
    //長灰線
    [self createRectAtView:self frame:CGRectMake(143,631,800,4) color:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:187/255.0]];
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

@end