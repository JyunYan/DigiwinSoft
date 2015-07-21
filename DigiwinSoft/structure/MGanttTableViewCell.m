//
//  MGanttTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/20.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttTableViewCell.h"

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
        
//        Bar的長度還要再依資料設計演算法
//        1.直接畫一個view貼到cell0，圖層提到最上面。
//        2.依cell分段決定是否要畫。
//        PS. bar最後有一個label
        for (int i=1; i<=3; i++) {
            UIImageView* imgBar=[[UIImageView alloc]initWithFrame:CGRectMake((((MGanttTableViewCell_WIDTH/3)*i))-((MGanttTableViewCell_WIDTH/3)/2)-10, 0, 10, MGanttTableViewCell_HEIGHT)];
            imgBar.backgroundColor=[UIColor colorWithRed:112.0/255.0 green:200.0/255.0 blue:223.0/255.0 alpha:1];
            [self.contentView addSubview:imgBar];
        }
        
               
       }
    return self;
}

@end
