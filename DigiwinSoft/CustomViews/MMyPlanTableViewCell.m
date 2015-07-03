//
//  MMyPlanTableViewCell.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/2.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMyPlanTableViewCell.h"

@implementation MMyPlanTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 20;
    frame.size.width -= 2 * 20;
    [super setFrame:frame];
    
    [self resetLayoutSubviewsWithOffsetX:20];
}

@end
