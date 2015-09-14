//
//  MRaidersTableHeader.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/16.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersTableHeader.h"

@implementation MRaidersTableHeader

- (UILabel*)createTitleLabelWithText:(NSString*)text frame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor =[UIColor grayColor];
    label.text = text;
    
    return label;
}

@end


/**
 對策 header
 **/
@implementation MGuideTableHeader

- (void)prepare
{
    self.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    CGFloat offset = 0;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UILabel *label = nil;
    label = [self createTitleLabelWithText:NSLocalizedString(@"對策名稱", @"對策名稱") frame:CGRectMake(offset,0,width*0.45, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"負責人", @"負責人") frame:CGRectMake(offset, 0, width*0.18, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"目標", @"目標") frame:CGRectMake(offset, 0, width*0.18, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"攻略", @"攻略") frame:CGRectMake(offset, 0, width*0.18, height)];
    [self addSubview:label];
}

@end


/**
 關鍵活動 header
 **/
@implementation MActivityTableHeader

- (void)prepare
{
    self.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    CGFloat offset = 0;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UILabel *label = nil;
    label = [self createTitleLabelWithText:NSLocalizedString(@"關鍵活動", @"關鍵活動") frame:CGRectMake(offset,0,width*0.45, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"負責人", @"負責人") frame:CGRectMake(offset, 0, width*0.18, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"目標", @"目標") frame:CGRectMake(offset, 0, width*0.18, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
}

@end


/**
 工作項目 header
 **/
@implementation MWorkItemTableHeader

- (void)prepare
{
    self.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    CGFloat offset = 0;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    UILabel *label = nil;
    label = [self createTitleLabelWithText:NSLocalizedString(@"工作項目", @"工作項目") frame:CGRectMake(offset,0,width*0.6, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"負責人", @"負責人") frame:CGRectMake(offset, 0, width*0.2, height)];
    [self addSubview:label];
    
    offset += label.frame.size.width;
    
    label = [self createTitleLabelWithText:NSLocalizedString(@"目標", @"目標") frame:CGRectMake(offset, 0, width*0.2, height)];
    [self addSubview:label];
}

@end
