//
//  MGoalSettingViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/8.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MActivity.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"

@interface MGoalSettingViewController : UITableViewController

- (id)initWithActivityArray:(NSMutableArray*) activityArray Index:(NSInteger) index;

@end
