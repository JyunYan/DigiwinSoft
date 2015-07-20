//
//  MGanttTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/20.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"
#define MGanttTableViewCell_WIDTH (DEVICE_SCREEN_WIDTH-70)
#define MGanttTableViewCell_HEIGHT 80
@interface MGanttTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImage *imgHead;
@property (nonatomic, strong) UIImage *imgbar;
@property (nonatomic, strong) UILabel *labtitle;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
