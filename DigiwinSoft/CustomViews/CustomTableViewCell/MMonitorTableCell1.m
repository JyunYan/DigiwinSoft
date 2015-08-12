//
//  MMonitorTableCell1.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/28.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMonitorTableCell1.h"
#import "MDirector.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"


@interface MMonitorTableCell1 ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UILabel* title1;  //對策name
@property (nonatomic, strong) UILabel* title2;  //目標name
@property (nonatomic, strong) UILabel* title3;  //負責人name
@property (nonatomic, strong) UILabel* title4;  //完成度
@property (nonatomic, strong) UIImageView* imageView1;  //目標趨勢
@property (nonatomic, strong) UIButton* button1; //電話
@property (nonatomic, strong) MUser* user;

@end

@implementation MMonitorTableCell1

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MMonitorTableCell1";
    MMonitorTableCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        CGFloat width = tableView.frame.size.width;
        cell = [[MMonitorTableCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier width:width];
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
    
    //對策name
    _title1 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.45, 20)];
    _title1.backgroundColor = [UIColor clearColor];
    _title1.font = [UIFont systemFontOfSize:14.];
    _title1.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    [self addSubview:_title1];
    
    posY += _title1.frame.size.height;
    
    //目標name
    _title2 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.45 - 16, 20)];
    _title2.backgroundColor = [UIColor clearColor];
    _title2.font = [UIFont systemFontOfSize:12.];
    _title2.textColor = [[MDirector sharedInstance] getCustomLightGrayColor];
    [self addSubview:_title2];
    
    posX += _title2.frame.size.width;
    
    //目標趨勢
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY+2, 16, 16)];
    _imageView1.backgroundColor = [UIColor clearColor];
    [self addSubview:_imageView1];
    
    posX = _title1.frame.origin.x + _title1.frame.size.width;
    posY = _title1.frame.origin.y;
    
    //負責人name
    _title3 = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, _width*0.2, 16)];
    _title3.backgroundColor = [UIColor clearColor];
    _title3.font = [UIFont systemFontOfSize:14.];
    _title3.textColor = [[MDirector sharedInstance] getCustomGrayColor];
    _title3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title3];
    
    posY += _title3.frame.size.height;
    
    //電話
    _button1 = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 24, 24)];
    _button1.center = CGPointMake(_title3.center.x, _button1.center.y);
    _button1.backgroundColor = [UIColor clearColor];
    [_button1 setImage:[UIImage imageNamed:@"icon_phone.png"] forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(actionTelephone:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button1];
    
    posX += _title3.frame.size.width;
    
    //完成度
    _title4 = [[UILabel alloc] initWithFrame:CGRectMake(posX, 0, _width*0.2, HeightForMonitorTableCell1)];
    _title4.backgroundColor = [UIColor clearColor];
    _title4.font = [UIFont systemFontOfSize:20.];
    _title4.textColor = [[MDirector sharedInstance] getForestGreenColor];
    _title4.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title4];
}

- (void)prepare
{
    CGSize size = [self calculateSizeWithText:_data.guide.custTaregt.name];
    _title2.frame = CGRectMake(_title2.frame.origin.x, _title2.frame.origin.y, size.width, 20);
    _title2.text = _data.guide.custTaregt.name;
    
    _title4.textColor = ([self isDelay]) ? [UIColor redColor] : [[MDirector sharedInstance] getForestGreenColor];
    _title4.text = [NSString stringWithFormat:@"%d%%", (int)_data.completion];
    
    _title1.text = _data.guide.name;
    _title3.text = _data.guide.manager.name;
    
    
    NSString* trend = _data.guide.custTaregt.trend;
    if([trend isEqualToString:@"1"])
        _imageView1.image = [UIImage imageNamed:@"icon_arrow_red"];
    else
        _imageView1.image = [UIImage imageNamed:@"icon_arrow_green"];
    
    _imageView1.frame = CGRectMake(_title2.frame.origin.x + _title2.frame.size.width,
                                   _imageView1.frame.origin.y,
                                   _imageView1.frame.size.width,
                                   _imageView1.frame.size.height);
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

//是否delay
- (BOOL)isDelay
{
    for (MCustActivity* act in _data.guide.activityArray) {
        for (MCustWorkItem* item in act.workItemArray) {
            
            NSDateFormatter* fm = [NSDateFormatter new];
            fm.dateFormat = @"yyyy-MM-dd";
            NSDate* date = [fm dateFromString:item.custTarget.completeDate];
            
            NSTimeInterval between = [date timeIntervalSinceNow];
            
            if(between < 0){
                return YES;
            }
        }
    }
    return NO;
}
- (void)actionTelephone:(UIButton *)button
{
    /*
     NSInteger tag = button.tag;
     NSInteger index = tag - TAG_BUTTON_TELEPHONE;
     MEvent* event = [_eventArray objectAtIndex:index];
     */
    _user = [MDirector sharedInstance].currentUser;

    BOOL isPhone = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]];
    if (isPhone) {
        NSString* url = [@"tel://" stringByAppendingString:_user.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Call Phone Failure" message:@"Your device is not configured to call phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [emailAlert show];
    }
}



@end
