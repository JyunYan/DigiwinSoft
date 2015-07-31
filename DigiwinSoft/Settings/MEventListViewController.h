//
//  MEventListViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/24.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDataBaseManager.h"

#define FROM_SETTINGS 0
#define FROM_MONITOR  1

@interface MEventListViewController : UIViewController

@property (nonatomic, assign) NSInteger from;

- (id)initWithCustActivity:(MCustActivity*)activity;

@end
