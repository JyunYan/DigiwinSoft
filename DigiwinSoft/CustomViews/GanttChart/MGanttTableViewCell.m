//
//  MGanttTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/7/20.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MGanttTableViewCell.h"

#define TIME_LINE_WIDTH 36
#define TABLE_CELL_HEIGHT 40.
#define MONTH_INTERVAL  80
@interface MGanttTableViewCell ()


@property (nonatomic, strong) UIImageView* checkBox;
@property (nonatomic, strong) NSMutableArray* stars;

@end
@implementation MGanttTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"MGanttCell";
    MGanttTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MGanttTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //頭像
        _imgViewHead=[[UIImageView alloc] initWithFrame:CGRectMake((MONTH_INTERVAL-26)/2,(TABLE_CELL_HEIGHT/2)-13, 26, 26)];
        _imgViewHead.backgroundColor=[UIColor clearColor];
        _imgViewHead.layer.cornerRadius=13;
        _imgViewHead.layer.masksToBounds=YES;
        [self.contentView addSubview:_imgViewHead];
        
        
        //負責人name
        _managerLabel =[[UILabel alloc]initWithFrame:CGRectMake((MONTH_INTERVAL-30)/2,(TABLE_CELL_HEIGHT/2)-10, 30, 20)];
        _managerLabel.font=[UIFont systemFontOfSize:12.];
        _managerLabel.textAlignment=NSTextAlignmentCenter;
        _managerLabel.backgroundColor=[UIColor clearColor];
        _managerLabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:_managerLabel];
        
       }
    return self;
}
//timeBar
- (void)createtimeBar:(NSString*)startDate :(NSString*)completeDate :(NSString*)earlyDate :(NSString*)title
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    NSDate *dt3 = [[NSDate alloc] init];

    dt1 = [df dateFromString:startDate];
    dt2 = [df dateFromString:completeDate];
    dt3 = [df dateFromString:earlyDate];

    //總長
//    CGFloat total= MONTH_INTERVAL*24;
    
    //bar長度
    NSTimeInterval time1=[dt2 timeIntervalSinceDate:dt1];
    int days1=((int)time1)/(3600*24);
    NSString *dateContent1=[[NSString alloc] initWithFormat:@"%@至%@，時程長度%i天",startDate,completeDate,days1];
    NSLog(@"%@",dateContent1);
    CGFloat barLenth=((days1*MONTH_INTERVAL)/30);
    
    //bar跟起點的距離
    NSTimeInterval time2=[dt1 timeIntervalSinceDate:dt3];
    int days2=((int)time2)/(3600*24);
    NSString *dateContent2=[[NSString alloc] initWithFormat:@"%@與timeline開頭距離%i天",startDate,days2];
    NSLog(@"%@",dateContent2);
    CGFloat disLenth=(days2==0)?0:((days2*MONTH_INTERVAL)/30);
    
    //最早的天數
    UIImageView* imgBar;
    if (earlyDate.length!=0&&startDate.length!=0) {
        NSString *earlyDay=[earlyDate substringWithRange:NSMakeRange(8, 2)];
        CGFloat earlyDaydis = ([earlyDay floatValue]*MONTH_INTERVAL)/30;
        
        //draw bar
        imgBar=[[UIImageView alloc]initWithFrame:CGRectMake(80+disLenth+earlyDaydis,(TABLE_CELL_HEIGHT-10)/2, barLenth, 14)];
        imgBar.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:imgBar];
    }
    else
    {
       imgBar=[[UIImageView alloc]initWithFrame:CGRectMake(80+disLenth,(TABLE_CELL_HEIGHT-10)/2, barLenth, 14)];
    }
    
      //draw lab
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(imgBar.frame.origin.x+imgBar.frame.size.width+10,(TABLE_CELL_HEIGHT-10)/2,120, 14)];
    lab.text=title;
    lab.font=[UIFont systemFontOfSize:12];
    lab.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:lab];
}
@end
