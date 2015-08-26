//
//  MRaidersTableCell.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/15.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MRaidersTableCell.h"

@implementation MRaidersTableCell

- (UIButton*)createButtonWithImage:(UIImage*)image frame:(CGRect)frame
{
    CGFloat left = (frame.size.width - 24.) / 2.;
    CGFloat top = (frame.size.height - 24.) / 2.;
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, top, left)];
    
    return button;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.textAlignment = textAlignment;
    
    return label;
}

- (UIImage*)imageWithCustTarget2:(MCustTarget*)taregt
{
    
    NSString* end = taregt.completeDate;
    BOOL b = (end && ![end isEqualToString:@""]);
    
    if(b)
        return [UIImage imageNamed:@"icon_menu_8_blue.png"];
    else
        return [UIImage imageNamed:@"icon_menu_8.png"];
}

- (UIImage*)imageWithCustTarget:(MCustTarget*)taregt
{
    NSString* start = taregt.startDate;
    BOOL b1 = (start && ![start isEqualToString:@""]);
    
    NSString* end = taregt.completeDate;
    BOOL b2 = (end && ![end isEqualToString:@""]);
    
    if(b1 && b2)
        return [UIImage imageNamed:@"icon_menu_8_blue.png"];
    else
        return [UIImage imageNamed:@"icon_menu_8.png"];
}

@end

/** 對策 **/
@interface MGuideTableCell ()

@property (nonatomic, strong) UIImageView* checkBox;
@property (nonatomic, strong) NSMutableArray* stars;

@end

@implementation MGuideTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size
{
    static NSString *identifier = @"MGuideTableCell";
    MGuideTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MGuideTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier size:size];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat offset = 0;
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, width * 0.45, height)];
        [self addSubview:view];
        
        // check box
        _checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 18, 18)];
        _checkBox.image = [UIImage imageNamed:@"checkbox_empty.png"];
        [view addSubview:_checkBox];
        
        //標題
        self.labName = [self createLabelWithFrame:CGRectMake(30, 8, view.frame.size.width - 30, 30)
                                             font:[UIFont systemFontOfSize:14.]
                                    textAlignment:NSTextAlignmentLeft];
        [view addSubview:self.labName];
        
        //評價
        _stars = [NSMutableArray new];
        for (int i=0; i<5; i++) {
            UIImageView* star = [[UIImageView alloc] initWithFrame:CGRectMake(30+i*17, 32, 16, 16)];
            star.image = [UIImage imageNamed:@"star_empty.png"];
            [view addSubview:star];
            [_stars addObject:star];
        }
        
        offset += view.frame.size.width;
        
        //指派負責人
        self.btnManager = [self createButtonWithImage:[UIImage imageNamed:@"icon_manager.png"]
                                            frame:CGRectMake(offset, 0, width * 0.18, height)];
        self.btnManager.imageView.layer.cornerRadius = self.btnManager.imageView.frame.size.width / 2;
        self.btnManager.imageView.clipsToBounds = YES;;
        [self.btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnManager];
        
        //負責人name
        self.managerLabel = [self createLabelWithFrame:CGRectMake(offset, height - 16, self.btnManager.frame.size.width, 16)
                                                  font:[UIFont systemFontOfSize:12.]
                                         textAlignment:NSTextAlignmentCenter];
        [self addSubview:self.managerLabel];
        
        offset += self.btnManager.frame.size.width;
        
        //目標設定
        self.btnTargetSet = [self createButtonWithImage:[UIImage imageNamed:@"icon_menu_8.png"]
                                              frame:CGRectMake(offset, 0, width * 0.18, height)];
        [self.btnTargetSet addTarget:self action:@selector(btnTargetSet:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnTargetSet];
        
        offset += self.btnTargetSet.frame.size.width;
        
        //攻略
        self.btnRaiders = [self createButtonWithImage:[UIImage imageNamed:@"icon_raider.png"]
                                            frame:CGRectMake(offset, 0, width * 0.18, height)];
        [self.btnRaiders addTarget:self action:@selector(btnRaiders:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnRaiders];
    }
    return self;
}

- (void)btnManager:(id)sender
{
    if(_delegateG && [_delegateG respondsToSelector:@selector(btnManagerClicked:)])
        [_delegateG btnManagerClicked:self];
}

- (void)btnTargetSet:(id)sender
{
    if(_delegateG && [_delegateG respondsToSelector:@selector(btnTargetSetClicked:)])
        [_delegateG btnTargetSetClicked:self];
}

- (void)btnRaiders:(id)sender
{
    if(_delegateG && [_delegateG respondsToSelector:@selector(btnRaidersClicked:)])
        [_delegateG btnRaidersClicked:self];
}

- (void)prepareWithGuide:(MCustGuide*)guide
{
    self.checkBox.image = (guide.isCheck) ? [UIImage imageNamed:@"checkbox_fill.png"] : [UIImage imageNamed:@"checkbox_empty.png"];
    self.labName.text = guide.name;
    
    NSString* uuid= guide.manager.uuid;
    if(uuid && ![uuid isEqualToString:@""]){
        [self.btnManager setImage:[UIImage imageNamed:@"z_thumbnail.jpg"] forState:UIControlStateNormal];
        self.managerLabel.text = guide.manager.name;
    }else{
        [self.btnManager setImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        self.managerLabel.text = @"";
    }
    
    // 目標設定button
    UIImage* image = [self imageWithCustTarget2:guide.custTaregt];
    [self.btnTargetSet setImage:image forState:UIControlStateNormal];
    
    // star
    NSInteger count = [guide.review integerValue];
    for (int i=0;i<_stars.count;i++) {
        UIImageView* star = [_stars objectAtIndex:i];
        if(i < count)
            star.image = [UIImage imageNamed:@"star_fill.png"];
        else
            star.image = [UIImage imageNamed:@"star_empty.png"];
    }
}

@end


/** 關鍵活動 **/
@implementation MActivityTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size
{
    static NSString *identifier = @"MActivityTableCell";
    MActivityTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MActivityTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier size:size];
    }

    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        CGFloat offset = 10.;
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        //標題
        self.labName = [self createLabelWithFrame:CGRectMake(offset, 0, width * 0.45 - offset, height)
                                             font:[UIFont systemFontOfSize:14.]
                                    textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.labName];

        offset += self.labName.frame.size.width;
        
        //指派負責人
        self.btnManager = [self createButtonWithImage:[UIImage imageNamed:@"icon_manager.png"]
                                                frame:CGRectMake(offset, 0, width * 0.18, height)];
        self.btnManager.imageView.layer.cornerRadius = self.btnManager.imageView.frame.size.width / 2;
        self.btnManager.imageView.clipsToBounds = YES;;
        [self.btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnManager];
        
        //負責人name
        self.managerLabel = [self createLabelWithFrame:CGRectMake(offset, height - 16, self.btnManager.frame.size.width, 16)
                                                  font:[UIFont systemFontOfSize:12.]
                                         textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.managerLabel];
        
        offset += self.btnManager.frame.size.width;
        
        //目標設定
        self.btnTargetSet = [self createButtonWithImage:[UIImage imageNamed:@"icon_menu_8.png"]
                                                  frame:CGRectMake(offset, 0, width * 0.18, height)];
        [self.btnTargetSet addTarget:self action:@selector(btnTargetSet:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnTargetSet];
        
        offset += self.btnTargetSet.frame.size.width;
        
        //攻略
        self.btnRaiders = [self createButtonWithImage:[UIImage imageNamed:@"icon_raider.png"]
                                                frame:CGRectMake(offset, 0, width * 0.18, height)];
        [self.btnRaiders addTarget:self action:@selector(btnRaiders:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnRaiders];
        
    }
    return self;
}

- (void)btnManager:(id)sender
{
    if(_delegateA && [_delegateA respondsToSelector:@selector(btnManagerClicked:)])
        [_delegateA btnManagerClicked:self];
}

- (void)btnTargetSet:(id)sender
{
    if(_delegateA && [_delegateA respondsToSelector:@selector(btnTargetSetClicked:)])
        [_delegateA btnTargetSetClicked:self];
}

- (void)btnRaiders:(id)sender
{
    if(_delegateA && [_delegateA respondsToSelector:@selector(btnRaidersClicked:)])
        [_delegateA btnRaidersClicked:self];
}

- (void)prepareWithCustActivity:(MCustActivity*)activity
{
    //標題
    self.labName.text = activity.name;
    
    //負責人image
    NSString* uuid= activity.manager.uuid;
    if(uuid && ![uuid isEqualToString:@""]){
        [self.btnManager setImage:[UIImage imageNamed:@"z_thumbnail.jpg"] forState:UIControlStateNormal];
        self.managerLabel.text = activity.manager.name;
    }else{
        [self.btnManager setImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        self.managerLabel.text = @"";
    }
    
    // 目標設定button
    UIImage* image = [self imageWithCustTarget:activity.custTarget];
    [self.btnTargetSet setImage:image forState:UIControlStateNormal];
}

@end

/** 工作項目 **/
@implementation MWorkItemTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size
{
    static NSString *identifier = @"MWorkItemTableCell";
    MWorkItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MWorkItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier size:size];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        CGFloat offset = 10.;
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        //標題
        self.labName = [self createLabelWithFrame:CGRectMake(offset, 0, width * 0.6 - offset, height)
                                             font:[UIFont systemFontOfSize:14.]
                                    textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.labName];
        
        offset += self.labName.frame.size.width;
        
        //指派負責人
        self.btnManager = [self createButtonWithImage:[UIImage imageNamed:@"icon_manager.png"]
                                                frame:CGRectMake(offset, 0, width * 0.2, height)];
        self.btnManager.imageView.layer.cornerRadius = self.btnManager.imageView.frame.size.width / 2;
        self.btnManager.imageView.clipsToBounds = YES;;
        [self.btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnManager];
        
        //負責人name
        self.managerLabel = [self createLabelWithFrame:CGRectMake(offset, height - 16, self.btnManager.frame.size.width, 16)
                                                  font:[UIFont systemFontOfSize:12.]
                                         textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.managerLabel];
        
        offset += self.btnManager.frame.size.width;
        
        //目標設定
        self.btnTargetSet = [self createButtonWithImage:[UIImage imageNamed:@"icon_menu_8.png"]
                                                  frame:CGRectMake(offset, 0, width * 0.2, height)];
        [self.btnTargetSet addTarget:self action:@selector(btnTargetSet:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnTargetSet];
    }
    return self;
}

- (void)btnManager:(id)sender
{
    if(_delegateW && [_delegateW respondsToSelector:@selector(btnManagerClicked:)])
        [_delegateW btnManagerClicked:self];
}

- (void)btnTargetSet:(id)sender
{
    if(_delegateW && [_delegateW respondsToSelector:@selector(btnTargetSetClicked:)])
        [_delegateW btnTargetSetClicked:self];
}

- (void)prepareWithCustWorkItem:(MCustWorkItem*)workitem
{
    //標題
    self.labName.text = workitem.name;
    
    //負責人image
    NSString* uuid = workitem.manager.uuid;
    if(uuid && ![uuid isEqualToString:@""]){
        [self.btnManager setImage:[UIImage imageNamed:@"z_thumbnail.jpg"] forState:UIControlStateNormal];
        self.managerLabel.text = workitem.manager.name;
    }else{
        [self.btnManager setImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        self.managerLabel.text = @"";
    }
    
    // 目標設定button
    UIImage* image = [self imageWithCustTarget:workitem.custTarget];
    [self.btnTargetSet setImage:image forState:UIControlStateNormal];
}

@end
