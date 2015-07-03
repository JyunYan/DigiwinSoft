//
//  MIndustryRaidersTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryRaidersTableViewCell.h"

@implementation MIndustryRaidersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Cell";
    MIndustryRaidersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MIndustryRaidersTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *labName= [[UILabel alloc] init];
        self.labName = labName;
        [self.contentView addSubview:labName];
        
        UIButton *btnCheck = [[UIButton alloc] init];
        self.btnCheck = btnCheck;
        [self.contentView addSubview:btnCheck];

        UIButton *btnManager= [[UIButton alloc] init];
        self.btnManager = btnManager;
        [self.contentView addSubview:btnManager];

        UIButton *btnTargetSet= [[UIButton alloc] init];
        self.btnTargetSet = btnTargetSet;
        [self.contentView addSubview:btnTargetSet];
        
        UIButton *btnRaiders= [[UIButton alloc] init];
        self.btnRaiders = btnRaiders;
        [self.contentView addSubview:btnRaiders];
        
    }
    return self;
}

@end
