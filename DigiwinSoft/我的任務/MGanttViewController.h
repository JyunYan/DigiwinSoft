//
//  MGanttViewController.h
//  DigiwinSoft
//
//  Created by kenn on 2015/7/17.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"
@interface MGanttViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) MCustGuide* guide;
@end