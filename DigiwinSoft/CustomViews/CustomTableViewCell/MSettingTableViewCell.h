//
//  MSettingTableViewCell.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/1.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSettingTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView size:(CGSize)size;
- (void)prepareWithImage:(NSString*)imgStr title:(NSString*)title number:(NSInteger)number hide:(BOOL)hide;

@end
