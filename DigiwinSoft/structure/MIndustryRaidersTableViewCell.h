//
//  MIndustryRaidersTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"
#import "MGuide.h"

@class MIndustryRaidersTableViewCell;

@protocol MIndustryRaidersTableViewCellDelegate<NSObject>
@required
- (void)btnManagerClicked:(MIndustryRaidersTableViewCell*)cell;
- (void)btnTargetSetClicked:(MIndustryRaidersTableViewCell*)cell;
- (void)btnRaidersClicked:(MIndustryRaidersTableViewCell*)cell;
@end

@interface MIndustryRaidersTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UIButton *btnManager;
@property (nonatomic, strong) UIButton *btnTargetSet;
@property (nonatomic, strong) UIButton *btnRaiders;

@property (nonatomic) id<MIndustryRaidersTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)prepareWithGuide:(MGuide*)guide;
@end
