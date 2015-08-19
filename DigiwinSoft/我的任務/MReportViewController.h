//
//  MReportViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/7.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"
#import "MCustActivity.h"
#import "MCustWorkItem.h"

@interface MReportViewController : UIViewController
@property (nonatomic, strong)id task;

- (id)initWithCustGuide:(MCustGuide*)guide;
- (id)initWithCustActivity:(MCustActivity*)activity;
- (id)initWithCustWorkItem:(MCustWorkItem*)workitem;

@end
