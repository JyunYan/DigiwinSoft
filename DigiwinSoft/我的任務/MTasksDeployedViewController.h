//
//  MTasksDeployedViewController.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/7/6.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"

@interface MTasksDeployedViewController : UIViewController
@property (nonatomic, strong) MCustGuide* guide;
- (id)initWithCustGuide:(MCustGuide*) custGuide;

@end
