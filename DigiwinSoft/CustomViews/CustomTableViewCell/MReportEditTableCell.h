//
//  MReportEditTableCell.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MConfig.h"
#import "MReport.h"

#define kReportEditTableCellHeight  370

@class MReportEditTableCell;

@protocol MReportEditTableCellDelegate <NSObject>

- (void)reportEditTableCell:(MReportEditTableCell*)cell didChangedReport:(MReport*)report;

@end

@interface MReportEditTableCell : UITableViewCell

@property (nonatomic, strong) MReport* report;
@property (nonatomic, strong) NSString* unit;
@property (nonatomic, strong) id<MReportEditTableCellDelegate> delegate;

- (void)prepare;

@end
