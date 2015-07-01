//
//  MRaidersDiagramTableViewCell.h
//  DigiwinSoft
//
//  Created by kenn on 2015/6/26.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRaidersDiagramTableViewCell : UITableViewCell
@property (nonatomic, weak) UILabel *labActivity;
@property (nonatomic, weak) UILabel *labSubActivity;

@property (nonatomic, weak) UILabel *labWorkItem;
@property (nonatomic, weak) UILabel *labSubWorkItem;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
