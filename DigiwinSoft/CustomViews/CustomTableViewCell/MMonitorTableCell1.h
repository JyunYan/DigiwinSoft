//
//  MMonitorTableCell1.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitorData.h"

#define HeightForMonitorTableCell1  60

@interface MMonitorTableCell1 : UITableViewCell

@property (nonatomic, strong) MMonitorData* data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;
- (void)prepare;

@end
