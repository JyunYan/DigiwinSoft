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
        
        UIButton *btnCheck = [[UIButton alloc] init];
        self.btnCheck = btnCheck;
        [self.btnCheck  setImage:[UIImage imageNamed:@"check_box_off.png"] forState:UIControlStateNormal];
        self.btnCheck.frame=CGRectMake(20, 16, 20, 20);
        [self.contentView addSubview:btnCheck];

        
        UILabel *labName= [[UILabel alloc] init];
        labName.textColor=[UIColor blackColor];
        labName.backgroundColor=[UIColor clearColor];
        self.labName = labName;
        self.labName.frame=CGRectMake(40, 18, 150, 18);
        [self.contentView addSubview:labName];

        UIButton *btnManager= [[UIButton alloc] init];
        btnManager.backgroundColor=[UIColor lightGrayColor];
        self.btnManager = btnManager;
        self.btnManager.frame=CGRectMake(242.5-16,25 , 16, 16);
        [self.contentView addSubview:btnManager];

        UIButton *btnRaiders= [[UIButton alloc] init];
        btnRaiders.backgroundColor=[UIColor lightGrayColor];
        self.btnRaiders = btnRaiders;
        self.btnRaiders.frame=CGRectMake(337.5-30,25 , 16, 16);
        [self.contentView addSubview:btnRaiders];
        
        for (int i=0; i<5; i++) {
            UIImageView *imgStar=[[UIImageView alloc]initWithFrame:CGRectMake(40+(17*i), 36,16,16)];
            imgStar.backgroundColor=[UIColor colorWithRed:47.0/255.0 green:161.0/255.0 blue:191.0/255.0 alpha:1.0];
            [self.contentView addSubview:imgStar];
            

        }
        
    }
    return self;
}

@end
