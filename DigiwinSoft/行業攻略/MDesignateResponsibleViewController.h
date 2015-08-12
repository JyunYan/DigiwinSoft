//
//  MDesignateResponsibleViewController.h
//  DigiwinSoft
//
//  Created by Shihjie Wu on 2015/6/22.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDataBaseManager.h"

@interface MDesignateResponsibleViewController : UIViewController

- (id)initWithGuide:(MCustGuide*)guide;
- (id)initWithCustAvtivity:(MCustActivity*)activity;
- (id)initWithCustWorkItem:(MCustWorkItem*)workitem;

@end
