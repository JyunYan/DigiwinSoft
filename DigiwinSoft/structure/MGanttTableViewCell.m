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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(cont, 1);
    CGFloat lengths[] = {2,2};
    CGContextSetLineDash(cont, 0, lengths, 2);  //画虚线
    CGContextBeginPath(cont);
    CGContextMoveToPoint(cont, 0.0, rect.size.height - 1);    //开始画线
    CGContextAddLineToPoint(cont, 320.0, rect.size.height - 1);
    CGContextStrokePath(cont);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MGanttCell";
    MGanttTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MGanttTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
