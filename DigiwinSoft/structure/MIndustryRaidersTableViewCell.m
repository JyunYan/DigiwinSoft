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
                UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:nameLabel];
        self.labName = nameLabel;
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self settingFrame];
        
        
        
        
    }
    return self;
}
//设置相对位置
- (void)settingFrame
{
    self.frame = CGRectMake(0, 0, 320, 120);
    self.labName.frame=CGRectMake(100, 120/2-25, 200, 50);
    self.iconView.frame=CGRectMake(10, (120-80)/2, 80, 80);
}
@end
