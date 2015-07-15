//
//  MFlowChartView.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/14.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MActivity.h"
#import "MFlowChartPoint.h"

#define ARROW_DIRECTION_NONE    0
#define ARROW_DIRECTION_UP      1
#define ARROW_DIRECTION_LEFT    2
#define ARROW_DIRECTION_DOWN    3
#define ARROW_DIRECTION_RIGHT   4

@interface MFlowChartView : UIView

- (void)setItems:(NSArray*)array;

@end
