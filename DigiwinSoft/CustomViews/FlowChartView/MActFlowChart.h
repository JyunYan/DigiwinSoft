//
//  MActFlowChart.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/7/23.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIKit/UIKit.h>\

#import "MConfig.h"
#import "MCustActivity.h"
#import "MFlowChartPoint2.h"

#define ARROW_DIRECTION_NONE    0
#define ARROW_DIRECTION_UP      1
#define ARROW_DIRECTION_LEFT    2
#define ARROW_DIRECTION_DOWN    3
#define ARROW_DIRECTION_RIGHT   4

@class MActFlowChart;

@protocol MActFlowChartDelegate <NSObject>
@optional
- (void)actFlowChart:(MActFlowChart*)chart didSelectedActivity:(MCustActivity*)activity;
@end

@interface MActFlowChart : UIView

@property (nonatomic, strong) id<MActFlowChartDelegate> delegate;

- (void)setItems:(NSArray*)array;

@end