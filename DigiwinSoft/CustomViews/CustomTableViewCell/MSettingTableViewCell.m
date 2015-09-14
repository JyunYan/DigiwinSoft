//
//  MSettingTableViewCell.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "MSettingTableViewCell.h"

@interface MSettingTableViewCell ()

@property (nonatomic, assign) CGRect tableRect;
@property (nonatomic, strong) UIImageView* numberImageView;
@property (nonatomic, strong) UILabel* numberLabel;

@end

@implementation MSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, 10, 26, 26);
    self.textLabel.frame = CGRectMake(50, 10, 200, 26);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size
{
    static NSString *identifier = @"SettingTableViewCell";
    MSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier size:size];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        
        UIView* bgSelectionView = [[UIView alloc] init];
        bgSelectionView.backgroundColor = [UIColor colorWithRed:53.0f/255.0f green:166.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        bgSelectionView.layer.masksToBounds = YES;
        self.selectedBackgroundView = bgSelectionView;
        
        _numberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - 50, 12, 20, 20)];
        _numberImageView.image = [UIImage imageNamed:@"icon_red_circle.png"];
        _numberImageView.hidden = YES;
        [self addSubview:_numberImageView];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont boldSystemFontOfSize:10.];
        [_numberImageView addSubview:_numberLabel];
        
        //分隔線
        UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0, 43., size.width, 1)];
        separator.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separator];
    }
    return self;
}

- (void)prepareWithImage:(NSString*)imgStr title:(NSString*)title number:(NSInteger)number hide:(BOOL)hide
{
    self.imageView.image = [UIImage imageNamed:imgStr];
    self.textLabel.text = title;
    
    _numberLabel.text = [NSString stringWithFormat:@"%d", (int)number];
    _numberImageView.hidden = hide;
}

@end
