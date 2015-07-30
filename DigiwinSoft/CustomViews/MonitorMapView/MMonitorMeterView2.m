//
//  MMonitorMeterView2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorMeterView2.h"
#import "MMeterView2.h"
#import "MDashLine2.h"
#import "MIssType.h"
#import "MDirector.h"

@interface MMonitorMeterView2 ()

@property (nonatomic, strong) MMeterView2* meterView;
@property (nonatomic, strong) UILabel* totalLabel;

@end

@implementation MMonitorMeterView2

- (void)drawRect:(CGRect)rect
{
    [self addMeterView];
    [self addEarningsLabel];
    [self addEarningsDashLine];
    [self addBottomLabel];
}

- (void)addMeterView
{
    CGFloat posX = self.frame.size.width * 0.02;
    CGFloat posY = self.frame.size.height * 0.4;
    CGFloat width = self.frame.size.width - posX*2;
    
    _meterView = [self createMeterViewWithFrame:CGRectMake(posX, posY, width, width*0.1)];
    _meterView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    [self addSubview:_meterView];
}

- (void)addEarningsLabel
{
    UIColor* color = [UIColor redColor];
    NSString* text = [NSString stringWithFormat:@"現在值 : $ %ld", (long)[self calculateEarnings]];
    CGSize size = [self calculateSizeWithText:text];
    CGFloat posY = self.frame.size.height * 0.12;
    
    _totalLabel = [self createLabelWithFrame:CGRectMake(0, posY, size.width, size.height) textColor:color text:text];
    [self addSubview:_totalLabel];
}

- (void)addEarningsDashLine
{
    CGPoint point = _meterView.endPoint;
    CGFloat height = _meterView.frame.size.height + 30;
    
    MDashLine2* line = [[MDashLine2 alloc] initWithFrame:CGRectMake(0, 0, 4, height)];
    line.center = CGPointMake(point.x + _meterView.frame.origin.x, _meterView.center.y);
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

- (void)addBottomLabel
{
    UIColor* color = [[MDirector sharedInstance] getCustomGrayColor];
    NSString* text = [NSString stringWithFormat:@"缺口\n$ %ld", (long)[self calculateEarnings2]];
    
    CGFloat offsetY = _meterView.frame.origin.y + _meterView.frame.size.height;
    CGFloat centerY = offsetY + (self.frame.size.height - offsetY) / 2.;
    CGRect frame = CGRectMake(_meterView.frame.origin.x, 0, _meterView.frame.size.width, 30);
    
    UILabel* label = [self createLabelWithFrame:frame textColor:color text:text];
    label.center = CGPointMake(label.center.x, centerY);
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 2;
    [self addSubview:label];
    
}

- (MMeterView2*)createMeterViewWithFrame:(CGRect)frame
{
    MMeterView2* view = [[MMeterView2 alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [view setIssue:_issue];
    
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

//計算實際總收益
- (NSInteger)calculateEarnings
{
    NSInteger total = 0;   //實際總收益
    NSArray* array = _issue.issTypeArray;
    for (MIssType* type in array) {
        total += [type.gainR integerValue];
    }
    
    return total;
}

//計算預計總收益
- (NSInteger)calculateEarnings2
{
    NSInteger total = 0;   //實際總收益
    NSArray* array = _issue.issTypeArray;
    for (MIssType* type in array) {
        total += [type.gainP integerValue];
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
