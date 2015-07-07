//
//  MReportTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MReportTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *lab;
@property (nonatomic, weak) UILabel *labState;
@property (nonatomic, weak) UILabel *labReason;
@property (nonatomic, weak) UILabel *labValueT;
@property (nonatomic, weak) UILabel *labFinishDay;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
