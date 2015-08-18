//
//  MReportTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"

@interface MReportTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labReportDate;
@property (nonatomic, strong) UILabel *labState;
@property (nonatomic, strong) UILabel *labReason;
@property (nonatomic, strong) UILabel *labValueT;
@property (nonatomic, strong) UILabel *labFinishDay;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
