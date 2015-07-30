//
//  MMonitorTableCell2.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorTableCell2.h"
#import "MDirector.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"

@interface MMonitorTableCell2 ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UILabel* title1;  //完成日
@property (nonatomic, strong) UILabel* title2;  //對策name
@property (nonatomic, strong) UILabel* title3;  //完成度title
@property (nonatomic, strong) UILabel* title4;  //完成度percent
@property (nonatomic, strong) UIImageView* imageView1;  //負責人頭像

@property (nonatomic, assign) BOOL delay;
@property (nonatomic, assign) NSInteger dateBetween;

@end

@implementation MMonitorTableCell2

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MMonitorTableCell2";
    MMonitorTableCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        CGFloat width = tableView.frame.size.width;
        cell = [[MMonitorTableCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier width:width];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    CGFloat posX = _width*0.05;
    CGFloat posY = 10;
    
    //完成日
    _title1 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.45, 20)];
    _title1.backgroundColor = [UIColor clearColor];
    _title1.font = [UIFont systemFontOfSize:12.];
    _title1.textColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [self addSubview:_title1];
    
    posY += _title1.frame.size.height;
    
    //對策name
    _title2 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.45, 20)];
    _title2.backgroundColor = [UIColor clearColor];
    _title2.font = [UIFont systemFontOfSize:14.];
    _title2.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    [self addSubview:_title2];
    
    posX += _title1.frame.size.width;
    posY =  _title1.frame.origin.y;
    
    //完成度title
    _title3 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.25, 16)];
    _title3.backgroundColor = [UIColor clearColor];
    _title3.font = [UIFont systemFontOfSize:12.];
    _title3.textColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    _title3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title3];
    
    posY += _title3.frame.size.height;
    
    //完成度percent
    _title4 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.25, 24.)];
    _title4.backgroundColor = [UIColor clearColor];
    _title4.font = [UIFont systemFontOfSize:16.];
    _title4.textColor = [[MDirector sharedInstance] getForestGreenColor];
    _title4.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title4];
    
    posX += _title3.frame.size.width;
    posY =  _title3.frame.origin.y;
    
    //負責人頭像
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, 32, 32)];
    _imageView1.center = CGPointMake(_imageView1.center.x, HeightForMonitorTableCell2 / 2.);
    _imageView1.backgroundColor = [UIColor clearColor];
    _imageView1.layer.cornerRadius = _imageView1.frame.size.width / 2;
    _imageView1.clipsToBounds = YES;;
    [self addSubview:_imageView1];
}

- (void)prepare
{
    [self calculateDateBetween];
    
    if(_delay){
        _title1.text = [NSString stringWithFormat:@"延宕%d天", (int)_dateBetween*-1];
        _title4.text = [NSString stringWithFormat:@"%d%%", (int)_data.completion];
        _title4.textColor = [UIColor redColor];
    }else{
        _title1.text = [NSString stringWithFormat:@"剩%d天", (int)_dateBetween];
        _title4.text = [NSString stringWithFormat:@"%d%%", (int)_data.completion];
        _title4.textColor = [[MDirector sharedInstance] getForestGreenColor];
    }
    
    _title2.text = _data.guide.name;
    _title3.text = @"完成度";
    
    _imageView1.image = [UIImage imageNamed:@"z_thumbnail.jpg"];
}

- (CGSize)calculateSizeWithText:(NSString*)text
{
    CGSize maxSize = CGSizeMake(_width*0.45-16, 20);
    UIFont* font = [UIFont systemFontOfSize:12.];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:dict
                                     context:nil].size;
    return size;
}

//剩餘日
- (void)calculateDateBetween
{
    _delay = NO;
    _dateBetween = 0;
    
    for (MCustActivity* act in _data.guide.activityArray) {
        for (MCustWorkItem* item in act.workItemArray) {
            
            NSDateFormatter* fm = [NSDateFormatter new];
            fm.dateFormat = @"yyyy-MM-dd";
            NSDate* date = [fm dateFromString:item.custTarget.completeDate];

            NSTimeInterval between = [date timeIntervalSinceNow];
          
            if(between < 0)
                _delay = YES;
            
            if(_delay)
                _dateBetween = MIN(_dateBetween, between) / 86400;
            else
                _dateBetween = MAX(_dateBetween, between) / 86400;
        }
    }
}

@end
