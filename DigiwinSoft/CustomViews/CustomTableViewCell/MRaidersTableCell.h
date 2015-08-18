//
//  MRaidersTableCell.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/15.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"
#import "SWTableViewCell.h"

@interface MRaidersTableCell : SWTableViewCell<SWTableViewCellDelegate>

@property (nonatomic, strong) UIButton *btnCheck;
@property (nonatomic, strong) UIButton *btnManager;
@property (nonatomic, strong) UIButton *btnTargetSet;
@property (nonatomic, strong) UIButton *btnRaiders;

@property (nonatomic, strong) UILabel *labName;
@property (nonatomic, strong) UILabel* managerLabel;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

- (UIButton*)createButtonWithImage:(UIImage*)image frame:(CGRect)frame;
- (UILabel*)createLabelWithFrame:(CGRect)frame font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;

- (UIImage*)imageWithCustTarget:(MCustTarget*)taregt;
- (UIImage*)imageWithTarget:(MTarget*)taregt;

@end

/**
 對策 相關
 **/
@class MGuideTableCell;

@protocol MGuideTableCellDelegate<NSObject>
@required
- (void)btnManagerClicked:(MGuideTableCell*)cell;
- (void)btnTargetSetClicked:(MGuideTableCell*)cell;
- (void)btnRaidersClicked:(MGuideTableCell*)cell;
@end

@interface MGuideTableCell : MRaidersTableCell

@property (nonatomic, strong) id<MGuideTableCellDelegate> delegateG;

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size;
- (void)prepareWithGuide:(MCustGuide*)guide;

@end


/**
 關鍵活動 相關
 **/
@class MActivityTableCell;

@protocol MActivityTableCellDelegate<NSObject>
@required
- (void)btnManagerClicked:(MActivityTableCell*)cell;
- (void)btnTargetSetClicked:(MActivityTableCell*)cell;
- (void)btnRaidersClicked:(MActivityTableCell*)cell;
@end

@interface MActivityTableCell : MRaidersTableCell

@property (nonatomic) id<MActivityTableCellDelegate> delegateA;

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size;
- (void)prepareWithCustActivity:(MCustActivity*)activity;

@end


/**
 工作項目 相關
 **/
@class MWorkItemTableCell;

@protocol MWorkItemTableCellDelegate<NSObject>
@required
- (void)btnManagerClicked:(MWorkItemTableCell*)cell;
- (void)btnTargetSetClicked:(MWorkItemTableCell*)cell;
@end

@interface MWorkItemTableCell : MRaidersTableCell
@property (nonatomic) id<MWorkItemTableCellDelegate> delegateW;

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size;
- (void)prepareWithCustWorkItem:(MCustWorkItem*)workitem;

@end
