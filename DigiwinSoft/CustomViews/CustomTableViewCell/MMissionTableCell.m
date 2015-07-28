//
//  MMissionTableCell.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MMissionTableCell.h"
#import "MDirector.h"
#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"

@interface MMissionTableCell ()

@property (nonatomic, strong) UIImageView* typeImageView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIButton* button;

@end

@implementation MMissionTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat offset = 10.;
        CGFloat width = 0.;
        //
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, (MISSION_TABLE_CELL_HEIGHT-20.)/2., 20, 20)];
        _typeImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_typeImageView];
        
        offset += _typeImageView.frame.size.width + 10.;
        //
        _label = [[UILabel alloc] initWithFrame:CGRectMake(offset, 0., DEVICE_SCREEN_WIDTH*0.6, MISSION_TABLE_CELL_HEIGHT)];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:14.];
        _label.textColor = [[MDirector sharedInstance] getCustomGrayColor];
        _label.text = @"";
        [self addSubview:_label];
        
        width = DEVICE_SCREEN_WIDTH*0.2;
        offset = DEVICE_SCREEN_WIDTH - width - 10.;
        
        _button = [[UIButton alloc] initWithFrame:CGRectMake(offset, (MISSION_TABLE_CELL_HEIGHT-30.)/2., width, 30)];
        _button.backgroundColor = [[MDirector sharedInstance] getCustomBlueColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:14.];
        _button.titleLabel.textColor = [UIColor whiteColor];
        [_button setTitle:@"接受" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)prepareWithObject:(id)obj segmentIndex:(NSInteger)index
{
    if([obj isKindOfClass:[MCustGuide class]]){
        MCustGuide* guide = (MCustGuide*)obj;
        _typeImageView.image = [UIImage imageNamed:@"icon_menu_11.png"];
        _label.text = guide.name;
        _button.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([obj isKindOfClass:[MCustActivity class]]){
        MCustActivity* activity = (MCustActivity*)obj;
        _typeImageView.image = [UIImage imageNamed:@"icon_menu_9.png"];
        _label.text = activity.name;
        _button.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([obj isKindOfClass:[MCustWorkItem class]]){
        MCustWorkItem* workitem = (MCustWorkItem*)obj;
        _typeImageView.image = [UIImage imageNamed:@"icon_menu_10.png"];
        _label.text = workitem.name;
        
        if(index == 0){
            _button.hidden = NO;
            self.accessoryType = UITableViewCellAccessoryNone;
        }else{
            _button.hidden = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else{
        _typeImageView.image = nil;
        _label.text = @"";
        _button.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

- (void)buttonClicked:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(actionToAccepted:)])
        [_delegate actionToAccepted:self];
}

@end
