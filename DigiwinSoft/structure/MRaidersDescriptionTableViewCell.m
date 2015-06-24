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
        
        UILabel *labRelation = [[UILabel alloc] init];
        labRelation.backgroundColor=[UIColor clearColor];
        labRelation.font = [UIFont systemFontOfSize:14];
        labRelation.textColor=[UIColor blackColor];
        [self.contentView addSubview:labRelation];
        self.labRelation = labRelation;
        self.labRelation.frame=CGRectMake(10, 17, 115, 16);
        
        UILabel *labMeasure = [[UILabel alloc] init];
        labMeasure.textColor=[UIColor blackColor];
        labMeasure.backgroundColor=[UIColor clearColor];
        labMeasure.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labMeasure];
        self.labMeasure = labMeasure;
        self.labMeasure.frame=CGRectMake(130, 17, 90, 16);
        
        UILabel *labMin = [[UILabel alloc] init];
        labMin.textColor=[UIColor blackColor];
        labMin.backgroundColor=[UIColor clearColor];
        labMin.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labMin];
        self.labMin = labMin;
        self.labMin.frame=CGRectMake(235, 17, 30, 16);
        
        UILabel *labMax = [[UILabel alloc] init];
        labMax.textColor=[UIColor blackColor];
        labMax.backgroundColor=[UIColor clearColor];
        labMax.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labMax];
        self.labMax = labMax;
        self.labMax.frame=CGRectMake(285, 17, 30, 16);

    }
    return self;
}


@end
