//
//  MReportTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MReportTableViewCell.h"

@implementation MReportTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ReportCell";
    MReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MReportTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _labState = [self createLabelWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 20)];
        _labState.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_labState];
        
        _labValueT = [self createLabelWithFrame:CGRectMake(10, 20, DEVICE_SCREEN_WIDTH-20, 15)];
        _labValueT.backgroundColor=[UIColor clearColor];
        _labValueT.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_labValueT];
        
        _labFinishDay = [self createLabelWithFrame:CGRectMake(10, 20, DEVICE_SCREEN_WIDTH-20, 15)];
        _labFinishDay.backgroundColor=[UIColor clearColor];
        _labFinishDay.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_labFinishDay];
        
        _labReason = [self createLabelWithFrame:CGRectMake(10, 35, DEVICE_SCREEN_WIDTH-20, 70)];
        _labReason.backgroundColor=[UIColor clearColor];
        _labReason.numberOfLines = 0;
        _labReason.textAlignment=NSTextAlignmentLeft;
        _labReason.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _labReason.layer.borderWidth=1;
        [self.contentView addSubview:_labReason];
        
        _labReportDate = [self createLabelWithFrame:CGRectMake(10, 100, DEVICE_SCREEN_WIDTH-20, 20)];
        _labReportDate.backgroundColor=[UIColor clearColor];
        _labReportDate.textColor=[UIColor lightGrayColor];
        _labReportDate.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_labReportDate];

       
    }
    return self;
}
- (UILabel*)createLabelWithFrame:(CGRect)frame
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}
@end
