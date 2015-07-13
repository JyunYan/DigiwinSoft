//
//  MReportTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MReportTableViewCell.h"

@implementation MReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Cell";
    MReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *labTitle = [[UILabel alloc] init];
        self.labTitle = labTitle;
        [self.contentView addSubview:labTitle];

        UILabel *lab = [[UILabel alloc] init];
        self.lab = lab;
        [self.contentView addSubview:lab];
        
        UILabel *labState = [[UILabel alloc] init];
        self.labState = labState;
        [self.contentView addSubview:labState];
        
        UILabel *labReason = [[UILabel alloc] init];
        self.labReason = labReason;
        [self.contentView addSubview:labReason];
        
        UILabel *labValueT = [[UILabel alloc] init];
        self.labValueT = labValueT;
        [self.contentView addSubview:labValueT];
        
        UILabel *labFinishDay = [[UILabel alloc] init];
        self.labFinishDay = labFinishDay;
        [self.contentView addSubview:labFinishDay];

    }
    return self;
}

@end
