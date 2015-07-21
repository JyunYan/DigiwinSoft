//
//  MGanttTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/20.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttTableViewCell.h"
#define TIME_LINE_WIDTH 36
@implementation MGanttTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MGanttCell";
    MGanttTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MGanttTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       }
    return self;
}

@end
