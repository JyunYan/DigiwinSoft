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

@protocol MTaskRaidersViewControllerDelegate <NSObject>

- (void)didActivityChanged:(MCustActivity*)activity;

@end

@interface MTaskRaidersViewController : UIViewController

@property (nonatomic, assign) NSInteger tabBarExisted;
@property (nonatomic, assign) BOOL bNeedSaved;
@property (nonatomic, strong) id<MTaskRaidersViewControllerDelegate> delegate;

//- (id)initWithCustGuide:(MCustGuide*) guide Index:(NSInteger) index;
- (id)initWithCustActivity:(MCustActivity*)activity;

@end
