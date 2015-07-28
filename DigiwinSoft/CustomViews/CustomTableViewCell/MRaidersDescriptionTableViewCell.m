//
//  MRaidersDescriptionTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDescriptionTableViewCell.h"


@implementation MRaidersDescriptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Cell";
    MRaidersDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
    
        cell = [[MRaidersDescriptionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat gap = 4.;
        CGFloat offset = gap;
        CGFloat width = MRaidersDescriptionTableViewCell_WIDTH - 5*gap;
        
        _labRelation = [self createLabelWithFrame:CGRectMake(offset, 0, width*0.4, MRaidersDescriptionTableViewCell_HEIGHT)];
        [self.contentView addSubview:_labRelation];
        
        offset += _labRelation.frame.size.width + gap;
        
        _labMeasure = [self createLabelWithFrame:CGRectMake(offset, 0, width*0.36, MRaidersDescriptionTableViewCell_HEIGHT)];;
        [self.contentView addSubview:_labMeasure];
        
        offset += _labMeasure.frame.size.width + gap;

        _labMin = [self createLabelWithFrame:CGRectMake(offset, 0, width*0.12, MRaidersDescriptionTableViewCell_HEIGHT)];;
        [self.contentView addSubview:_labMin];
        
        offset += _labMin.frame.size.width + gap;

        _labMax = [self createLabelWithFrame:CGRectMake(offset, 0, width*0.12, MRaidersDescriptionTableViewCell_HEIGHT)];;
        [self.contentView addSubview:_labMax];
    }
    return self;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    
    return label;
}


@end
