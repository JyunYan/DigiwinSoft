//
//  MIndustryRaidersTableViewCell.m
//  DigiwinSoft
//
//  Created by kenn on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MIndustryRaidersTableViewCell.h"

@interface MIndustryRaidersTableViewCell ()

@property (nonatomic, strong) UILabel* managerLabel;
@property (nonatomic, strong) UIImageView* checkBox;
@property (nonatomic, strong) NSMutableArray* stars;

@end

@implementation MIndustryRaidersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Cell";
    MIndustryRaidersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MIndustryRaidersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat offset = 0;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH * 0.45, 60.)];
        [self addSubview:view];
        
        // check box
        _checkBox = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 18, 18)];
        _checkBox.image = [UIImage imageNamed:@"checkbox_empty.png"];
        [view addSubview:_checkBox];
        
        // 對策
        _labName = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, view.frame.size.width - 30, 30)];
        _labName.backgroundColor =[UIColor clearColor];
        _labName.font = [UIFont systemFontOfSize:14.];
        _labName.textColor = [UIColor blackColor];
        _labName.textAlignment = NSTextAlignmentLeft;
        [view addSubview:_labName];
        
        // 評價
        _stars = [NSMutableArray new];
        for (int i=0; i<5; i++) {
            UIImageView* star = [[UIImageView alloc] initWithFrame:CGRectMake(30+i*17, 32, 16, 16)];
            star.image = [UIImage imageNamed:@"star_empty.png"];
            [view addSubview:star];
            [_stars addObject:star];
        }
        
        offset += view.frame.size.width;
        
        //指派負責人
        _btnManager = [self createButtonWithImage:[UIImage imageNamed:@"icon_manager.png"]
                                                frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH * 0.18, 60.)];
        _btnManager.imageView.layer.cornerRadius = _btnManager.imageView.frame.size.width / 2;
        _btnManager.imageView.clipsToBounds = YES;;
        [_btnManager addTarget:self action:@selector(btnManager:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnManager];
        
        //負責人name
        _managerLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 44, _btnManager.frame.size.width, 16)];
        _managerLabel.backgroundColor = [UIColor clearColor];
        _managerLabel.textColor = [UIColor blackColor];
        _managerLabel.font = [UIFont systemFontOfSize:12.];
        _managerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_managerLabel];

        offset += _btnManager.frame.size.width;
        
        //目標設定
        _btnTargetSet = [self createButtonWithImage:[UIImage imageNamed:@"icon_menu_8.png"]
                                                  frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH * 0.18, 60.)];
        [_btnTargetSet addTarget:self action:@selector(btnTargetSet:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnTargetSet];
        
        offset += _btnTargetSet.frame.size.width;
        
        //攻略
        _btnRaiders = [self createButtonWithImage:[UIImage imageNamed:@"icon_raider.png"]
                                            frame:CGRectMake(offset, 0, DEVICE_SCREEN_WIDTH * 0.18, 60.)];
        [_btnRaiders addTarget:self action:@selector(btnRaiders:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnRaiders];
    }
    return self;
}

#pragma mark - button action methods

- (void)btnManager:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(btnManagerClicked:)])
        [_delegate btnManagerClicked:self];
}

- (void)btnTargetSet:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(btnTargetSetClicked:)])
        [_delegate btnTargetSetClicked:self];
}

- (void)btnRaiders:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(btnRaidersClicked:)])
        [_delegate btnRaidersClicked:self];
}

- (UIButton*)createButtonWithImage:(UIImage*)image frame:(CGRect)frame
{
    CGFloat left = (frame.size.width - 24.) / 2.;
    CGFloat top = (frame.size.height - 24.) / 2.;
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, top, left)];

    return button;
}

- (void)prepareWithGuide:(MGuide*)guide
{
    _checkBox.image = (guide.isCheck) ? [UIImage imageNamed:@"checkbox_fill.png"] : [UIImage imageNamed:@"checkbox_empty.png"];
    _labName.text = guide.name;
    
    NSString* uuid= guide.manager.uuid;
    if(uuid && ![uuid isEqualToString:@""]){
        [_btnManager setImage:[UIImage imageNamed:@"z_thumbnail.jpg"] forState:UIControlStateNormal];
        _managerLabel.text = guide.manager.name;
    }else{
        [_btnManager setImage:[UIImage imageNamed:@"icon_manager.png"] forState:UIControlStateNormal];
        _managerLabel.text = @"";
    }
    
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
