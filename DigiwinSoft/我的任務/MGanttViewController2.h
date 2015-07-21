//
//  MGanttViewController2.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/21.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCustGuide.h"
@interface MGanttViewController2 : UIViewController
@property (nonatomic, strong) MCustGuide* guide;

- (id)initWithCustGuide:(MCustGuide*)guide;
@end
