//
//  MMonitorTableCell2.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitorData.h"

#define HeightForMonitorTableCell2  60

@interface MMonitorTableCell2 : UITableViewCell

@property (nonatomic, strong) MMonitorData* data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)prepare;

@end
