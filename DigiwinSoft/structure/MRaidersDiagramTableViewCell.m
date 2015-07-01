//
//  MRaidersDiagramTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersDiagramTableViewCell.h"

@implementation MRaidersDiagramTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Cell";
    MRaidersDiagramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MRaidersDiagramTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *labActivity= [[UILabel alloc] init];
        labActivity.textColor=[UIColor blackColor];
        labActivity.backgroundColor=[UIColor clearColor];
        self.labActivity = labActivity;
        [self.contentView addSubview:labActivity];
        
        UILabel *labSubActivity= [[UILabel alloc] init];
        labSubActivity.textColor=[UIColor grayColor];
        labSubActivity.backgroundColor=[UIColor clearColor];
        self.labSubActivity = labSubActivity;
        [self.contentView addSubview:labSubActivity];
        
        UILabel *labWorkItem= [[UILabel alloc] init];
        labWorkItem.textColor=[UIColor blackColor];
        labWorkItem.backgroundColor=[UIColor clearColor];
        self.labWorkItem = labWorkItem;
        [self.contentView addSubview:labWorkItem];
        
        UILabel *labSubWorkItem= [[UILabel alloc] init];
        labSubWorkItem.textColor=[UIColor grayColor];
        labSubWorkItem.backgroundColor=[UIColor clearColor];
        self.labSubWorkItem = labSubWorkItem;
        [self.contentView addSubview:labSubWorkItem];
    }
    return self;
}
@end
