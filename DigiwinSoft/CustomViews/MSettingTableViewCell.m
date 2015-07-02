//
//  MSettingTableViewCell.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSettingTableViewCell.h"

@implementation MSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 10, 26, 26);
    self.textLabel.frame = CGRectMake(50, 10, 200, 26);
}

@end
