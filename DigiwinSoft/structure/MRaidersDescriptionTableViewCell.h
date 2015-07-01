//
//  MRaidersDescriptionTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRaidersDescriptionTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *labRelation;
@property (nonatomic, weak) UILabel *labMeasure;
@property (nonatomic, weak) UILabel *labMin;
@property (nonatomic, weak) UILabel *labMax;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
