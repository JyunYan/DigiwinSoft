//
//  MMonitorDetailTableCell.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustActivity.h"

#define HeightForMonitorDetailTableCell 60

@class MMonitorDetailTableCell;

@protocol MMonitorDetailTableCellDelegate <NSObject>
@optional
- (void)tableVuewCell:(MMonitorDetailTableCell*)cell didClickedBellButton:(UIButton*)button;
@end

@interface MMonitorDetailTableCell : UITableViewCell

@property (nonatomic, strong) MCustActivity* activity;
@property (nonatomic, strong) id<MMonitorDetailTableCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width;
- (void)prepare;

@end
