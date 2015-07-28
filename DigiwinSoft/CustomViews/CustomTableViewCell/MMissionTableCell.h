//
//  MMissionTableCell.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"

#define MISSION_TABLE_CELL_HEIGHT  60.

@class MMissionTableCell;

@protocol MMissionTableCellDelegate <NSObject>
- (void)actionToAccepted:(MMissionTableCell*)cell;
@end

@interface MMissionTableCell : UITableViewCell

@property (nonatomic, strong) id<MMissionTableCellDelegate> delegate;
- (void)prepareWithObject:(id)obj segmentIndex:(NSInteger)index;

@end
