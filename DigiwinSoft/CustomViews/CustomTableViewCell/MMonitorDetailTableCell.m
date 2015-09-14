//
//  MMonitorDetailTableCell.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorDetailTableCell.h"
#import "MDirector.h"
#import "MDataBaseManager.h"
#import "MCustWorkItem.h"

@interface MMonitorDetailTableCell ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UILabel* actLabel;    //關鍵活動name
@property (nonatomic, strong) UILabel* statusLabel; //狀態
@property (nonatomic, strong) UILabel* onSchLabel;  //如期率
@property (nonatomic, strong) UILabel* countLabel;  //事件數量
@property (nonatomic, strong) UIButton* button;     //事件button

@property (nonatomic, assign) BOOL delay;               //是否延宕
@property (nonatomic, assign) BOOL begin;               //關鍵活動是否已開始進行
@property (nonatomic, assign) NSInteger dateBetween;    //延宕/提前 天數
@property (nonatomic, assign) CGFloat onSchRate;      //如期率

@end

@implementation MMonitorDetailTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MMonitorTableCell2";
    MMonitorDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        CGFloat width = tableView.frame.size.width;
        cell = [[MMonitorDetailTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier width:width];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _width = width;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    CGFloat posX = 10.;
    CGFloat posY = 6.;
    
    // 關鍵活動name
    _actLabel = [self createLabelWithFrame:CGRectMake(posX, posY, _width*0.75, 24.)
                                 textColor:[UIColor blackColor]
                                 pointSize:14.];
    [self addSubview:_actLabel];
    
    posY += _actLabel.frame.size.height;
    
    // 狀態
    _statusLabel = [self createLabelWithFrame:CGRectMake(posX, posY, _width*0.36, 24.)
                                    textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                    pointSize:12.];
    [self addSubview:_statusLabel];
    
    posX += _statusLabel.frame.size.width;
    
    // 如期率title
    UILabel* scheduledRateTitleLabel = [self createLabelWithFrame:CGRectMake(posX, posY, _width*0.18, 24.)
                                                        textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                                        pointSize:12.];
    scheduledRateTitleLabel.textAlignment = NSTextAlignmentRight;
    scheduledRateTitleLabel.text = [NSString stringWithFormat:@"%@：", NSLocalizedString(@"如期率", @"如期率")];
    [self addSubview:scheduledRateTitleLabel];
    
    posX += scheduledRateTitleLabel.frame.size.width;
    
    // 如期率value
    _onSchLabel = [self createLabelWithFrame:CGRectMake(posX, posY, _width*0.18, 24.)
                                   textColor:[[MDirector sharedInstance] getCustomGrayColor]
                                   pointSize:12.];
    [self addSubview:_onSchLabel];
    
    // 事件提醒
    _button = [self createRemindButtonWithFrame:CGRectMake(_width*0.8, 0, _width*0.2, HeightForMonitorDetailTableCell)];
    [self addSubview:_button];
    
}

- (UILabel*)createLabelWithFrame:(CGRect)frame textColor:(UIColor*)color pointSize:(CGFloat)pointSize
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:pointSize];
    label.textColor = color;
    
    return label;
}

- (UIButton*)createRemindButtonWithFrame:(CGRect)frame
{
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:@"icon_alarm.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(16, _width*0.1 - 14, 16, _width*0.1 - 14)];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* eventCountView = [self createCountCircleWithFrame:CGRectMake(button.frame.size.width / 2. + 2, 14, 15, 15)];
    [button addSubview:eventCountView];
    
    return button;
}

- (UIView*)createCountCircleWithFrame:(CGRect)frame
{
    // red circle
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"icon_red_circle.png"];
    
    // 事件數量
    _countLabel = [self createLabelWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                   textColor:[UIColor whiteColor]
                                   pointSize:8.];
    _countLabel.font = [UIFont boldSystemFontOfSize:9.];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:_countLabel];
    
    return imageView;
}

- (void)prepare
{
    [self calculateDateBetween];
    
    _actLabel.text = _activity.name;
    _statusLabel.text = [self getStatusString];
    
    _onSchLabel.text = [NSString stringWithFormat:@"%.0f%%", _onSchRate];
    _onSchLabel.textColor = (_delay) ? [UIColor redColor] : [[MDirector sharedInstance] getForestGreenColor];
    
    NSInteger count = [[MDataBaseManager sharedInstance] loadEventsCountWithCustActivity:_activity];
    _button.hidden = (count == 0);
    
    _countLabel.text = [NSString stringWithFormat:@"%d", (int)count];
    
}

- (NSString*)getStatusString
{
    if(!_begin)
        return NSLocalizedString(@"未開始", @"未開始");
    if(_dateBetween == 0)
        return NSLocalizedString(@"準時", @"準時");
    if(_dateBetween > 0)
        return [NSString stringWithFormat:@"%@(%d天)", NSLocalizedString(@"提前", @"提前"), (int)_dateBetween];
    if(_dateBetween < 0)
        return [NSString stringWithFormat:@"%@(%d天)", NSLocalizedString(@"延宕", @"延宕"), (int)_dateBetween*-1];
    return @"";
}

//計算剩餘日
- (void)calculateDateBetween
{
    _begin = NO;
    _delay = NO;
    _dateBetween = 0;
    _onSchRate = 0.;
    
    if(_activity.workItemArray.count == 0)
        return;
    
    NSInteger count = 0;  //有如期完成的工作項目數量
    
    for (MCustWorkItem* item in _activity.workItemArray) {
        
        NSDateFormatter* fm = [NSDateFormatter new];
        fm.dateFormat = @"yyyy-MM-dd";
        NSDate* date = [fm dateFromString:item.custTarget.completeDate];
    
        NSTimeInterval between = [date timeIntervalSinceNow];
        
        // 判斷是否已經delay
        if(between < 0)
            _delay = YES;
        else
            count ++;
        
        // 判斷是否已開始進行
        if(![item.status isEqualToString:@"0"])
            _begin = YES;
        
        // 取得最大 延宕/提前 天數
        _dateBetween = (_delay) ? MIN(_dateBetween, between) : MAX(_dateBetween, between);
        _dateBetween /= 86400;
    }
    
    // 計算如期率
    _onSchRate = 100. * count / _activity.workItemArray.count;
}

#pragma mark - Button Actions

- (void)buttonClicked:(UIButton*)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(tableVuewCell:didClickedBellButton:)])
        [_delegate tableVuewCell:self didClickedBellButton:sender];
}


@end
