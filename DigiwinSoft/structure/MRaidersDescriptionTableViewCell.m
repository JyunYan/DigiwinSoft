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
        self.labRelation = labRelation;
        [self.contentView addSubview:labRelation];
        
        UILabel *labMeasure = [[UILabel alloc] init];
        self.labMeasure = labMeasure;
        [self.contentView addSubview:labMeasure];

        UILabel *labMin = [[UILabel alloc] init];
        self.labMin = labMin;
        [self.contentView addSubview:labMin];

        
        UILabel *labMax = [[UILabel alloc] init];
        self.labMax = labMax;
        [self.contentView addSubview:labMax];
    }
    return self;
}


@end
