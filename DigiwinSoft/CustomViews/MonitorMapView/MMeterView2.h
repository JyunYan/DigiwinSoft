//
//  MMeterView2.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/30.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIssue.h"

#define CORNRADIUS_INNER  7
#define CORNRADIUS_OUTER  10

@interface MMeterView2 : UIView

@property (nonatomic, assign) CGPoint endPoint; // 最右邊的point
@property (nonatomic, strong) MIssue* issue;

@end
