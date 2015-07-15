//
//  MRaidersDescriptionTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"

#define MRaidersDescriptionTableViewCell_WIDTH (DEVICE_SCREEN_WIDTH-20)
#define MRaidersDescriptionTableViewCell_HEIGHT 24

@interface MRaidersDescriptionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labRelation;
@property (nonatomic, strong) UILabel *labMeasure;
@property (nonatomic, strong) UILabel *labMin;
@property (nonatomic, strong) UILabel *labMax;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
