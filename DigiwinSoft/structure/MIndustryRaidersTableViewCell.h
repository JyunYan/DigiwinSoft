//
//  MIndustryRaidersTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MIndustryRaidersTableViewCell : UITableViewCell

@property (nonatomic, weak) UIButton *btnCheck;
@property (nonatomic, weak) UILabel *labName;
@property (nonatomic, weak) UIButton *btnManager;
@property (nonatomic, weak) UIButton *btnTargetSet;
@property (nonatomic, weak) UIButton *btnRaiders;
@property (nonatomic, assign) BOOL isCheck;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
