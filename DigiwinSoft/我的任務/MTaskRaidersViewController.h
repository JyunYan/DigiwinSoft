//
//  MTaskRaidersViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"
#import "MCustActivity.h"

@interface MTaskRaidersViewController : UIViewController

@property (nonatomic, assign) NSInteger tabBarExisted;

- (id)initWithCustGuide:(MCustGuide*) guide Index:(NSInteger) index;
- (id)initWithCustActivity:(MCustActivity*)activity;

@end
